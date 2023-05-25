//
//  AppVersionHistoryView.swift
//  SideStore
//
//  Created by Fabian Thies on 28.01.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import AltStoreCore
import ExpandableText

struct AppVersionHistoryView: View {
    let storeApp: StoreApp

    var body: some View {
        List {
            ForEach(storeApp.versions.sorted(by: { $0.date < $1.date }), id: \.version) { version in
                VStack(spacing: 8) {
                    HStack {
                        Text(version.version).bold()
                        Spacer()
                        Text(DateFormatterHelper.string(forRelativeDate: version.date))
                            .foregroundColor(.secondary)
                    }

                    if let versionDescription = version.localizedDescription {
                        ExpandableText(text: versionDescription)
                            .lineLimit(3)
                            .expandButton(TextSet(text: L10n.AppDetailView.more, font: .callout, color: .accentColor))
                            .buttonStyle(.plain)
                    } else {
                        Text("No version desciption available")
                            .italic()
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Version History")
    }
}

struct AppVersionHistoryView_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        NavigationView {
            AppVersionHistoryView(storeApp: app)
        }
    }
}
