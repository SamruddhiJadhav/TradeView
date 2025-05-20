//
//  OrderBookUpdate.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

struct OrderBookUpdate: Codable {
    let action: String
    let data: [OrderBookEntry]
}
