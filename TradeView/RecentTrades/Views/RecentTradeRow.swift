//
//  RecentTradeRow.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 23/5/25.
//

import SwiftUI

struct RecentTradeRow: View {

    let recentTrade: RecentTradePresentationModel

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

#Preview {
    RecentTradeRow(recentTrade: RecentTradePresentationModel(id: "1", price: 12.9, timestamp: "11:23:34", quantity: 23.56, side: .buy))
}
