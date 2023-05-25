//
//  StoreApp+Trusted.swift
//  SideStore
//
//  Created by Fabian Thies on 04.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import AltStoreCore

extension StoreApp {
    var isFromOfficialSource: Bool {
        self.source?.isOfficial ?? false
    }

    var isFromTrustedSource: Bool {
        self.source?.isTrusted ?? false
    }
}
