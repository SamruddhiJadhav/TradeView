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
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Spacer()

            Text(order.displayPrice)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .padding(16)
    }
}

#Preview {
    BuyOrderRow(order: OrderBookRowPresentationModel(from: OrderBookEntry(id: 1234, side: .buy, price: 123.0)))
}
