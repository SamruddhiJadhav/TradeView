//
//  OrderBookEntry.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

struct OrderBookEntry: Decodable, Identifiable {
    let id: UInt64
    let side: TradeSide
    var size: Int?
    let price: Double
}
