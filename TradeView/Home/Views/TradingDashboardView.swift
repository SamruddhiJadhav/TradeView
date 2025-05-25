//
//  TradingDashboardView.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 19/5/25.
//

import SwiftUI

struct TradingDashboardView<RecentTradeView: View, OrderBookView: View>: View {

    @StateObject private var viewModel: TradingDashboardViewModel
    
    let recentTradeView: RecentTradeView
    let orderBookView: OrderBookView
    
    init(
        viewModel: TradingDashboardViewModel,
        recentTradeView: RecentTradeView,
        orderBookView: OrderBookView
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.recentTradeView = recentTradeView
        self.orderBookView = orderBookView
    }

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(TabType.allCases) { tab in
                    TabView(selectedTab: $viewModel.selectedTab,
                            currentTab: tab)
                }
            }
            
            switch viewModel.selectedTab {
            case .chart:
                ChartView()
            case .orderBook:
                orderBookView
            case .recentTrades:
                recentTradeView
            }
        }
    }
}

#Preview {
    TradingDashboardView(
        viewModel: TradingDashboardViewModel(),
        recentTradeView: RecentTradeView(viewModel: RecentTradesViewModel(socketService: WebSocketManager())),
        orderBookView: OrderBookView(viewModel: OrderBookViewModel(socketService: WebSocketManager()))
    )
}
