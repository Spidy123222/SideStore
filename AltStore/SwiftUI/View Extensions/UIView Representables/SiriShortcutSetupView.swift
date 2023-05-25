//
//  SiriShortcutSetupView.swift
//  SideStore
//
//  Created by Fabian Thies on 21.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI

import UIKit
import Intents
import IntentsUI

struct SiriShortcutSetupView: UIViewControllerRepresentable {
    
    let shortcut: INShortcut
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.delegate = context.coordinator
        viewController.modalPresentationStyle = .formSheet
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(shortcut: shortcut)
    }
    
    class Coordinator: NSObject {
        
        let shortcut: INShortcut
        
        init(shortcut: INShortcut) {
            self.shortcut = shortcut
        }
    }
}

extension SiriShortcutSetupView.Coordinator: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        
        // TODO: Handle errors
        controller.dismiss(animated: true)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true)
    }
}
