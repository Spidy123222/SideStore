//
//  MyAppsView.swift
//  SideStoreUI
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
import MobileCoreServices
import AltStoreCore

struct MyAppsView: View {
    
    // TODO: Refactor
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \InstalledApp.storeApp?.latestVersion?.date, ascending: true),
        NSSortDescriptor(keyPath: \InstalledApp.name, ascending: true)
    ], predicate: NSPredicate(format: "%K == YES AND %K != nil AND %K != %K",
                              #keyPath(InstalledApp.isActive), #keyPath(InstalledApp.storeApp),
                              #keyPath(InstalledApp.version), #keyPath(InstalledApp.storeApp.latestVersion.version))
    )
    var updates: FetchedResults<InstalledApp>
    
    
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \InstalledApp.expirationDate, ascending: true),
        NSSortDescriptor(keyPath: \InstalledApp.refreshedDate, ascending: false),
        NSSortDescriptor(keyPath: \InstalledApp.name, ascending: true)
    ], predicate: NSPredicate(format: "%K == YES", #keyPath(InstalledApp.isActive)))
    var activeApps: FetchedResults<InstalledApp>
    
    @AppStorage("shouldShowAppUpdateHint")
    var shouldShowAppUpdateHint: Bool = true
    
    @ObservedObject
    var viewModel = MyAppsViewModel()
    
    // TODO: Refactor
    @State var isRefreshingAllApps: Bool = false
    @State var selectedSideloadingIpaURL: URL?
    
    var remainingAppIDs: Int {
        guard let team = DatabaseManager.shared.activeTeam() else {
            return 0
        }
        
        let maximumAppIDCount = 10
        return max(maximumAppIDCount - team.appIDs.count, 0)
    }
    
    // TODO: Refactor
    let sideloadFileTypes: [String] = {
        if let types = UTTypeCreateAllIdentifiersForTag(kUTTagClassFilenameExtension, "ipa" as CFString, nil)?.takeRetainedValue()
        {
            return (types as NSArray).map { $0 as! String }
        }
        else
        {
            return ["com.apple.itunes.ipa"] // Declared by the system.
        }
    }()
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if let progress = SideloadingManager.shared.progress {
                    VStack {
                        Text(L10n.MyAppsView.sideloading)
                            .padding()
                        
                        ProgressView(progress)
                            .progressViewStyle(LinearProgressViewStyle())
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                }
                
                if updates.isEmpty {
                    if shouldShowAppUpdateHint {
                        updatesSection
                    }
                }
                
                HStack {
                    Text(L10n.MyAppsView.active)
                        .font(.title2)
                        .bold()

                    Spacer()

                    if !self.isRefreshingAllApps {
                        SwiftUI.Button(L10n.MyAppsView.refreshAll, action: self.refreshAllApps)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
                
                ForEach(activeApps, id: \.bundleIdentifier) { app in
                    
                    if let storeApp = app.storeApp {
                        NavigationLink {
                            AppDetailView(storeApp: storeApp)
                        } label: {
                            self.rowView(for: app)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        self.rowView(for: app)
                    }
                }

                if let activeTeam = DatabaseManager.shared.activeTeam() {
                    VStack {
                        if activeTeam.type == .free {
                            Text("\(remainingAppIDs) \(L10n.MyAppsView.appIDsRemaining)")
                                .foregroundColor(.secondary)
                        }

                        ModalNavigationLink(L10n.MyAppsView.viewAppIDs) {
                            NavigationView {
                                AppIDsView()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(L10n.MyAppsView.myApps)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ModalNavigationLink {
                    DocumentPicker(selectedUrl: $selectedSideloadingIpaURL, supportedTypes: sideloadFileTypes)
                        .ignoresSafeArea()
                } label: {
                    Image(systemSymbol: .plus)
                        .imageScale(.large)
                }
                .onChange(of: self.selectedSideloadingIpaURL) { newValue in
                    guard let url = newValue else {
                        return
                    }
                    
                    self.sideloadApp(at: url)
                }
            }
        }
    }
    
    var updatesSection: some View {
        HintView {
            HStack(alignment: .center) {
                Text(L10n.MyAppsView.Hints.NoUpdates.title)
                    .bold()
                Spacer()

                Menu {
                    SwiftUI.Button {
                        self.dismissUpdatesHint(forever: false)
                    } label: {
                        Label(L10n.MyAppsView.Hints.NoUpdates.dismissForNow, systemSymbol: .zzz)
                    }

                    SwiftUI.Button {
                        self.dismissUpdatesHint(forever: true)
                    } label: {
                        Label(L10n.MyAppsView.Hints.NoUpdates.dontShowAgain, systemSymbol: .xmark)
                    }
                } label: {
                    Image(systemSymbol: .xmark)
                }
                .foregroundColor(.secondary)
            }

            Text(L10n.MyAppsView.Hints.NoUpdates.text)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    func rowView(for app: AppProtocol) -> some View {
        AppRowView(app: app, showRemainingDays: true)
            .contextMenu(ContextMenu(menuItems: {
                ForEach(self.actions(for: app), id: \.self) { action in
                    SwiftUI.Button {
                        self.perform(action: action, for: app)
                    } label: {
                        Label(action.title, systemSymbol: action.symbol)
                    }
                }
            }))
    }
    
    func refreshAllApps() {
        let installedApps = InstalledApp.fetchAppsForRefreshingAll(in: DatabaseManager.shared.viewContext)

        self.isRefreshingAllApps = true
        self.refresh(installedApps) { result in
            self.isRefreshingAllApps = false
        }
    }
    
    func dismissUpdatesHint(forever: Bool) {
        withAnimation {
            self.shouldShowAppUpdateHint = false
        }
    }
}


extension MyAppsView {
    // TODO: Convert to async?
    func refresh(_ apps: [InstalledApp], completionHandler: @escaping ([String : Result<InstalledApp, Error>]) -> Void) {
        let group = AppManager.shared.refresh(apps, presentingViewController: nil, group: self.viewModel.refreshGroup)
        
        group.completionHandler = { results in
            DispatchQueue.main.async {
                let failures = results.compactMapValues { result -> Error? in
                    switch result {
                    case .failure(OperationError.cancelled):
                        return nil
                    case .failure(let error):
                        return error
                    case .success:
                        return nil
                    }
                }
                
                guard !failures.isEmpty else { return }
                
                if let failure = failures.first, results.count == 1 {
                    NotificationManager.shared.reportError(error: failure.value)
                } else {
                    // TODO: Localize
                    let title = "\(L10n.MyAppsView.failedToRefresh) \(failures.count) \(L10n.MyAppsView.apps)"
                    
                    let error = failures.first?.value as NSError?
                    let message = error?.localizedFailure ?? error?.localizedFailureReason ?? error?.localizedDescription
                    
                    NotificationManager.shared.showNotification(title: title, detailText: message)
                }

                self.viewModel.refreshGroup = nil
                completionHandler(results)
            }
        }
        
        self.viewModel.refreshGroup = group
    }
}

extension MyAppsView {
    func actions(for app: AppProtocol) -> [AppAction] {
        guard let installedApp = app as? InstalledApp else {
            return []
        }
        
        guard installedApp.bundleIdentifier != StoreApp.altstoreAppID else {
            return [.refresh]
        }
        
        var actions: [AppAction] = []
        
        if installedApp.isActive {
            actions.append(.open)
            actions.append(.refresh)
            actions.append(.enableJIT)
        } else {
            actions.append(.activate)
        }
        
        actions.append(.chooseCustomIcon)
        if installedApp.hasAlternateIcon {
            actions.append(.resetCustomIcon)
        }
        
        if installedApp.isActive {
            actions.append(.backup)
        } else if let _ = UTTypeCopyDeclaration(installedApp.installedAppUTI as CFString)?.takeRetainedValue() as NSDictionary?, !UserDefaults.standard.isLegacyDeactivationSupported {
            // Allow backing up inactive apps if they are still installed,
            // but on an iOS version that no longer supports legacy deactivation.
            // This handles edge case where you can't install more apps until you
            // delete some, but can't activate inactive apps again to back them up first.
            actions.append(.backup)
        }
        
        if let backupDirectoryURL = FileManager.default.backupDirectoryURL(for: installedApp) {
            
            // TODO: Refactor
            var backupExists = false
            var outError: NSError? = nil
            
            let coordinator = NSFileCoordinator()
            coordinator.coordinate(readingItemAt: backupDirectoryURL, options: [.withoutChanges], error: &outError) { (backupDirectoryURL) in
                backupExists = FileManager.default.fileExists(atPath: backupDirectoryURL.path)
            }
            
            if backupExists {
                actions.append(.exportBackup)
                
                if installedApp.isActive {
                    actions.append(.restoreBackup)
                }
            } else if let error = outError {
                print("Unable to check if backup exists:", error)
            }
        }
        
        if installedApp.isActive {
            actions.append(.deactivate)
        }
        
        if installedApp.bundleIdentifier != StoreApp.altstoreAppID {
            actions.append(.remove)
        }
        
        return actions
    }
    
    func perform(action: AppAction, for app: AppProtocol) {
        guard let installedApp = app as? InstalledApp else {
            // Invalid state.
            return
        }
        
        switch action {
        case .install: break
        case .open: self.open(installedApp)
        case .refresh: self.refresh(installedApp)
        case .activate: self.activate(installedApp)
        case .deactivate: self.deactivate(installedApp)
        case .remove: self.remove(installedApp)
        case .enableJIT: self.enableJIT(for: installedApp)
        case .backup: self.backup(installedApp)
        case .exportBackup: self.exportBackup(installedApp)
        case .restoreBackup: self.restoreBackup(installedApp)
        case .chooseCustomIcon: self.chooseIcon(for: installedApp)
        case .resetCustomIcon: self.resetIcon(for: installedApp)
        }
    }
    
    
    func open(_ app: InstalledApp) {
        UIApplication.shared.open(app.openAppURL) { success in
            guard !success else { return }
            
            NotificationManager.shared.reportError(error: OperationError.openAppFailed(name: app.name))
        }
    }
    
    func refresh(_ app: InstalledApp) {
        let previousProgress = AppManager.shared.refreshProgress(for: app)
        guard previousProgress == nil else {
            previousProgress?.cancel()
            return
        }
        
        self.refresh([app]) { (results) in
            print("Finished refreshing with results:", results.map { ($0, $1.error?.localizedDescription ?? "success") })
        }
    }
    
    func activate(_ app: InstalledApp) {
        
    }
    
    func deactivate(_ app: InstalledApp) {
        
    }
    
    func remove(_ app: InstalledApp) {
        
    }
    
    func enableJIT(for app: InstalledApp) {
        AppManager.shared.enableJIT(for: app) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                NotificationManager.shared.reportError(error: error)
            }
        }
    }
    
    func backup(_ app: InstalledApp) {
        
    }
    
    func exportBackup(_ app: InstalledApp) {
        
    }
    
    func restoreBackup(_ app: InstalledApp) {
        
    }
    
    func chooseIcon(for app: InstalledApp) {
        
    }
    
    func resetIcon(for app: InstalledApp) {
        
    }
    
    func setIcon(for app: InstalledApp, to image: UIImage? = nil) {
        
    }
    
    func sideloadApp(at url: URL) {
        SideloadingManager.shared.sideloadApp(at: url) { result in
            switch result {
            case .success:
                print("App sideloaded successfully.")
            case .failure(let error):
                print("Failed to sideload app: \(error.localizedDescription)")
            }
        }
    }
}

struct MyAppsView_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        NavigationView {
            MyAppsView()
        }
    }
}
