//
//  SellOrderRow.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct SellOrderRow: View {
    let order: OrderBookRowViewModel
    
    var body: some View {
        HStack {
            Text(order.displayPrice)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Spacer()
            
            Text(order.displaySize)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(16)
        
//        ZStack(alignment: .trailing) {
//            GeometryReader { geometry in
//                Rectangle()
//                    .fill(isBuy ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
//                    .frame(width: geometry.size.width * volumeWidth)
//            }
//            
//            
//        }
//        .frame(height: 28)
//        .background(Color.white)
    }
}

#Preview {
    SellOrderRow(order: OrderBookRowViewModel(from: OrderBookEntry(id: 1234, side: "Sell", price: 123.0)))
}
