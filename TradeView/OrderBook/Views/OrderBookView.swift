//
//  OrderBookView.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct OrderBookView: View {

    @StateObject private var viewModel = OrderBookViewModel()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Group {
                        Text("Qty")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Price (USD)")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Qty")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding([.leading, .trailing], 16)
                }

                Divider()
                
                HStack(alignment: .top, spacing: 0) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.buyRows) { order in
                            BuyOrderRow(order: order)
                        }
                    }
                    
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.sellRows) { order in
                            SellOrderRow(order: order)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.start()
            }
        }
    }
}

#Preview {
    OrderBookView()
}
