//
//  OnboardingView.swift
//  SideStore
//
//  Created by Fabian Thies on 25.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import CoreData
import AltStoreCore
import minimuxer
import Reachability
import UniformTypeIdentifiers


enum OnboardingStep: Int, CaseIterable {
    case welcome, pairing, wireguard, wireguardConfig, addSources, finish
}

struct OnboardingView: View {

    @Environment(\.dismiss) var dismiss

    // Temporary workaround for UIKit compatibility
    var onDismiss: (() -> Void)? = nil

    var enabledSteps = OnboardingStep.allCases
    @State private var currentStep: OnboardingStep = .welcome
    @State private var pairingFileURL: URL? = nil
    @State private var isWireGuardAppStorePageVisible: Bool = false
    @State private var isDownloadingWireGuardProfile: Bool = false
    @State private var wireGuardProfileFileURL: URL? = nil
    @State private var reachabilityNotifier: Reachability? = nil
    @State private var isWireGuardTunnelReachable: Bool = false
    @State private var areTrustedSourcesEnabled: Bool = false
    @State private var isLoadingTrustedSources: Bool = false

    let pairingFileTypes = UTType.types(tag: "plist", tagClass: UTTagClass.filenameExtension, conformingTo: nil) + UTType.types(tag: "mobiledevicepairing", tagClass: UTTagClass.filenameExtension, conformingTo: UTType.data) + [.xml]

    var body: some View {
        TabView(selection: self.$currentStep) {
            ForEach(self.enabledSteps, id: \.self) { step in
                self.viewForStep(step)
                    .tag(step)
                    // Hack to disable horizontal scrolling in onboarding screens
                    .background(
                        Color.black
                            .opacity(0.001)
                            .edgesIgnoringSafeArea(.all)
                    )
                    .highPriorityGesture(DragGesture())
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Color.accentColor
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: self.currentStep) { step in
            switch step {
            case .wireguardConfig:
                self.startPingingWireGuardTunnel()
            default:
                self.stopPingingWireGuardTunnel()
            }
        }
    }

    var welcomeStep: some View {
        OnboardingStepView {
            VStack(alignment: .leading) {
                Text("Welcome to")
                Text("SideStore")
                    .foregroundColor(.accentColor)
            }
        } hero: {
            AppIconsShowcase()
        } content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("Before you can start sideloading apps, there is some setup to do.")
                Text("The following setup will guide you through the steps one by one.")
                Text("You will need a computer (Windows, macOS, Linux) and your Apple ID.")
            }
        } action: {
            SwiftUI.Button("Continue") {
                self.showNextStep()
            }
            .buttonStyle(FilledButtonStyle())
        }
    }

    var pairingView: some View {
        OnboardingStepView(title: {
            VStack(alignment: .leading) {
                Text("Pair your Device")
            }
        }, hero: {
            Image(systemSymbol: .link)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .shadow(color: .accentColor.opacity(0.8), radius: 12)
        }, content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("SideStore supports on-device sideloading even on non-jailbroken devices.")
                Text("For it to work, you have to generate a pairing file as described [here in our documentation](https://wiki.sidestore.io/guides/install#pairing-process).")
                Text("Once you have the `<UUID>.mobiledevicepairing`, import it using the button below.")
            }.lineLimit(nil)
        }, action: {
            ModalNavigationLink("Select Pairing File") {
                DocumentPicker(selectedUrl: self.$pairingFileURL,
                               supportedTypes: self.pairingFileTypes.map { $0.identifier })
            }
            .buttonStyle(FilledButtonStyle())
            .onChange(of: self.pairingFileURL) { newValue in
                guard let url = newValue else {
                    // TODO: show error that nothing was selected
                    return
                }

                self.importPairingFile(url: url)
            }
        })
    }

    var wireguardView: some View {
        OnboardingStepView(title: {
            VStack(alignment: .leading) {
                Text("Download WireGuard")
            }
        }, hero: {
            Image(systemSymbol: .icloudAndArrowDown)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .shadow(color: .accentColor.opacity(0.8), radius: 12)
        }, content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("To sideload and sign app on-device without the need of a computer program like SideServer, a local WireGuard connection is required.")
                Text("This connection is strictly local-only and does not connect to a server on the internet.")
                Text("First, download WireGuard from the App Store (free).")
            }
        }, action: {
            AppStoreView(isVisible: self.$isWireGuardAppStorePageVisible, itunesItemId: 1441195209)
                .frame(width: .zero, height: .zero)

            VStack {
                SwiftUI.Button("Show in App Store") {
                    self.isWireGuardAppStorePageVisible = true
                }
                .buttonStyle(FilledButtonStyle())

                SwiftUI.Button("Continue") {
                    self.showNextStep()
                }
                .buttonStyle(FilledButtonStyle())
            }
        })

    }

    var wireguardConfigView: some View {
        OnboardingStepView(title: {
            VStack(alignment: .leading) {
                Text("Enable the WireGuard Tunnel")
            }
        }, hero: {
            Image(systemSymbol: .network)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .shadow(color: .accentColor.opacity(0.8), radius: 12)
        }, content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("Once WireGuard is installed, a configuration file has to be installed in the WireGuard app.")
                Text("Tap the button below and open the downloaded file in the WireGuard app.")
                Text("Then, activate the VPN tunnel to continue.")
            }
        }, action: {
            VStack {
                SwiftUI.Button("Download and Install Configuration File") {
                    self.downloadWireGuardProfile()
                }
                .buttonStyle(FilledButtonStyle(isLoading: self.isDownloadingWireGuardProfile))
                .sheet(item: self.$wireGuardProfileFileURL) { fileURL in
                    ActivityView(items: [fileURL])
                }

                SwiftUI.Button(self.isWireGuardTunnelReachable ? "Continue" : "Waiting for connection...",
                               action: self.showNextStep)
                .buttonStyle(FilledButtonStyle())
                .disabled(!self.isWireGuardTunnelReachable)
            }
        })
    }

    var addSourcesView: some View {
        OnboardingStepView(title: {
            VStack(alignment: .leading) {
                Text("Add Sources")
            }
        }, hero: {
            Image(systemSymbol: .booksVertical)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .shadow(color: .accentColor.opacity(0.8), radius: 12)
        }, content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("All apps are provided through sources, which anyone can create and share with the world.")
                Text("We have compiled a list of trusted sources for SideStore which you can enable to start sideloading your favorite apps.")
                Text("By default, only the source containing SideStore itself is enabled.")

                Toggle("Enable Trusted Sources", isOn: $areTrustedSourcesEnabled)
            }
        }, action: {
            SwiftUI.Button("Continue") {
                self.setupTrustedSources()
            }
            .buttonStyle(FilledButtonStyle(isLoading: self.isLoadingTrustedSources))
            .disabled(self.isLoadingTrustedSources)
        })
    }

    var finishView: some View {
        OnboardingStepView(title: {
            VStack(alignment: .leading) {
                Text("Setup Completed")
            }
        }, hero: {
            Image(systemSymbol: .checkmark)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .shadow(color: .accentColor.opacity(0.8), radius: 12)
        }, content: {
            VStack(alignment: .leading, spacing: 16) {
                Text("Congratulations, you did it! 🎉")
                Text("You can now start your sideloading journey.")
            }
        }, action: {
            SwiftUI.Button("Let's Go") {
                self.finishOnboarding()
            }
            .buttonStyle(FilledButtonStyle())
        })
    }

    @ViewBuilder
    func viewForStep(_ step: OnboardingStep) -> some View {
        switch step {
            case .welcome: self.welcomeStep
            case .pairing: self.pairingView
            case .wireguard: self.wireguardView
            case .wireguardConfig: self.wireguardConfigView
            case .addSources: self.addSourcesView
            case .finish: self.finishView
        }
    }
}

extension OnboardingView {
    func showNextStep() {
        guard self.currentStep != self.enabledSteps.last,
              let index = self.enabledSteps.firstIndex(of: self.currentStep) else {
            return self.finishOnboarding()
        }

        withAnimation {
            self.currentStep = self.enabledSteps[index + 1]
        }
    }
}

extension OnboardingView {
    func importPairingFile(url: URL) {
        let isSecuredURL = url.startAccessingSecurityScopedResource() == true

        do {
            // Read to a string
            let data = try Data(contentsOf: url)
            let pairingString = String(bytes: data, encoding: .utf8)
            if pairingString == nil {
                // TODO: Show error message (this will only be triggered if the pairing file is not UTF8)
                debugPrint("Unable to read pairing file")
                // displayError("Unable to read pairing file")
            }

            // Save to a file for next launch
            let filename = "ALTPairingFile.mobiledevicepairing"
            let documentsPath = FileManager.default.documentsDirectory.appendingPathComponent("/\(filename)")
            try pairingString?.write(to: documentsPath, atomically: true, encoding: String.Encoding.utf8)

            // Start minimuxer now that we have a file
            start_minimuxer_threads(pairingString!)

            self.showNextStep()
        } catch {
            NotificationManager.shared.reportError(error: error)
        }

        if (isSecuredURL) {
            url.stopAccessingSecurityScopedResource()
        }
    }

    func start_minimuxer_threads(_ pairing_file: String) {
        target_minimuxer_address()
        let documentsDirectory = FileManager.default.documentsDirectory.absoluteString
        do {
            try start(pairing_file, documentsDirectory)
        } catch {
            try! FileManager.default.removeItem(at: FileManager.default.documentsDirectory.appendingPathComponent("\(pairingFileName)"))
            NotificationManager.shared.reportError(error: error)
            debugPrint("minimuxer failed to start, please restart SideStore.", error)
//            displayError("minimuxer failed to start, please restart SideStore. \(error.message())")
        }
        start_auto_mounter(documentsDirectory)
    }
}

extension OnboardingView {
    func downloadWireGuardProfile() {
        let profileDownloadUrl = "https://github.com/SideStore/SideStore/releases/download/0.3.1/SideStore.conf"
        let destinationUrl = FileManager.default.temporaryDirectory.appendingPathComponent("SideStore.conf")

        self.isDownloadingWireGuardProfile = true
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: profileDownloadUrl)!)) { data, response, error in

            defer { self.isDownloadingWireGuardProfile = false }

            if let error {
                NotificationManager.shared.reportError(error: error)
                return
            }

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode, let data else {
                // TODO: Show error message
                return
            }

            do {
                try data.write(to: destinationUrl)
                self.wireGuardProfileFileURL = destinationUrl
            } catch {
                NotificationManager.shared.reportError(error: error)
                return
            }
        }.resume()
    }

    func startPingingWireGuardTunnel() {
        do {
            self.reachabilityNotifier = try Reachability(hostname: "10.7.0.1")
            self.reachabilityNotifier?.whenReachable = { _ in
                self.isWireGuardTunnelReachable = true
            }
            self.reachabilityNotifier?.whenUnreachable = { _ in
                self.isWireGuardTunnelReachable = false
            }

            try self.reachabilityNotifier?.startNotifier()
        } catch {
            // TODO: Show error message
            debugPrint(error)
            NotificationManager.shared.reportError(error: error)
        }
    }

    func stopPingingWireGuardTunnel() {
        self.reachabilityNotifier?.stopNotifier()
    }
}

extension OnboardingView {
    func setupTrustedSources() {
        guard self.areTrustedSourcesEnabled else {
            return self.showNextStep()
        }

        self.isLoadingTrustedSources = true

        AppManager.shared.fetchTrustedSources { result in

            switch result {
            case .success(let trustedSources):
                // Cache trusted source IDs.
                UserDefaults.shared.trustedSourceIDs = trustedSources.map { $0.identifier }

                // Don't show sources without a sourceURL.
                let featuredSourceURLs = trustedSources.compactMap { $0.sourceURL }

                // This context is never saved, but keeps the managed sources alive.
                let context = DatabaseManager.shared.persistentContainer.newBackgroundSavingViewContext()

                let dispatchGroup = DispatchGroup()
                for sourceURL in featuredSourceURLs {
                    dispatchGroup.enter()

                    AppManager.shared.fetchSource(sourceURL: sourceURL, managedObjectContext: context) { result in
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.isLoadingTrustedSources = false

                    // Save the fetched trusted sources
                    do {
                        try context.save()
                    } catch {
                        NotificationManager.shared.reportError(error: error)
                    }

                    self.showNextStep()
                }
            case .failure(let error):
                NotificationManager.shared.reportError(error: error)
                self.isLoadingTrustedSources = false
            }
        }

    }
}

extension OnboardingView {
    func finishOnboarding() {
        // Set the onboarding complete flag
        UserDefaults.standard.onboardingComplete = true

        if let onDismiss {
            onDismiss()
        } else {
            self.dismiss()
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(OnboardingStep.allCases, id: \.self) { step in
            Color.red
                .ignoresSafeArea()
                .sheet(isPresented: .constant(true)) {
                    OnboardingView(enabledSteps: [step])
                }
        }
    }
}
