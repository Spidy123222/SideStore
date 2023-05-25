//
//  AppScreenshotsScrollView.swift
//  SideStore
//
//  Created by Fabian Thies on 27.11.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI
import AsyncImage


/// Horizontal ScrollView with an asynchronously loaded image for each screenshot URL
///
/// The struct inherits the `Equatable` protocol and implements the respective comparisation function to prevent the view from being constantly re-rendered when a `@State` change in the parent view occurs.
/// This way, the `AppScreenshotsScrollView` will only be reloaded when the parameters change.
struct AppScreenshotsScrollView: View {
    let urls: [URL]
    var aspectRatio: CGFloat = 9/16
    var height: CGFloat = 400
    
    @State var selectedScreenshotIndex: Int?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(urls.enumerated()), id: \.offset) { i, url in
                    SwiftUI.Button {
                        self.selectedScreenshotIndex = i
                    } label: {
                        AppScreenshot(url: url)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: height)
        .shadow(radius: 12)
        .sheet(item: self.$selectedScreenshotIndex) { index in
            NavigationView {
                AppScreenshotsPreview(urls: urls, aspectRatio: aspectRatio, initialIndex: index)
            }
        }
    }
}

extension AppScreenshotsScrollView: Equatable {
    /// Prevent re-rendering of the view if the parameters didn't change
    static func == (lhs: AppScreenshotsScrollView, rhs: AppScreenshotsScrollView) -> Bool {
        lhs.urls == rhs.urls && lhs.aspectRatio == rhs.aspectRatio && lhs.height == rhs.height
    }
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}


import AltStoreCore

struct AppScreenshotsScrollView_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        AppScreenshotsScrollView(urls: app.screenshotURLs)
    }
}
