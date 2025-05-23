//
//  TabView.swift
//  TradeView
//
//  Created by Samruddhi Jadhav on 20/5/25.
//

import SwiftUI

struct TabView: View {
    
    @Binding var selectedTab: TabType
    let currentTab: TabType

    var body: some View {
        VStack {
            Button {
                selectedTab = currentTab
            } label: {
                Text(currentTab.rawValue)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedTab == currentTab ? .black.opacity(0.6) : .gray)
            }
            Rectangle()
                .fill(selectedTab == currentTab ? .green : .gray.opacity(0.2))
                .frame(height: 2)
            
        }
    }
}

#Preview {
    TabView(selectedTab: .constant(.orderBook), currentTab: .orderBook)
}
