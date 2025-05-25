//
//  WebSocketManager.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 19/5/25.
//

import Foundation

final actor WebSocketManager: WebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url: URL
    private let session: URLSession
    private var continuation: AsyncThrowingStream<String, Error>.Continuation?

    private var isConnected = false
    private var reconnectAttempts = 0
    private let maxReconnectDelay: TimeInterval = 60
    private let reconnectBaseDelay: TimeInterval = 2.0
    private let nanosecondsPerSecond: UInt64 = 1_000_000_000
    private let maxReconnectAttempts = 5

    init(session: URLSession = .shared, url: URL = AppConfig.API.bitmexWebSocketURL) {
        self.session = session
        self.url = url
    }

    func connect() async {
        guard !isConnected else {
            AppLogger.socket.debug("WebSocket is aleardy connected")
            return
        }

        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        reconnectAttempts = 0
        AppLogger.socket.debug("WebSocket connected to \(self.url.absoluteString)")

        receiveMessages()
    }

    func send(_ message: String) async throws {
        AppLogger.socket.debug("Sending message: \(message)")
        try await webSocketTask?.send(.string(message))
    }

    func disconnect() async {
        AppLogger.socket.debug("Disconnecting WebSocket.")
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
        continuation?.finish()
        continuation = nil
    }

    func messageStream() async -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            self.continuation = continuation
            AppLogger.socket.debug("Message stream subscribed.")
        }
    }
}

private extension WebSocketManager {
    func receiveMessages() {
        Task {
            while true {
                do {
                    guard let message = try await webSocketTask?.receive() else {
                        AppLogger.socket.error("WebSocket receive returned nil.")
                        return
                    }
                    switch message {
                    case .string(let text):
                        AppLogger.socket.debug("Received text: \(text.prefix(80))...")
                        continuation?.yield(text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            AppLogger.socket.debug("Received data: \(text.prefix(80))...")
                            continuation?.yield(text)
                        }
                    @unknown default:
                        AppLogger.socket.error("Received unknown message format.")
                    }
                } catch {
                    AppLogger.socket.error("WebSocket received error: \(error.localizedDescription)")
                    continuation?.finish(throwing: error)
                    await reconnect()
                    break
                }
            }
        }
    }
    
    func reconnect() async {
        guard reconnectAttempts < maxReconnectAttempts else {
            AppLogger.socket.error("Reached max reconnect attempts. Giving up.")
            return
        }

        await disconnect()
        reconnectAttempts += 1

        let delay = min(pow(reconnectBaseDelay, Double(reconnectAttempts)), maxReconnectDelay)
        
        AppLogger.socket.debug("Attempting to reconnect in \(delay) seconds (attempt \(self.reconnectAttempts))")

        try? await Task.sleep(nanoseconds: UInt64(delay * Double(nanosecondsPerSecond)))
        await connect()
    }
}
