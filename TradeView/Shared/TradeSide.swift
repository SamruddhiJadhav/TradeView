//
//  TradeSide.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import SwiftUI

enum TradeSide: String, Codable {
    case buy = "Buy"
    case sell = "Sell"
    
    var color: Color {
        switch self {
        case .buy:
            return .green
        case .sell:
            return .red
        }
    }
}
