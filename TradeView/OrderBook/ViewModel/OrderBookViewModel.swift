//
//  OrderBookViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

@MainActor // should whole class be mainActor or only dispatch
final class OrderBookViewModel: ObservableObject {
    @Published var buyRows: [OrderBookRowPresentationModel] = []
    @Published var sellRows: [OrderBookRowPresentationModel] = []

    private var orderBookDict: [UInt64: OrderBookEntry] = [:] // eviction policy
    private let socketService = WebSocketManager()

//    init(socketService: WebSocketService) {
//        self.socketService = socketService
//    }

    func start() {
        Task {
            await socketService.connect()
            let subscribeMessage = """
            {
              "op": "subscribe",
              "args": ["orderBookL2:XBTUSD"]
            }
            """
            
            try? await socketService.send(subscribeMessage)
            
//            try? await socketService.send("""
//            {
//              \"op\": \"subscribe\",
//              \"args\": [\"orderBookL2:XBTUSD\"]
//            }
//            """)

            let stream = await socketService.messageStream()
            for try await message in stream {
                guard let update = OrderBookMapper.map(from: message) else { continue }

                switch update.action {
                case "partial":
                    orderBookDict = Dictionary(uniqueKeysWithValues: update.data.map { ($0.id, $0) })

                case "insert":
                    for entry in update.data {
                        orderBookDict[entry.id] = entry
                    }

                case "update":
                    for entry in update.data {
                        if var existing = orderBookDict[entry.id], let newSize = entry.size {
                            existing.size = newSize
                            orderBookDict[entry.id] = existing
                        }
                    }

                case "delete":
                    for entry in update.data {
                        orderBookDict.removeValue(forKey: entry.id)
                    }

                default:
                    break
                }

                // Data source builder??
                // Buy Orders (Descending)
                // Need to fix recent 20 trades
                buyRows = orderBookDict.values
                    .filter { $0.side == .buy }
                    .sorted { $0.price > $1.price }
                    .prefix(20)
                    .map {
                        OrderBookRowPresentationModel(from: $0)
                }

                // Sell Orders (Ascending)
                sellRows = orderBookDict.values
                    .filter { $0.side == .sell }
                    .sorted { $0.price < $1.price }
                    .prefix(20)
                    .map {
                        OrderBookRowPresentationModel(from: $0)
                }
            }
        }
    }
}
