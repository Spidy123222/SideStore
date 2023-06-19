//
//  UnstableFeatures+SwiftUI.swift
//  SideStore
//
//  Created by naturecodevoid on 5/25/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import UIKit

import AltStoreCore

extension UnstableFeatures {
    class SwiftUI {
        static func onEnable() {
            let rootView = RootView()
                .environment(\.managedObjectContext, DatabaseManager.shared.viewContext)
            
            UIApplication.keyWindow?.rootViewController = UIHostingController(rootView: rootView)
        }
        
        static func onDisable() {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let rootVC = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
            
            UIApplication.keyWindow?.rootViewController = rootVC
        }
    }
}
