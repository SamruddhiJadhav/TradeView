//
//  BuyOrderRow.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct BuyOrderRow: View {
    let order: OrderBookRowPresentationModel

    var body: some View {
        HStack {
            Text(order.displaySize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    Color.green.opacity(0.15)
                        .frame(width: geometry.size.width * CGFloat(order.accumulatedSizeRatio))
                }
                .scaleEffect(x: -1, y: 1)

                Text(order.displayPrice)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
        }
        .padding([.leading, .bottom, .top], 16)
    }
}


#Preview {
    BuyOrderRow(order: OrderBookRowPresentationModel(from: OrderBookEntry(id: 1234, side: .buy, price: 123.0), accumulatedSizeRatio: 35))
}
