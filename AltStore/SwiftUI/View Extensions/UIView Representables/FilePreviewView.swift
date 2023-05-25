//
//  FilePreviewView.swift
//  SideStore
//
//  Created by Fabian Thies on 03.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import UIKit
import QuickLook

struct FilePreviewView: UIViewControllerRepresentable {
    let urls: [URL]

    func makeCoordinator() -> Coordinator {
        Coordinator(urls: self.urls)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let previewController = QLPreviewController()
        previewController.dataSource = context.coordinator
        return UINavigationController(rootViewController: previewController)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.urls = self.urls
    }
}

extension FilePreviewView {

    class Coordinator: QLPreviewControllerDataSource {
        var urls: [URL]

        init(urls: [URL]) {
            self.urls = urls
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            urls.count
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            urls[index] as QLPreviewItem
        }
    }
}
