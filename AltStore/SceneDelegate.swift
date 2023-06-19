//
//  SceneDelegate.swift
//  AltStore
//
//  Created by Riley Testut on 7/6/20.
//  Copyright © 2020 Riley Testut. All rights reserved.
//

import UIKit
import AltStoreCore
import EmotionalDamage
import minimuxer

@available(iOS 13, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let context = connectionOptions.urlContexts.first
        {
            self.open(context)
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene)
    {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // applicationWillEnterForeground is _not_ called when launching app,
        // whereas sceneWillEnterForeground _is_ called when launching.
        // As a result, DatabaseManager might not be started yet, so just return if it isn't
        // (since all these methods are called separately during app startup).
        guard DatabaseManager.shared.isStarted else { return }
        
        AppManager.shared.update()
        start_em_proxy(bind_addr: Consts.Proxy.serverURL)
        
        PatreonAPI.shared.refreshPatreonAccount()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene)
    {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        guard UIApplication.shared.applicationState == .background else { return }
        
        // Make sure to update AppDelegate.applicationDidEnterBackground() as well.
                
        guard let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return }
        
        let midnightOneMonthAgo = Calendar.current.startOfDay(for: oneMonthAgo)
        DatabaseManager.shared.purgeLoggedErrors(before: midnightOneMonthAgo) { result in
            switch result
            {
            case .success: break
            case .failure(let error): print("[ALTLog] Failed to purge logged errors before \(midnightOneMonthAgo).", error)
            }
        }
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
    {
        guard let context = URLContexts.first else { return }
        self.open(context)
    }
}

@available(iOS 13.0, *)
private extension SceneDelegate
{
    func open(_ context: UIOpenURLContext)
    {
        if context.url.isFileURL
        {
            guard context.url.pathExtension.lowercased() == "ipa" else { return }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: AppDelegate.importAppDeepLinkNotification, object: nil, userInfo: [AppDelegate.importAppDeepLinkURLKey: context.url])
            }
        }
        else
        {
            guard let components = URLComponents(url: context.url, resolvingAgainstBaseURL: false) else { return }
            guard let host = components.host?.lowercased() else { return }
            let queryItems = components.queryItems?.reduce(into: [String: String]()) { $0[$1.name.lowercased()] = $1.value } ?? [:]
            
            switch host
            {
            case "patreon":
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: AppDelegate.openPatreonSettingsDeepLinkNotification, object: nil)
                }
                
            case "appbackupresponse":
                let result: Result<Void, Error>
                
                switch context.url.path.lowercased()
                {
                case "/success": result = .success(())
                case "/failure":
                    guard
                        let errorDomain = queryItems["errorDomain"],
                        let errorCodeString = queryItems["errorCode"], let errorCode = Int(errorCodeString),
                        let errorDescription = queryItems["errorDescription"]
                    else { return }
                    
                    let error = NSError(domain: errorDomain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                    result = .failure(error)
                    
                default: return
                }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: AppDelegate.appBackupDidFinish, object: nil, userInfo: [AppDelegate.appBackupResultKey: result])
                }
                
            case "install":
                guard let downloadURLString = queryItems["url"], let downloadURL = URL(string: downloadURLString) else { return }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: AppDelegate.importAppDeepLinkNotification, object: nil, userInfo: [AppDelegate.importAppDeepLinkURLKey: downloadURL])
                }
            
            case "source":
                guard let sourceURLString = queryItems["url"], let sourceURL = URL(string: sourceURLString) else { return }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: AppDelegate.addSourceDeepLinkNotification, object: nil, userInfo: [AppDelegate.addSourceDeepLinkURLKey: sourceURL])
                }
                
            case "sidejit-enable":
                guard UnstableFeatures.enabled(.jitUrlScheme) else { return UIApplication.alert(title: "JIT URL scheme unstable feature is not enabled", message: nil) }
                
                if let bundleID = queryItems["bid"] {
                    DispatchQueue.main.async {
                        do {
                            try debug_app(bundleID)
                        } catch {
                            UIApplication.alert(title: "An error occurred when enabling JIT", message: error.message())
                        }
                    }
                } else if let processID = queryItems["pid"] {
                    DispatchQueue.main.async {
                        do {
                            guard let processID = UInt32(processID) else { return UIApplication.alert(title: "An error occurred when enabling JIT", message: "Process ID is not a valid unsigned integer") }
                            try attach_debugger(processID)
                        } catch {
                            UIApplication.alert(title: "An error occurred when enabling JIT", message: error.message())
                        }
                    }
                } else { return UIApplication.alert(title: "An error occurred when enabling JIT", message: "Please specify a bundle ID using the `bid` query parameter or a process ID using `pid` query parameter") }
                
            default: break
            }
        }
    }
}
