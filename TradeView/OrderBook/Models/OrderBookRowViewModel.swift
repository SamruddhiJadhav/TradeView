//
//  OrderBookRowViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

struct OrderBookRowViewModel: Identifiable {
    let id: UInt64
    let side: String
    let displaySize: String
    let displayPrice: String
    //    var accumulatedSize: Double = 0

    init(from entry: OrderBookEntry) {
        self.id = entry.id
        self.side = entry.side
        self.displaySize = String(format: "%.4f", Double(entry.size ?? 0))
        self.displayPrice = String(format: "%.1f", entry.price)
    }
}
