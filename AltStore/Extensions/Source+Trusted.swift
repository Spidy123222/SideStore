//
//  Source+Trusted.swift
//  SideStore
//
//  Created by Fabian Thies on 04.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import AltStoreCore

extension Source {
    var isOfficial: Bool {
        self.identifier == Source.altStoreIdentifier
    }

    var isTrusted: Bool {
        UserDefaults.shared.trustedSourceIDs?.contains(self.identifier) ?? false
    }
}
