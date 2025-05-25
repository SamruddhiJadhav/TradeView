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
    private var continuations: [UUID: AsyncThrowingStream<String, Error>.Continuation] = [:]

    private var isConnected = false


    init(session: URLSession = .shared, url: URL = AppConfig.API.bitmexWebSocketURL) {
        self.session = session
        self.url = url
    }

    func connectIfNeeded() async {
        guard !isConnected || webSocketTask?.state != .running else {
            AppLogger.socket.debug("WebSocket is already connected")
            return
        }

        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
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
        webSocketTask = nil
        isConnected = false
        continuations.values.forEach { $0.finish() }
        continuations.removeAll()
    }

    func messageStream() async -> AsyncThrowingStream<String, Error> {
        let id = UUID()
        return AsyncThrowingStream { continuation in
            continuations[id] = continuation
            AppLogger.socket.debug("Message stream subscribed. ID: \(id)")

            continuation.onTermination = { [weak self] _ in
                Task {
                    await self?.removeContinuation(for: id)
                }
            }
        }
    }
}

private extension WebSocketManager {
    func removeContinuation(for id: UUID) {
        continuations.removeValue(forKey: id)
        AppLogger.socket.debug("Message stream removed. ID: \(id)")
    }

    func receiveMessages() {
        Task {
            while true {
                do {
                    guard let message = try await webSocketTask?.receive() else {
                        AppLogger.socket.error("WebSocket receive returned nil.")
                        return
                    }

                    let text: String
                    switch message {
                    case .string(let string):
                        text = string
                    case .data(let data):
                        text = String(data: data, encoding: .utf8) ?? ""
                    @unknown default:
                        AppLogger.socket.error("Received unknown WebSocket message.")
                        continue
                    }

                    for continuation in continuations.values {
                        continuation.yield(text)
                    }

                } catch {
                    AppLogger.socket.error("WebSocket received error: \(error.localizedDescription)")
                    for continuation in continuations.values {
                        continuation.finish(throwing: error)
                    }
                    continuations.removeAll()
                    isConnected = false
                    break
                }
            }
        }
    }
}
