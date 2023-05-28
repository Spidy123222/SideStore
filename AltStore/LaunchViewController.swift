//
//  LaunchViewController.swift
//  AltStore
//
//  Created by Riley Testut on 7/30/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

import UIKit
import SwiftUI
import Roxas
import EmotionalDamage
import minimuxer

import AltStoreCore
import UniformTypeIdentifiers

let pairingFileName = "ALTPairingFile.mobiledevicepairing"

final class LaunchViewController: RSTLaunchViewController, UIDocumentPickerDelegate
{
    private var didFinishLaunching = false
    
    private var destinationViewController: UIViewController!
    
    override var launchConditions: [RSTLaunchCondition] {
        let isDatabaseStarted = RSTLaunchCondition(condition: { DatabaseManager.shared.isStarted }) { (completionHandler) in
            DatabaseManager.shared.start(completionHandler: completionHandler)
        }

        return [isDatabaseStarted]
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.children.first
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.children.first
    }
    
    override func viewDidLoad()
    {
        defer {
            if UnstableFeatures.enabled(.swiftUI) {
                let rootView = RootView()
                    .environment(\.managedObjectContext, DatabaseManager.shared.viewContext)
                self.destinationViewController = UIHostingController(rootView: rootView)
            } else {
                // Create destinationViewController now so view controllers can register for receiving Notifications.
                self.destinationViewController = self.storyboard!.instantiateViewController(withIdentifier: "tabBarController") as! TabBarController
            }
        }
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        #if !targetEnvironment(simulator)
        if !UserDefaults.standard.onboardingComplete {
            self.showOnboarding()
            return
        }

        start_em_proxy(bind_addr: Consts.Proxy.serverURL)
        
        guard let pf = fetchPairingFile() else {
            self.showOnboarding(enabledSteps: [.pairing])
            return
        }
        start_minimuxer_threads(pf)
        #endif
    }

    func showOnboarding(enabledSteps: [OnboardingStep] = OnboardingStep.allCases) {
        let onboardingView = OnboardingView(onDismiss: { self.dismiss(animated: true) }, enabledSteps: enabledSteps)
            .environment(\.managedObjectContext, DatabaseManager.shared.viewContext)
        let navigationController = UINavigationController(rootViewController: UIHostingController(rootView: onboardingView))
        navigationController.isNavigationBarHidden = true
        navigationController.isModalInPresentation = true
        self.present(navigationController, animated: true)
    }
    
    func fetchPairingFile() -> String? {
        let filename = "ALTPairingFile.mobiledevicepairing"
        let fm = FileManager.default
        let documentsPath = fm.documentsDirectory.appendingPathComponent("/\(filename)")
        if fm.fileExists(atPath: documentsPath.path), let contents = try? String(contentsOf: documentsPath), !contents.isEmpty {
            print("Loaded ALTPairingFile from \(documentsPath.path)")
            return contents
        } else if
            let appResourcePath = Bundle.main.url(forResource: "ALTPairingFile", withExtension: "mobiledevicepairing"),
            fm.fileExists(atPath: appResourcePath.path),
            let data = fm.contents(atPath: appResourcePath.path),
            let contents = String(data: data, encoding: .utf8),
            !contents.isEmpty  {
            print("Loaded ALTPairingFile from \(appResourcePath.path)")
            return contents
        } else if let plistString = Bundle.main.object(forInfoDictionaryKey: "ALTPairingFile") as? String, !plistString.isEmpty, !plistString.contains("insert pairing file here"){
            print("Loaded ALTPairingFile from Info.plist")
            return plistString
        }
        return nil
    }

    func displayError(_ msg: String) {
        print(msg)
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Error launching SideStore", message: msg, preferredStyle: .alert)

        // Present alert to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        let isSecuredURL = url.startAccessingSecurityScopedResource() == true

        do {
            // Read to a string
            let data1 = try Data(contentsOf: urls[0])
            let pairing_string = String(bytes: data1, encoding: .utf8)
            if pairing_string == nil {
                displayError("Unable to read pairing file")
            }
            
            // Save to a file for next launch
            let pairingFile = FileManager.default.documentsDirectory.appendingPathComponent("\(pairingFileName)")
            try pairing_string?.write(to: pairingFile, atomically: true, encoding: String.Encoding.utf8)
            
            // Start minimuxer now that we have a file
            start_minimuxer_threads(pairing_string!)
        } catch {
            displayError("Unable to read pairing file")
        }
        
        if (isSecuredURL) {
            url.stopAccessingSecurityScopedResource()
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        displayError("Choosing a pairing file was cancelled. Please re-open the app and try again.")
    }
    
    func start_minimuxer_threads(_ pairing_file: String) {
        target_minimuxer_address()
        let documentsDirectory = FileManager.default.documentsDirectory.absoluteString
        do {
            try start(pairing_file, documentsDirectory)
        } catch {
            try! FileManager.default.removeItem(at: FileManager.default.documentsDirectory.appendingPathComponent("\(pairingFileName)"))
            displayError("minimuxer failed to start, please restart SideStore. \((error as? LocalizedError)?.failureReason ?? "UNKNOWN ERROR!!!!!! REPORT TO GITHUB ISSUES!")")
        }
        set_debug(UserDefaults.shared.isDebugLoggingEnabled)
        start_auto_mounter(documentsDirectory)
    }
}

extension LaunchViewController
{
    override func handleLaunchError(_ error: Error)
    {
        do
        {
            throw error
        }
        catch let error as NSError
        {
            let title = error.userInfo[NSLocalizedFailureErrorKey] as? String ?? NSLocalizedString("Unable to Launch SideStore", comment: "")
            
            let errorDescription: String
            
            if #available(iOS 14.5, *)
            {
                let errorMessages = [error.debugDescription] + error.underlyingErrors.map { ($0 as NSError).debugDescription }
                errorDescription = errorMessages.joined(separator: "\n\n")
            }
            else
            {
                errorDescription = error.debugDescription
            }
            
            let alertController = UIAlertController(title: title, message: errorDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default, handler: { (action) in
                self.handleLaunchConditions()
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func finishLaunching()
    {
        super.finishLaunching()
        
        guard !self.didFinishLaunching else { return }
        
        AppManager.shared.update()
        AppManager.shared.updatePatronsIfNeeded()        
        PatreonAPI.shared.refreshPatreonAccount()
        
        // Add view controller as child (rather than presenting modally)
        // so tint adjustment + card presentations works correctly.
        self.destinationViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.destinationViewController.view.alpha = 0.0
        self.addChild(self.destinationViewController)
        self.view.addSubview(self.destinationViewController.view, pinningEdgesWith: .zero)
        self.destinationViewController.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.2) {
            self.destinationViewController.view.alpha = 1.0
        }
        
        self.didFinishLaunching = true
    }
}
