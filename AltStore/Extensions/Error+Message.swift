//
//  Error+Message.swift
//  SideStore
//
//  Created by naturecodevoid on 5/30/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

extension Error {
    func message() -> String {
        (self as? LocalizedError)?.failureReason ?? self.localizedDescription
    }
}
