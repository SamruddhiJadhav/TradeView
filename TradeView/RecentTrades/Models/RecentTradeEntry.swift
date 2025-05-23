//
//  RecentTradeEntry.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import Foundation

struct RecentTradeEntry: Codable {
    let timestamp: String
    let side: TradeSide
    let size: Double
    let price: Double
    let trdMatchID: String
}
