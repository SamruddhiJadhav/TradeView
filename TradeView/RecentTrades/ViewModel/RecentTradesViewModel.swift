//
//  RecentTradesViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

final class RecentTradesViewModel: ObservableObject {
    private let socketService = WebSocketManager()
    @Published var recentTrades = [RecentTradePresentationModel]()
    
    
    func connectSocket() {
        Task {
            await socketService.connect()
            let subscribeMessage = """
            {
              "op": "subscribe",
              "args": ["trade:XBTUSD"]
            }
            """
            
            try? await socketService.send(subscribeMessage)

            let stream = await socketService.messageStream()
            for try await message in stream {
                guard let update = RecentTradeMapper.map(from: message) else { continue }
                
                let newTrades = update.data.map { entry in
                    print(entry)
                    return RecentTradePresentationModel(
                        id: entry.trdMatchID,
                        price: entry.price,
                        timestamp: entry.timestamp,
                        quantity: entry.size,
                        side: entry.side
                    )
                }
                
//                let sortedLimitedTrades = await Self.processTrades(newTrades + self.recentTrades)
//
//                await MainActor.run {
//                    self.recentTrades = sortedLimitedTrades
//                }
                
                await MainActor.run {
                    let combined = (newTrades + self.recentTrades)
                        .sorted(by: { $0.timestamp > $1.timestamp })
                        .prefix(30)
                    self.recentTrades = Array(combined)
                }
            }
        }
    }
    
    static func processTrades(_ all: [RecentTradePresentationModel]) async -> [RecentTradePresentationModel] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let result = all
                    .sorted(by: { $0.timestamp > $1.timestamp })
                    .prefix(30)
                    .map { $0 }
                continuation.resume(returning: Array(result))
            }
        }
    }

    func disconnectSocket() {
//        Task {
//            await socketService.disconnect()
//            recentTrades = []
//        }
    }
}
