//
//  RecentTradeUpdate.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import Foundation

struct RecentTradeUpdate: Decodable {
    let table: String
    let action: String
    let data: [RecentTradeEntry]
}
