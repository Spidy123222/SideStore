//
//  AppPillButton.swift
//  SideStore
//
//  Created by Fabian Thies on 20.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AltStoreCore

struct AppPillButton: View {
    
    @ObservedObject
    var appManager = AppManager.shared.publisher
    
    let app: AppProtocol
    var showRemainingDays = false
    
    var storeApp: StoreApp? {
        (app as? StoreApp) ?? (app as? InstalledApp)?.storeApp
    }
    
    var installedApp: InstalledApp? {
        (app as? InstalledApp) ?? (app as? StoreApp)?.installedApp
    }
    
    var progress: Progress? {
        appManager.refreshProgress[app.bundleIdentifier] ?? appManager.installationProgress[app.bundleIdentifier]
    }
//    let progress = {
//        let progress = Progress(totalUnitCount: 100)
//        progress.completedUnitCount = 20
//        return progress
//    }()
    
    var buttonText: String {
//        guard progress == nil else {
//            return ""
//        }
        
        if let installedApp {
            if self.showRemainingDays {
                return DateFormatterHelper.string(forExpirationDate: installedApp.expirationDate)
            }
            
            return L10n.AppPillButton.open
        }
        
        return L10n.AppPillButton.free
    }
    
    var body: some View {
        SwiftUI.Button(action: handleButton) {
            Text(buttonText.uppercased())
                .bold()
        }
        .buttonStyle(PillButtonStyle(tintColor: storeApp?.tintColor ?? .black, progress: progress))
    }
    
    func handleButton() {
        if let installedApp {
            if showRemainingDays {
                self.refreshApp(installedApp)
            } else {
                self.openApp(installedApp)
            }
        } else if let storeApp {
            self.installApp(storeApp)
        }
    }
    
    func openApp(_ installedApp: InstalledApp) {
        UIApplication.shared.open(installedApp.openAppURL)
    }
    
    func refreshApp(_ installedApp: InstalledApp) {
        AppManager.shared.refresh([installedApp], presentingViewController: nil)
    }
    
    func installApp(_ storeApp: StoreApp) {
        let previousProgress = AppManager.shared.installationProgress(for: storeApp)
        guard previousProgress == nil else {
            previousProgress?.cancel()
            return
        }
        
        let _ = AppManager.shared.install(storeApp, presentingViewController: UIApplication.shared.keyWindow?.rootViewController) { result in
            
            switch result {
            case let .success(installedApp):
                print("Installed app: \(installedApp.bundleIdentifier)")
                
            case let .failure(error):
                print("Failed to install app: \(error.localizedDescription)")
                NotificationManager.shared.reportError(error: error)
                AppManager.shared.installationProgress(for: storeApp)?.cancel()
            }
        }
    }
}

struct AppPillButton_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)
    static let installedApp = InstalledApp.fetchAltStore(in: context)

    static var previews: some View {
        VStack {
            self.preview(for: app)

            self.preview(for: installedApp!)

            self.preview(for: installedApp!, showRemainingDays: true)
        }
        .padding()
    }

    @ViewBuilder
    static func preview(for app: AppProtocol, showRemainingDays: Bool = false) -> some View {
        HintView(backgroundColor: Color(UIColor.secondarySystemBackground)) {
            HStack {
                AppIconView(iconUrl: self.app.iconURL, isSideStore: true)

                VStack(alignment: .leading) {
                    Text(app is StoreApp ? "Store App" : "Installed App")
                        .bold()
                    Text(
                        app is StoreApp ?
                            "Can be installed" :
                            showRemainingDays ? "Can be refreshed" : "Can be opened"
                    )
                    .font(.callout)
                    .foregroundColor(.secondary)
                }

                Spacer()

                AppPillButton(app: app, showRemainingDays: showRemainingDays)
            }
        }
    }
}
