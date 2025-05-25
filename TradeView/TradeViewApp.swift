//
//  TradeViewApp.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 19/5/25.
//

import SwiftUI

@main
struct TradeViewApp: App {

    private let webSocketManager: WebSocketService = WebSocketManager()

    var body: some Scene {
        WindowGroup {
            tradingDashboardView()
        }
    }
    
    private func tradingDashboardView() -> some View {
        let viewModel = TradingDashboardViewModel()
        return TradingDashboardView(
            viewModel: viewModel,
            recentTradeView: recentTradeView(),
            orderBookView: orderBookView()
        )
    }

    private func recentTradeView() -> some View {
        let viewModel = RecentTradesViewModel(socketService: webSocketManager)
        return RecentTradeView(viewModel: viewModel)
    }
    
    private func orderBookView() -> some View {
        let viewModel = OrderBookViewModel(socketService: webSocketManager)
        return OrderBookView(viewModel: viewModel)
    }
}
