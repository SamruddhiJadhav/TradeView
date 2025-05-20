//
//  RecentTradesView.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct RecentTradesView: View {
    
    let recentTrades: [RecentTrade] = [
        RecentTrade(price: 14449, timestamp: "12:34:00", quantity: 233.998),
        RecentTrade(price: 14449, timestamp: "12:34:00", quantity: 233.998),
        RecentTrade(price: 14449, timestamp: "12:34:00", quantity: 233.998),
        RecentTrade(price: 14449, timestamp: "12:34:00", quantity: 233.998)
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Trade")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(16)
            
            Divider()
            
            HStack {
                Group {
                    Text("Price (USD)")
                    Spacer()
                    Text("Qty")
                    Spacer()
                    Text("Time")
                }
                .font(.callout)
                .foregroundStyle(.gray)
                .padding([.leading, .trailing], 16)
            }

            Divider()

            VStack {
                ForEach(recentTrades) { recentTrade in
                    RecentTradeRow(recentTrade: recentTrade)
                }
            }
        }
    }
}

#Preview {
    RecentTradesView()
}

struct RecentTradeRow: View {

    let recentTrade: RecentTrade

    var body: some View {
        HStack {
            Group {
                Text("\(recentTrade.price, specifier: "%.1f")")
                Text("\(recentTrade.quantity, specifier: "%.4f")")
                Text(recentTrade.timestamp)
            }
            .font(.callout)
            .foregroundStyle(.gray)
        }
        .padding(16)
    }
}

struct RecentTrade: Identifiable {
    let id = UUID()
    let price: Double
    let timestamp: String
    let quantity: Double
    
    init(price: Double, timestamp: String, quantity: Double) {
        self.price = price
        self.timestamp = timestamp
        self.quantity = quantity
    }
}
