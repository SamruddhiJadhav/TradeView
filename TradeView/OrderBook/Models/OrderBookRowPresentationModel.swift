//
//  OrderBookRowPresentationModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

struct OrderBookRowPresentationModel: Identifiable {
    let id: UInt64
    let side: TradeSide
    let displaySize: String
    let displayPrice: String
    var accumulatedSizeRatio: Double

    init(from entry: OrderBookEntry, accumulatedSizeRatio: Double) {
        self.id = entry.id
        self.side = entry.side
        self.displaySize = String(entry.size ?? 0)
        self.displayPrice = String(format: "%.1f", entry.price)
        self.accumulatedSizeRatio = accumulatedSizeRatio
    }
}
