//
//  SocketMessages.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 24/5/25.
//

import Foundation

enum SocketMessages {
    static let orderBookSubscribe = """
    {
      "op": "subscribe",
      "args": ["orderBookL2:XBTUSD"]
    }
    """
    
    static let recentTradeSubscribe = """
    {
      "op": "subscribe",
      "args": ["trade:XBTUSD"]
    }
    """
}
