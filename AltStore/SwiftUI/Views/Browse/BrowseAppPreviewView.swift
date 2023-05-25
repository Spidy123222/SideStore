//
//  BrowseAppPreviewView.swift
//  SideStore
//
//  Created by Fabian Thies on 20.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AsyncImage
import AltStoreCore

struct BrowseAppPreviewView: View {
    let storeApp: StoreApp
    
    var body: some View {
        VStack(spacing: 16) {
            AppRowView(app: storeApp)
            
            if let subtitle = storeApp.subtitle {
                Text(subtitle)
                    .multilineTextAlignment(.center)
            }
            
            if !storeApp.screenshotURLs.isEmpty {
                HStack {
                    ForEach(storeApp.screenshotURLs.prefix(2)) { url in
                        AppScreenshot(url: url)
                    }
                }
                .frame(height: 300)
                .shadow(radius: 8)
            }
        }
    }
}

//struct BrowseAppPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrowseAppPreviewView()
//    }
//}
