//
//  RecentTradeView.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct RecentTradeView: View {
    
    @StateObject var viewModel = RecentTradesViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Recent Trades")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(16)
                
                Divider()
                
                HStack {
                    Group {
                        Text("Price (USD)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Qty")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Time")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding([.leading, .trailing], 16)
                }

                Divider()

                VStack(spacing: 0) {
                    ForEach(viewModel.recentTrades) { recentTrade in
                        RecentTradeRow(recentTrade: recentTrade)
                    }
                }
            }
            .onAppear {
                viewModel.connectSocket()
            }
        }
    }
}

#Preview {
    RecentTradeView()
}
