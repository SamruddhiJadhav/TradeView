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
                Text("Recent Trade")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .padding(16)
                
                Divider()
                
                HStack {
                    Group {
                        Text("Price (USD)")
                        Spacer()
                        Text("Qty")
                        Spacer()
                        Text("Time")
                    }
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding([.leading, .trailing], 16)
                }

                Divider()

                VStack {
                    ForEach(viewModel.recentTrades) { recentTrade in
                        RecentTradeRow(recentTrade: recentTrade)
                    }
                }
            }
            .onAppear {
                viewModel.connectSocket()
            }
            .onDisappear {
                viewModel.disconnectSocket()
            }
        }
    }
}

#Preview {
    RecentTradeView()
}
