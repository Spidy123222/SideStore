//
//  AppScreenshot.swift
//  SideStore
//
//  Created by Fabian Thies on 20.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI
import UIKit
import AsyncImage

struct AppScreenshot: View {
    let url: URL
    var aspectRatio: CGFloat = 9/16
    
    static let processor = Self.ScreenshotProcessor()
    
    var body: some View {
        AsyncImage(url: self.url, processor: Self.processor) { image in
            image
                .resizable()
        } placeholder: {
            Rectangle()
                .foregroundColor(.secondary)
        }
        .aspectRatio(self.aspectRatio, contentMode: .fit)
        .cornerRadius(8)
    }
}

extension AppScreenshot {
    class ScreenshotProcessor: ImageProcessor {
        func process(image: UIImage) -> UIImage {
            guard let cgImage = image.cgImage, image.size.width > image.size.height else { return image }
            
            let rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .right)
            return rotatedImage
        }
    }
}


import AltStoreCore

struct AppScreenshot_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        AppScreenshot(url: app.screenshotURLs[0])
            .padding()
    }
}
