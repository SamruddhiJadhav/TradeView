//
//  OrderBookViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

//    init(socketService: WebSocketService) {
//        self.socketService = socketService
//    }
// should whole class be mainActor or only dispatch

@MainActor
final class OrderBookViewModel: ObservableObject {
    @Published var buyRows: [OrderBookRowPresentationModel] = []
    @Published var sellRows: [OrderBookRowPresentationModel] = []

    private var orderBookDict: [UInt64: OrderBookEntry] = [:] // eviction policy
    private let socketService = WebSocketManager()

    func start() {
        Task {
            await connectSocket()
            try? await subscribeToOrderBook()
            try? await listenForMessages()
        }
    }
}

private extension OrderBookViewModel {
    func connectSocket() async {
        await socketService.connect()
    }
    
    func subscribeToOrderBook() async throws {
        try? await socketService.send(SocketMessages.orderBookSubscribe)
    }
    
    func listenForMessages() async throws {
        let stream = await socketService.messageStream()
        for try await message in stream {
            guard let update = OrderBookMapper.map(from: message) else { continue }
        
            applyOrderBookUpdate(update)
            
            buyRows = buildPresentationModel(for: .buy)
            sellRows = buildPresentationModel(for: .sell)
        }
    }
    
    func applyOrderBookUpdate(_ update: OrderBookUpdate) {
        switch update.action {
        case .partial:
            orderBookDict = Dictionary(uniqueKeysWithValues: update.data.map { ($0.id, $0) })
            
        case .insert:
            for entry in update.data {
                orderBookDict[entry.id] = entry
            }
            
        case .update:
            for entry in update.data {
                if var existing = orderBookDict[entry.id] {
                    existing.size = entry.size
                    orderBookDict[entry.id] = existing
                }
            }
            
        case .delete:
            for entry in update.data {
                orderBookDict.removeValue(forKey: entry.id)
            }
        }
    }

    func buildPresentationModel(for tradeSide: TradeSide) -> [OrderBookRowPresentationModel] {
        var accumulatedSize = 0
        var maxSize = 0

        let sortedEntries = orderBookDict.values
            .filter { $0.side == tradeSide }
            .sorted { tradeSide == .buy ? $0.price > $1.price : $0.price < $1.price }
            .prefix(20)
        
        sortedEntries.forEach { entry in
            maxSize += entry.size
        }

        return sortedEntries.map {
            accumulatedSize += $0.size
            return OrderBookRowPresentationModel(from: $0, accumulatedSizeRatio: Double(accumulatedSize) / Double(maxSize))
        }
    }
}
