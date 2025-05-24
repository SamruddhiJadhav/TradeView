//
//  OrderBookUpdate.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

struct OrderBookUpdate: Decodable {
    let action: TradeAction
    let data: [OrderBookEntry]
}

enum TradeAction: String, Decodable {
    case partial
    case insert
    case delete
    case update
}
