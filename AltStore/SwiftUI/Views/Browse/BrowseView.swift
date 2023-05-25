//
//  BrowseView.swift
//  SideStoreUI
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
import AltStoreCore

struct BrowseView: View {
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \StoreApp.sourceIdentifier, ascending: true),
        NSSortDescriptor(keyPath: \StoreApp.sortIndex, ascending: true),
        NSSortDescriptor(keyPath: \StoreApp.name, ascending: true),
        NSSortDescriptor(keyPath: \StoreApp.bundleIdentifier, ascending: true)
    ], predicate: NSPredicate(format: "%K != %@", #keyPath(StoreApp.bundleIdentifier), StoreApp.altstoreAppID))
    var apps: FetchedResults<StoreApp>
    
    var filteredApps: [StoreApp] {
        apps.items(matching: self.searchText)
    }
    
    @State
    var selectedStoreApp: StoreApp?
    
    @State var searchText = ""
    
    @State var isShowingSourcesView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 32) {
                        promotedCategoriesView
                        
                        Text(L10n.BrowseView.Section.AllApps.title)
                            .font(.title2)
                            .bold()
                    }
                }

                if searchText.isEmpty, filteredApps.count == 0 {
                    HintView {
                        Text(L10n.BrowseView.Hints.NoApps.title)
                            .bold()

                        Text(L10n.BrowseView.Hints.NoApps.text)
                            .font(.callout)
                            .foregroundColor(.secondary)

                        SwiftUI.Button {
                            self.isShowingSourcesView = true
                        } label: {
                            Label(L10n.BrowseView.Hints.NoApps.addSource, systemSymbol: .plus)
                        }
                        .buttonStyle(FilledButtonStyle())
                        .padding(.top, 8)
                    }
                } else {
                    LazyVStack(spacing: 32) {
                        ForEach(filteredApps, id: \.bundleIdentifier) { app in
                            NavigationLink {
                                AppDetailView(storeApp: app)
                            } label: {
                                BrowseAppPreviewView(storeApp: app)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding()
            .searchable(text: self.$searchText, placeholder: L10n.BrowseView.search)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(L10n.BrowseView.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                SwiftUI.Button {
                    self.isShowingSourcesView = true
                } label: {
                    Text(L10n.BrowseView.Actions.sources)
                }
                .sheet(isPresented: self.$isShowingSourcesView) {
                    NavigationView {
                        SourcesView()
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                SwiftUI.Button {
                    
                } label: {
                    Image(systemSymbol: .lineHorizontal3DecreaseCircle)
                        .imageScale(.large)
                }

            }
        }
    }
    
    var promotedCategoriesView: some View {
        VStack {
            HStack {
                Text(L10n.BrowseView.Section.PromotedCategories.title)
                    .font(.title2)
                    .bold()
                Spacer()
                SwiftUI.Button(action: {}, label: {
                    Text(L10n.BrowseView.Section.PromotedCategories.showAll)
                })
                .font(.callout)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                PromotedCategoryView()
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 5)
                
                PromotedCategoryView()
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 5)
            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView()
        }
    }
}


struct PromotedCategoryView: View {
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                RadialGradient(colors: [
                    Color(UIColor(hexString: "477E84")!),
                    Color(UIColor.secondarySystemBackground),
                    Color(UIColor.secondarySystemBackground),
                    Color(UIColor(hexString: "C38FF5")!)
                ], center: .bottomLeading, startRadius: 0, endRadius: proxy.size.width)
            }
            
            HStack {
                Image(systemSymbol: .dpadRightFill)
                Text(L10n.BrowseView.Categories.gamesAndEmulators)
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(.accentColor)
            .padding()
        }
        .aspectRatio(21/9, contentMode: .fill)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
