//
//  EnvironmentValues.swift
//  SideStore
//
//  Created by Fabian Thies on 29.11.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
extension EnvironmentValues {
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}
