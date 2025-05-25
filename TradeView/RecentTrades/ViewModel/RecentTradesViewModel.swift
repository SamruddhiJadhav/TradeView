//
//  RecentTradesViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

@MainActor
final class RecentTradesViewModel: ObservableObject {

    @Published var recentTrades = [RecentTradePresentationModel]()
    
    private let socketService: WebSocketService
    private var listenTask: Task<Void, Never>?
    
    init(socketService: WebSocketService) {
        self.socketService = socketService
    }
    
    func onAppear() {
        listenTask = Task {
            await connectSocket()
            try? await subscribeToRecentTrades()
            await listenForMessages()
        }
    }
    
    func onDisappear() {
        listenTask?.cancel()
        listenTask = nil

        Task {
            try? await unsubscribeFromRecentTrades()
        }
    }
}

private extension RecentTradesViewModel {
    func connectSocket() async {
        await socketService.connectIfNeeded()
    }
    
    func subscribeToRecentTrades() async throws {
        try await socketService.send(SocketMessages.recentTradeSubscribe)
    }

    func unsubscribeFromRecentTrades() async throws {
        try await socketService.send(SocketMessages.recentTradeUnsubscribe)
    }

    func listenForMessages() async {
        let stream = await socketService.messageStream()
        do {
            for try await message in stream {
                guard let update = RecentTradeMapper.map(from: message) else { continue }
                updateRecentTrades(update: update)
            }
        } catch {
            AppLogger.socket.error("Error while listening to recent trades: \(error)")
        }
    }

    func updateRecentTrades(update: RecentTradeUpdate) {
        let newTrades = update.data.map { entry in
            RecentTradePresentationModel(
                id: entry.trdMatchID,
                price: entry.price,
                timestamp: entry.timestamp,
                quantity: entry.size,
                side: entry.side,
                isHighlighted: true
            )
        }

        let combined = (newTrades + self.recentTrades)
            .sorted(by: { $0.timestamp > $1.timestamp })
            .prefix(30)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            self.recentTrades = self.recentTrades.map {
                var model = $0
                model.isHighlighted = false
                return model
            }
        }

        self.recentTrades = Array(combined)
    }
}

