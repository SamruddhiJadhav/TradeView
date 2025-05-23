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

            Spacer()

            Text(order.displayPrice)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.green)
                .lineLimit(1)
        }
        .padding([.leading, .bottom, .top], 16)
    }
}

#Preview {
    BuyOrderRow(order: OrderBookRowPresentationModel(from: OrderBookEntry(id: 1234, side: .buy, price: 123.0), accumulatedSize: 35))
}
