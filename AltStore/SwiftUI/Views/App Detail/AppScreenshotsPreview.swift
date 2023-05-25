//
//  AppScreenshotsPreview.swift
//  SideStore
//
//  Created by Fabian Thies on 23.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI
import AsyncImage
import AltStoreCore

struct AppScreenshotsPreview: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    let urls: [URL]
    let aspectRatio: CGFloat
    @State var index: Int
    
    init(urls: [URL], aspectRatio: CGFloat = 9/16, initialIndex: Int = 0) {
        self.urls = urls
        self.aspectRatio = aspectRatio
        self._index = State(initialValue: initialIndex)
    }
    
    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(urls.enumerated()), id: \.offset) { (i, url) in
                AppScreenshot(url: url, aspectRatio: aspectRatio)
                    .padding()
                    .tag(i)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .navigationTitle("\(index + 1) of \(self.urls.count)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                SwiftUI.Button {
                    self.dismiss()
                } label: {
                    Text(L10n.Action.close)
                }
            }
        }
    }
}

extension AppScreenshotsPreview: Equatable {
    /// Prevent re-rendering of the view if the parameters didn't change
    static func == (lhs: AppScreenshotsPreview, rhs: AppScreenshotsPreview) -> Bool {
        lhs.urls == rhs.urls
    }
}

struct AppScreenshotsPreview_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        Color.clear
            .sheet(isPresented: .constant(true)) {
                NavigationView {
                    AppScreenshotsPreview(urls: app.screenshotURLs)
                }
            }
    }
}
