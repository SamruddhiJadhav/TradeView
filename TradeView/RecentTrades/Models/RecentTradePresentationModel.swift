//
//  RecentTradePresentationModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import Foundation
struct RecentTradePresentationModel: Identifiable {
    let id: String
    let price: Double
    let timestamp: String
    let quantity: Double
    let side: TradeSide
    var isHighlighted: Bool = false
    
    init(id: String, price: Double, timestamp: String, quantity: Double, side: TradeSide) {
        self.price = price
        self.timestamp = timestamp
        self.quantity = quantity
        self.id = id
        self.side = side
    }
}

extension RecentTradePresentationModel {
    var formattedTime: String {
        guard let date = TradeDateFormatter.isoFormatter.date(from: timestamp) else {
            return "Invalid"
        }
        return TradeDateFormatter.timeFormatter24Hr.string(from: date)
    }
}
