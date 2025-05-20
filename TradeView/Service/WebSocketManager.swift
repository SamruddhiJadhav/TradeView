//
//  WebSocketManager.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 19/5/25.
//

import Foundation

final actor WebSocketManager: WebSocketService {
    private var webSocketTask: URLSessionWebSocketTask?
    private let url = URL(string: "wss://www.bitmex.com/realtime")!
    private let session: URLSession
    private var continuation: AsyncThrowingStream<String, Error>.Continuation?

    private var isConnected = false
    private var reconnectAttempts = 0
    private let maxReconnectDelay: TimeInterval = 60

    init(session: URLSession = .shared) {
        self.session = session
    }

    func connect() async {
        guard !isConnected else { return }

        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnected = true
        reconnectAttempts = 0

        receiveMessages()
    }

    private func receiveMessages() {
        Task {
            while true {
                do {
                    guard let message = try await webSocketTask?.receive() else { return }
                    switch message {
                    case .string(let text):
                        continuation?.yield(text)
                    case .data(let data):
                        if let text = String(data: data, encoding: .utf8) {
                            continuation?.yield(text)
                        }
                    @unknown default:
                        break
                    }
                } catch {
                    continuation?.finish(throwing: error)
                    await reconnect()
                    break
                }
            }
        }
    }

    func send(_ message: String) async throws {
        try await webSocketTask?.send(.string(message))
    }

    func disconnect() async {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
        continuation?.finish()
    }

    private func reconnect() async {
        await disconnect()
        reconnectAttempts += 1

        let delay = min(pow(2.0, Double(reconnectAttempts)), maxReconnectDelay)
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        await connect()
    }

    func messageStream() async -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            self.continuation = continuation
        }
    }
}
