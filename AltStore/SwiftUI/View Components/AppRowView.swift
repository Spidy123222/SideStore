//
//  AppRowView.swift
//  SideStore
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AltStoreCore

struct AppRowView: View {
    let app: AppProtocol
    
    var storeApp: StoreApp? {
        (app as? StoreApp) ?? (app as? InstalledApp)?.storeApp
    }
    
    var showRemainingDays: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AppIconView(iconUrl: storeApp?.iconURL, isSideStore: storeApp?.isSideStore ?? false)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .bold()
                
                Text(storeApp?.developerName ?? L10n.AppRowView.sideloaded)
                    .font(.callout)
                    .foregroundColor(.secondary)
                
                if false {
                    RatingStars(rating: 4)
                        .frame(height: 12)
                        .foregroundColor(.secondary)
                }
            }
            .lineLimit(1)
            
            Spacer()
            
            AppPillButton(app: app, showRemainingDays: showRemainingDays)
        }
        .padding()
        .tintedBackground(Color(storeApp?.tintColor ?? UIColor(Color.accentColor)))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .circular))
    }
}

//struct AppRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppRowView()
//    }
//}
