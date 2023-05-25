//
//  AppIDsView.swift
//  SideStore
//
//  Created by Fabian Thies on 23.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI
import AltStoreCore

struct AppIDsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \AppID.name, ascending: true),
        NSSortDescriptor(keyPath: \AppID.bundleIdentifier, ascending: true),
        NSSortDescriptor(keyPath: \AppID.expirationDate, ascending: true)
    ], predicate: NSPredicate(format: "%K == %@", #keyPath(AppID.team), DatabaseManager.shared.activeTeam() ?? Team()))
    var appIDs: FetchedResults<AppID>

    @State var isLoading: Bool = false
    
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(L10n.AppIDsView.description)
                    .foregroundColor(.secondary)
                
                ForEach(appIDs, id: \.identifier) { appId in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(appId.name)
                                .bold()

                            Text(appId.bundleIdentifier)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if let expirationDate = appId.expirationDate {
                            VStack(spacing: 4) {
                                Text("Expires in")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)

                                SwiftUI.Button {

                                } label: {
                                    Text(DateFormatterHelper.string(forExpirationDate: expirationDate).uppercased())
                                        .bold()
                                }
                                .buttonStyle(PillButtonStyle(tintColor: .altPrimary))
                                .disabled(true)
                            }
                        }
                    }
                    .padding()
                    .tintedBackground(.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .circular))
                }
            }
            .padding()
        }
        .navigationTitle(L10n.AppIDsView.title)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if self.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                SwiftUI.Button(L10n.Action.done, action: self.dismiss)
            }
        }
        .onAppear(performAsync: self.updateAppIDs)
    }


    func updateAppIDs() async {
        self.isLoading = true
        defer { self.isLoading = false }

        await withCheckedContinuation { continuation in
            AppManager.shared.fetchAppIDs { result in
                do {
                    let (_, context) = try result.get()
                    try context.save()
                } catch {
                    print(error)
                    NotificationManager.shared.reportError(error: error)
                }

                continuation.resume()
            }
        }
    }
}

extension View {

    func onAppear(performAsync task: @escaping () async -> Void) -> some View {
        self.onAppear(perform: { Task { await task() } })
    }
}

struct AppIDsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppIDsView()
        }
    }
}
