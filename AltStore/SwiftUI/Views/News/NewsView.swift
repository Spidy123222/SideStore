//
//  NewsView.swift
//  SideStoreUI
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AltStoreCore

struct NewsView: View {
    
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \NewsItem.date, ascending: false),
        NSSortDescriptor(keyPath: \NewsItem.sortIndex, ascending: true),
        NSSortDescriptor(keyPath: \NewsItem.sourceIdentifier, ascending: true)
    ])
    var news: FetchedResults<NewsItem>
    
    @State
    var activeExternalUrl: URL?
    
    @State
    var selectedStoreApp: StoreApp?
    
    var body: some View {
        ScrollView {
            self.announcementsCarousel
            
            VStack(alignment: .leading) {
                Text(L10n.NewsView.Section.FromSources.title)
                    .font(.title2)
                    .bold()
                
                LazyVStack(spacing: 24) {
                    ForEach(news, id: \.objectID) { newsItem in
                        NewsItemView(newsItem: newsItem)
                            .onNewsSelection { newsItem in
                                self.activeExternalUrl = newsItem.externalURL
                            }
                            .frame(
                                maxWidth: .infinity,
                                alignment: .topLeading
                            )
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(L10n.NewsView.title)
        .sheet(item: self.$activeExternalUrl) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
        .onAppear(perform: fetchNews)
    }
    
    var announcementsCarousel: some View {
        TabView {
            ForEach(0..<5) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.secondary)
                    .shadow(radius: 5, y: 3)
                    .padding()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(maxWidth: .infinity)
        .aspectRatio(16/9, contentMode: .fit)
    }
    
    
    func fetchNews() {
        AppManager.shared.fetchSources { result in
            do {
                do {
                    let (_, context) = try result.get()
                    try context.save()
                } catch let error as AppManager.FetchSourcesError {
                    try error.managedObjectContext?.save()
                    throw error
                }
            } catch {
                print(error)
                NotificationManager.shared.reportError(error: error)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
