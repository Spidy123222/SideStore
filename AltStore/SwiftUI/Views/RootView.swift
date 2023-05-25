//
//  RootView.swift
//  SideStoreUI
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
@_exported import Inject

struct RootView: View {
    @State var selectedTab: Tab = .defaultTab
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            ForEach(Tab.allCases) { tab in
                NavigationView {
                    content(for: tab)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tag(tab)
                .tabItem {
                    tab.label
                }
            }
        }
        .overlay(self.notificationsOverlay)
    }
    
    @ViewBuilder
    func content(for tab: Tab) -> some View {
        switch tab {
        case .news:
            NewsView()
        case .browse:
            BrowseView()
        case .myApps:
            MyAppsView()
        case .settings:
            SettingsView()
        }
    }
    
    
    @ObservedObject
    var notificationManager = NotificationManager.shared
    
    var notificationsOverlay: some View {
        VStack {
            Spacer()
            
            ForEach(Array(notificationManager.notifications.values)) { notification in
                VStack(alignment: .leading) {
                    Text(notification.title)
                        .bold()
                    
                    if let message = notification.message {
                        Text(message)
                            .font(.callout)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 15)
            }
            
            Spacer()
                .frame(height: 50)
        }
        .padding()
        .animation(.easeInOut)
    }
}

extension RootView {
    enum Tab: Int, NavigationTab {
        case news, browse, myApps, settings
        
        static var defaultTab: RootView.Tab  = .news
        
        var displaySymbol: SFSymbol {
            switch self {
            case .news: return .newspaper
            case .browse: return .booksVertical
            case .myApps: return .squareStack
            case .settings: return .gearshape
            }
        }

        var displayName: String {
            switch self {
            case .news: return L10n.RootView.news
            case .browse: return L10n.RootView.browse
            case .myApps: return L10n.RootView.myApps
            case .settings: return L10n.RootView.settings
            }
        }
        
        var label: some View {
            Label(self.displayName, systemSymbol: self.displaySymbol)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
