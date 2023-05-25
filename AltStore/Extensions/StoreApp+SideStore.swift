//
//  StoreApp+SideStore.swift
//  SideStore
//
//  Created by naturecodevoid on 4/9/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import AltStoreCore

extension StoreApp {
    var isSideStore: Bool {
        self.bundleIdentifier == Bundle.Info.appbundleIdentifier
    }
}
