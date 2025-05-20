//
//  OrderBookViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

//final class OrderBookViewModel: ObservableObject {
//    @Published var buyOrders = (1...20).map { Order(price: Double(100 - $0), size: Double.random(in: 1...100)) }
//    @Published var sellOrders = (1...20).map { Order(price: Double(100 + $0), size: Double.random(in: 1...100)) }
////    var volumeWidth: CGFloat {
////        CGFloat(order.size / maxSize)
////    }
//    
////    @Published var maxSize: Double {
////        max((buyOrders + sellOrders).map { $0.size }.max() ?? 1, 1)
////    }
//}

@MainActor
final class OrderBookViewModel: ObservableObject {
    @Published var buyRows: [OrderBookRowViewModel] = []
    @Published var sellRows: [OrderBookRowViewModel] = []

    private var orderBookDict: [UInt64: OrderBookEntry] = [:]
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

                // Buy Orders (Descending)
                buyRows = orderBookDict.values
                    .filter { $0.side == "Buy" }
                    .sorted { $0.price > $1.price }
                    .prefix(20)
                    .map {
                        OrderBookRowViewModel(from: $0)
                    }

                // Sell Orders (Ascending)
                sellRows = orderBookDict.values
                    .filter { $0.side == "Sell" }
                    .sorted { $0.price < $1.price }
                    .prefix(20)
                    .map {
                        OrderBookRowViewModel(from: $0)
                    }
            }
        }
    }
}
