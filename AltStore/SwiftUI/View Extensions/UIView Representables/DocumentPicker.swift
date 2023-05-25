//
//  DocumentPicker.swift
//  SideStore
//
//  Created by Fabian Thies on 20.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import UIKit
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    internal class Coordinator: NSObject {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
    }
    
    @Binding var selectedUrl: URL?
    let supportedTypes: [String]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
        documentPickerViewController.delegate = context.coordinator
        return documentPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

extension DocumentPicker.Coordinator: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.parent.selectedUrl = nil
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let firstURL = urls.first else {
            return
        }
        
        self.parent.selectedUrl = firstURL
    }
}
