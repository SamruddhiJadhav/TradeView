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
        HStack {
            ZStack(alignment: .trailing) {
                GeometryReader { geometry in
                    order.side.color.opacity(0.15)
                        .frame(width: geometry.size.width * CGFloat(order.accumulatedSizeRatio))
                }

                Text(order.displayPrice)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            
            Text(order.displaySize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding([.trailing, .bottom, .top], 16)
    }
}

#Preview {
    SellOrderRow(order: OrderBookRowPresentationModel(from: OrderBookEntry(id: 1234, side: .sell, price: 123.0), accumulatedSizeRatio: 20))
}
