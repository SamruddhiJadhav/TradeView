//
//  TabType.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 24/5/25.
//

import Foundation

enum TabType: String, CaseIterable, Identifiable {
    case chart = "Chart"
    case orderBook = "Order Book"
    case recentTrades = "Recent Trades"

    var id: String { rawValue }
}
