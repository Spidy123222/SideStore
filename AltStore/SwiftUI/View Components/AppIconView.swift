//
//  SwiftUIView.swift
//  SideStore
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AsyncImage

struct AppIconView: View {
    @ObservedObject private var iO = Inject.observer
    
    @ObservedObject private var sideStoreIconData = AppIconsData.shared
    
    let iconUrl: URL?
    var isSideStore: Bool
    var size: CGFloat = 64
    var cornerRadius: CGFloat {
        size * 0.234
    }
    
    var image: some View {
        if isSideStore {
            return AnyView(
                Image(uiImage: UIImage(named: sideStoreIconData.selectedIconName! + "-image") ?? UIImage())
                    .resizable()
                    .renderingMode(.original)
            )
        }
        if let iconUrl {
            return AnyView(
                AsyncImage(url: iconUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color(UIColor.secondarySystemBackground)
                }
            )
        }
        return AnyView(Color(UIColor.secondarySystemBackground))
    }
    
    var body: some View {
        image
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .enableInjection()
    }
}

extension AppIconView: Equatable {
    /// Prevent re-rendering of the view if the parameters didn't change
    static func == (lhs: AppIconView, rhs: AppIconView) -> Bool {
        lhs.iconUrl == rhs.iconUrl && lhs.cornerRadius == rhs.cornerRadius
    }
}


import AltStoreCore

struct AppIconView_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        HStack {
            AppIconView(iconUrl: app.iconURL, isSideStore: true)

            VStack(alignment: .leading) {
                Text(app.name)
                    .bold()
                Text(app.developerName)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
    }
}
