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
            HStack(alignment: .top, spacing: 8) {
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
            .onAppear {
                viewModel.start()
            }
        }
    }
}

#Preview {
    OrderBookView()
}
