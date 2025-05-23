//
//  TradingDashboardViewModel.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

final class TradingDashboardViewModel: ObservableObject {
    @Published var selectedTab: TabType = .recentTrades
}
