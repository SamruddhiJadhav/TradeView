//
//  RecentTradesViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

@MainActor
final class RecentTradesViewModel: ObservableObject {

    private let socketService = WebSocketManager()
    @Published var recentTrades = [RecentTradePresentationModel]()
    
    func onAppear() {
        Task {
            await connectSocket()
            try? await subscribeToOrderBook()
            try? await listenForMessages()
        }
    }
    
    func onDisappear() {
        Task {
            await socketService.disconnect()
        }
    }
}

private extension RecentTradesViewModel {
    func connectSocket() async {
        await socketService.connect()
    }
    
    func subscribeToOrderBook() async throws {
        try? await socketService.send(SocketMessages.recentTradeSubscribe)
    }
    
    func listenForMessages() async throws {
        let stream = await socketService.messageStream()
        for try await message in stream {
            guard let update = RecentTradeMapper.map(from: message) else { continue }
            updateRecentTrades(update: update)
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
