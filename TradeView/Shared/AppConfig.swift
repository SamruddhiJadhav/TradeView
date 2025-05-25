//
//  AppConfig.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 25/5/25.
//

import Foundation

enum AppConfig {
    enum API {
        static var bitmexWebSocketURL: URL {
            guard let url = URL(string: "wss://www.bitmex.com/realtime") else {
                fatalError("Invalid WebSocket URL")
            }
            return url
        }
    }
}
