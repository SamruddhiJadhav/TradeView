//
//  TradingDashboardView.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 19/5/25.
//

import SwiftUI

enum TabType: String, CaseIterable, Identifiable {
    case chart = "Chart"
    case orderBook = "Order Book"
    case recentTrades = "Recent Trades"

    var id: String { rawValue }
}



struct TradingDashboardView: View {

    @StateObject var viewModel = TradingDashboardViewModel()

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(TabType.allCases, id: \.self) { tab in
                    TabView(selectedTab: $viewModel.selectedTab, currentTab: tab)
                }
            }
            
            HStack {
                Group {
                    Text("Qty")
                    Spacer()
                    Text("Price (USD)")
                    Spacer()
                    Text("Qty")
                }
                .font(.callout)
                .foregroundStyle(.gray)
                .padding([.leading, .trailing], 18)
            }

            Divider()

            switch viewModel.selectedTab {
            case .chart:
                Text("Charts")
            case .orderBook:
                OrderBookView()
            case .recentTrades:
                Text("recentTrades")
            }
        }
    }
}


#Preview {
    TradingDashboardView()
}
