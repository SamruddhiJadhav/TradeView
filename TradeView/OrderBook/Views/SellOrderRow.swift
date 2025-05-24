//
//  SellOrderRow.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct SellOrderRow: View {
    let order: OrderBookRowPresentationModel

    var body: some View {
        HStack(spacing: 0) {
            ZStack(alignment: .trailing) {
                GeometryReader { geometry in
                    Theme.Colors.backgroundRed
                        .frame(width: geometry.size.width * CGFloat(order.accumulatedSizeRatio))
                }

                Text(order.displayPrice)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.Colors.red)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }
            .frame(maxWidth: .infinity)
            
            Text(order.displaySize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.Colors.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(16)
        }
    }
}

#Preview {
    SellOrderRow(order: OrderBookRowPresentationModel(from: OrderBookEntry(id: 1234, side: .sell, price: 123.0), accumulatedSizeRatio: 20))
}
