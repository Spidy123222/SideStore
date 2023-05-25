//
//  AppPermissionsGrid.swift
//  SideStore
//
//  Created by Fabian Thies on 27.11.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
import AltStoreCore

struct AppPermissionsGrid: View {
    
    let permissions: [AppPermission]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(permissions, id: \.type) { permission in
                AppPermissionGridItemView(permission: permission)
            }
        }
    }
}

struct AppPermissionGridItemView: View {
    let permission: AppPermission
    
    @State var isPopoverPresented = false
    
    var body: some View {
        SwiftUI.Button {
            self.isPopoverPresented = true
        } label: {
            VStack {
                Image(uiImage: permission.type.icon?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemSymbol: .questionmark))
                    .foregroundColor(.primary)
                    .padding()
                    .background(Circle().foregroundColor(Color(.secondarySystemBackground)))
                Text(permission.type.localizedShortName ?? permission.type.localizedName ?? "")
            }
            .foregroundColor(.primary)
        }
        .alert(isPresented: self.$isPopoverPresented) {
            Alert(title: Text(L10n.AppPermissionGrid.usageDescription), message: Text(permission.usageDescription))
        }
    }
}

//struct AppPermissionsGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AppPermissionsGrid()
//    }
//}
