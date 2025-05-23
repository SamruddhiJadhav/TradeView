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
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(recentTrade.quantity, specifier: "%.4f")")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(recentTrade.formattedTime)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(recentTrade.side.color)
            .lineLimit(1)
            
        }
        .padding(16)
        .background {
            Color.green.opacity(0.1)
        }
        .animation(.easeInOut(duration: 0.2), value: recentTrade.isHighlighted)
    }
}

#Preview {
    RecentTradeRow(recentTrade: RecentTradePresentationModel(id: "1", price: 12.9, timestamp: "2025-05-21T09:30:06.154Z", quantity: 23.56, side: .buy))
}
