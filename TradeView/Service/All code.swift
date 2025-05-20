////
////  All code.swift
////  TradeView
////
////  Created by Samruddhi Jadhav on 19/5/25.
////
//
//import Foundation
//// MARK: - Models.swift
//
//import Foundation
//
//struct OrderBookEntry: Codable, Identifiable {
//    var id: String { "\(side)-\(price)" }
//    let side: String // "Buy" or "Sell"
//    let size: Int
//    let price: Double
//}
//
//struct OrderBookUpdate: Codable {
//    let table: String
//    let action: String
//    let data: [OrderBookEntry]
//}
//
//
//// MARK: - OrderBookRowViewModel.swift
//
//import Foundation
//
//struct OrderBookRowViewModel: Identifiable {
//    let id: String
//    let side: String
//    let displaySize: String
//    let displayPrice: String
//
//    init(from entry: OrderBookEntry) {
//        self.id = entry.id
//        self.side = entry.side
//        self.displaySize = "\(entry.size)"
//        self.displayPrice = String(format: "%.2f", entry.price)
//    }
//}
//
//
//// MARK: - OrderBookMapper.swift
//
//import Foundation
//
//enum OrderBookMapper {
//    static func map(from jsonString: String) -> [OrderBookRowViewModel]? {
//        guard let data = jsonString.data(using: .utf8) else { return nil }
//        do {
//            let update = try JSONDecoder().decode(OrderBookUpdate.self, from: data)
//            return update.data.map(OrderBookRowViewModel.init)
//        } catch {
//            print("❌ JSON Decoding Error: \(error)")
//            return nil
//        }
//    }
//}
//
//
//// MARK: - WebSocketService.swift
//
//import Foundation
//
//@MainActor
//protocol WebSocketService: AnyObject {
//    func connect()
//    func send(_ message: String) async throws
//    func disconnect()
//    func messageStream() -> AsyncThrowingStream<String, Error>
//}
//
//
//// MARK: - WebSocketManager.swift
//
//final class WebSocketManager: WebSocketService {
//    private var webSocketTask: URLSessionWebSocketTask?
//    private let url = URL(string: "wss://www.bitmex.com/realtime")!
//    private let session: URLSession
//
//    private var isConnected = false
//    private var reconnectAttempts = 0
//    private let maxReconnectDelay: TimeInterval = 60
//
//    private var continuation: AsyncThrowingStream<String, Error>.Continuation?
//
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//
//    func connect() {
//        guard !isConnected else { return }
//
//        webSocketTask = session.webSocketTask(with: url)
//        webSocketTask?.resume()
//        isConnected = true
//        reconnectAttempts = 0
//
//        receiveMessages()
//    }
//
//    private func receiveMessages() {
//        Task {
//            while true {
//                do {
//                    guard let message = try await webSocketTask?.receive() else { return }
//                    switch message {
//                    case .string(let text):
//                        continuation?.yield(text)
//                    case .data(let data):
//                        if let text = String(data: data, encoding: .utf8) {
//                            continuation?.yield(text)
//                        }
//                    @unknown default:
//                        break
//                    }
//                } catch {
//                    print("WebSocket receive error: \(error)")
//                    continuation?.finish(throwing: error)
//                    await reconnect()
//                    break
//                }
//            }
//        }
//    }
//
//    func send(_ message: String) async throws {
//        try await webSocketTask?.send(.string(message))
//    }
//
//    func disconnect() {
//        webSocketTask?.cancel(with: .goingAway, reason: nil)
//        isConnected = false
//    }
//
//    private func reconnect() async {
//        disconnect()
//        reconnectAttempts += 1
//
//        let delay = min(pow(2.0, Double(reconnectAttempts)), maxReconnectDelay)
//        print("🔁 Reconnecting in \(delay) seconds...")
//
//        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
//        connect()
//    }
//
//    func messageStream() -> AsyncThrowingStream<String, Error> {
//        AsyncThrowingStream { continuation in
//            self.continuation = continuation
//        }
//    }
//}
//
//
//// MARK: - OrderBookViewModel.swift
//
//import Foundation
//
//@MainActor
//final class OrderBookViewModel: ObservableObject {
//    @Published var rows: [OrderBookRowViewModel] = []
//
//    private let socketService: WebSocketService
//
//    init(socketService: WebSocketService) {
//        self.socketService = socketService
//    }
//
//    func start() {
//        Task {
//            await socketService.connect()
//            try? await socketService.send("""
//            {
//              \"op\": \"subscribe\",
//              \"args\": [\"orderBookL2:XBTUSD\"]
//            }
//            """)
//
//            for try await message in socketService.messageStream() {
//                if let parsedRows = OrderBookMapper.map(from: message) {
//                    rows.append(contentsOf: parsedRows)
//                }
//            }
//        }
//    }
//}
//
//
//// MARK: - OrderBookView.swift
//
//import SwiftUI
//
//struct OrderBookView: View {
//    @StateObject private var viewModel: OrderBookViewModel
//
//    init(viewModel: OrderBookViewModel) {
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 8) {
//                HStack {
//                    Text("Buy Orders")
//                        .font(.headline)
//                        .foregroundColor(.green)
//                    Spacer()
//                    Text("Sell Orders")
//                        .font(.headline)
//                        .foregroundColor(.red)
//                }
//                .padding(.horizontal)
//
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
//                        let buys = viewModel.rows.filter { $0.side == "Buy" }.sorted(by: { $0.displayPrice > $1.displayPrice }).prefix(20)
//                        let sells = viewModel.rows.filter { $0.side == "Sell" }.sorted(by: { $0.displayPrice < $1.displayPrice }).prefix(20)
//
//                        ForEach(0..<max(buys.count, sells.count), id: \.self) { index in
//                            HStack {
//                                if index < buys.count {
//                                    OrderRowView(row: buys[index], alignment: .leading)
//                                } else {
//                                    Spacer()
//                                }
//                            }
//
//                            HStack {
//                                if index < sells.count {
//                                    OrderRowView(row: sells[index], alignment: .trailing)
//                                } else {
//                                    Spacer()
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            .navigationTitle("Order Book")
//            .task {
//                viewModel.start()
//            }
//        }
//    }
//}
//
//struct OrderRowView: View {
//    let row: OrderBookRowViewModel
//    let alignment: HorizontalAlignment
//
//    var body: some View {
//        VStack(alignment: alignment, spacing: 4) {
//            Text("Price: \(row.displayPrice)")
//                .font(.caption)
//                .foregroundColor(row.side == "Buy" ? .green : .red)
//            Text("Size: \(row.displaySize)")
//                .font(.caption2)
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .trailing)
//        .padding(4)
//        .background(Color(.systemGray6))
//        .cornerRadius(6)
//    }
//}
//
//
//final class MockWebSocketService: WebSocketService {
//    private var subject = AsyncThrowingStream<String, Error>.makeStream()
//    private(set) var sentMessages: [String] = []
//    private(set) var isConnected = false
//
//    func connect() {
//        isConnected = true
//        simulateIncoming()
//    }
//
//    func send(_ message: String) async throws {
//        sentMessages.append(message)
//    }
//
//    func disconnect() {
//        isConnected = false
//        subject.continuation.finish()
//    }
//
//    func messageStream() -> AsyncThrowingStream<String, Error> {
//        return subject.stream
//    }
//
//    private func simulateIncoming() {
//        Task {
//            try await Task.sleep(nanoseconds: 1_000_000_000)
//            subject.continuation.yield("""
//            {
//                \"table\": \"orderBookL2\",
//                \"action\": \"update\",
//                \"data\": [
//                    { \"side\": \"Buy\", \"size\": 1000, \"price\": 19890.5 },
//                    { \"side\": \"Sell\", \"size\": 500, \"price\": 19895.0 }
//                ]
//            }
//            """)
//        }
//    }
//}


//// MARK: - App Entry Point (BitBookApp.swift)
//
//import SwiftUI
//
//@main
//struct BitBookApp: App {
//    var body: some Scene {
//        WindowGroup {
//            OrderBookView(
//                viewModel: OrderBookViewModel(
//                    socketService: WebSocketManager()
//                )
//            )
//        }
//    }
//}
