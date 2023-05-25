//
//  View+Hidden.swift
//  SideStore
//
//  Created by naturecodevoid on 2/18/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI

// https://stackoverflow.com/a/59228385 (modified)
extension View {
    @ViewBuilder func isHidden(_ hidden: Binding<Bool>, remove: Bool = false) -> some View {
        if hidden.wrappedValue {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
