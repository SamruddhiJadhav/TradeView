//
//  TradeDateFormatter.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import Foundation

enum TradeDateFormatter {
    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    static let timeFormatter24Hr: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
}
