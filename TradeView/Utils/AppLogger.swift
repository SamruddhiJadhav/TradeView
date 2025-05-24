//
//  AppLogger.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 24/5/25.
//

import OSLog

enum AppLogger {
    static let trade = Logger(subsystem: "com.yourcompany.tradeview", category: "Trade")
    static let socket = Logger(subsystem: "com.yourcompany.tradeview", category: "Socket")
    static let ui = Logger(subsystem: "com.yourcompany.tradeview", category: "UI")
    static let parsing = Logger(subsystem: "com.yourcompany.tradeview", category: "Parsing")
}
