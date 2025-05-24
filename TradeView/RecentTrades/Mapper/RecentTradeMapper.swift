//
//  RecentTradeMapper.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import Foundation

enum RecentTradeMapper {
    static func map(from jsonString: String) -> RecentTradeUpdate? {
        guard let data = jsonString.data(using: .utf8) else { return nil }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                json["table"] as? String == "trade",
                json["action"] as? String == "insert" else {
            return nil
        }

        do {
            return try JSONDecoder().decode(RecentTradeUpdate.self, from: data)
        } catch {
            AppLogger.parsing.error("❌ JSON Decoding Error: \(error)")
            return nil
        }
    }
}
