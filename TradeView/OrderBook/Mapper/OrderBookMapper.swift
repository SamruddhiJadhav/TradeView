//
//  OrderBookMapper.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import Foundation

enum OrderBookMapper {
    static func map(from jsonString: String) -> OrderBookUpdate? {
        guard let data = jsonString.data(using: .utf8) else { return nil }

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              json["action"] != nil else {
            return nil
        }

        do {
            return try JSONDecoder().decode(OrderBookUpdate.self, from: data)
        } catch {
            print("❌ JSON Decoding Error: \(error)") // Logger
            return nil
        }
    }
}
