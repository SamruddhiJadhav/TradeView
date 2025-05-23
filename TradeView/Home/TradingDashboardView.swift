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
            
            switch viewModel.selectedTab {
            case .chart:
                ChartView()
            case .orderBook:
                OrderBookView()
            case .recentTrades:
                RecentTradeView()
            }
        }
    }
}


#Preview {
    TradingDashboardView()
}
