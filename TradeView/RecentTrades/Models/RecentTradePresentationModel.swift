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
    let quantity: Int
    let side: TradeSide
    var isHighlighted: Bool
    
    init(
        id: String,
        price: Double,
        timestamp: String,
        quantity: Int,
        side: TradeSide,
        isHighlighted: Bool
    ) {
        self.price = price
        self.timestamp = timestamp
        self.quantity = quantity
        self.id = id
        self.side = side
        self.isHighlighted = isHighlighted
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
