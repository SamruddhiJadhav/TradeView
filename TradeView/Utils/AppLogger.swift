//
//  AppLogger.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 24/5/25.
//

import OSLog

enum AppLogger {
    static let socket = Logger(subsystem: "com.tradeapp.tradeview", category: "Socket")
    static let parsing = Logger(subsystem: "com.tradeapp.tradeview", category: "Parsing")
}
