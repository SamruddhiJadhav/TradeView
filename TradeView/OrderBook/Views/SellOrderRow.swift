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
            Text(order.displayPrice)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
                .lineLimit(1)
            
            Spacer()
            
            Text(order.displaySize)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .padding([.top, .bottom, .trailing], 16)
        
//        ZStack(alignment: .trailing) {
//            GeometryReader { geometry in
//                Rectangle()
//                    .fill(.red.opacity(0.1))
//                    .frame(width: geometry.size.width * CGFloat(order.accumulatedSize))
//            }
//            
//            //Color.green.opacity(0.1)
//        }
//        .frame(height: 28)
//        .background(Color.white)
    }
}

#Preview {
    SellOrderRow(order: OrderBookRowPresentationModel(from: OrderBookEntry(id: 1234, side: .sell, price: 123.0), accumulatedSize: 20))
}
