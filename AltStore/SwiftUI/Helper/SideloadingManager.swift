//
//  SideloadingManager.swift
//  SideStore
//
//  Created by Fabian Thies on 20.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
import AltStoreCore
import CAltSign
import Roxas

// TODO: Move this to the AppManager
class SideloadingManager {
    class Context {
        var fileURL: URL?
        var application: ALTApplication?
        var installedApp: InstalledApp? {
            didSet {
                self.installedAppContext = self.installedApp?.managedObjectContext
            }
        }
        private var installedAppContext: NSManagedObjectContext?
        var error: Error?
    }
      
    
    public static let shared = SideloadingManager()
    
    @Published
    public var progress: Progress?
    
    private let operationQueue = OperationQueue()
    
    private init() {}
    
    
    // TODO: Refactor & convert to async
    func sideloadApp(at url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        self.progress = Progress.discreteProgress(totalUnitCount: 100)
        
        let temporaryDirectory = FileManager.default.uniqueTemporaryURL()
        let unzippedAppDirectory = temporaryDirectory.appendingPathComponent("App")
        
        let context = Context()
        
        let downloadOperation: RSTAsyncBlockOperation?
        
        if url.isFileURL {
            downloadOperation = nil
            context.fileURL = url
            self.progress?.totalUnitCount -= 20
        } else {
            let downloadProgress = Progress.discreteProgress(totalUnitCount: 100)
            
            downloadOperation = RSTAsyncBlockOperation { (operation) in
                let downloadTask = URLSession.shared.downloadTask(with: url) { (fileURL, response, error) in
                    do
                    {
                        let (fileURL, _) = try Result((fileURL, response), error).get()
                        
                        try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)
                        
                        let destinationURL = temporaryDirectory.appendingPathComponent("App.ipa")
                        try FileManager.default.moveItem(at: fileURL, to: destinationURL)
                        
                        context.fileURL = destinationURL
                    }
                    catch
                    {
                        context.error = error
                    }
                    operation.finish()
                }
                downloadProgress.addChild(downloadTask.progress, withPendingUnitCount: 100)
                downloadTask.resume()
            }
            self.progress?.addChild(downloadProgress, withPendingUnitCount: 20)
        }
        
        let unzipProgress = Progress.discreteProgress(totalUnitCount: 1)
        let unzipAppOperation = BlockOperation {
            do
            {
                if let error = context.error
                {
                    throw error
                }
                
                guard let fileURL = context.fileURL else { throw OperationError.invalidParameters }
                defer {
                    try? FileManager.default.removeItem(at: fileURL)
                }
                
                try FileManager.default.createDirectory(at: unzippedAppDirectory, withIntermediateDirectories: true, attributes: nil)
                let unzippedApplicationURL = try FileManager.default.unzipAppBundle(at: fileURL, toDirectory: unzippedAppDirectory)
                
                guard let application = ALTApplication(fileURL: unzippedApplicationURL) else { throw OperationError.invalidApp }
                context.application = application
                
                unzipProgress.completedUnitCount = 1
            }
            catch
            {
                context.error = error
            }
        }
        self.progress?.addChild(unzipProgress, withPendingUnitCount: 10)
        
        if let downloadOperation = downloadOperation
        {
            unzipAppOperation.addDependency(downloadOperation)
        }
        
        let removeAppExtensionsProgress = Progress.discreteProgress(totalUnitCount: 1)

        let removeAppExtensionsOperation = RSTAsyncBlockOperation { [weak self] (operation) in
            do
            {
                if let error = context.error
                {
                    throw error
                }
                
                guard let application = context.application else { throw OperationError.invalidParameters }
                
                DispatchQueue.main.async {
                    self?.removeAppExtensions(from: application) { (result) in
                        switch result
                        {
                        case .success: removeAppExtensionsProgress.completedUnitCount = 1
                        case .failure(let error): context.error = error
                        }
                        operation.finish()
                    }
                }
            }
            catch
            {
                context.error = error
                operation.finish()
            }
        }
        removeAppExtensionsOperation.addDependency(unzipAppOperation)
        self.progress?.addChild(removeAppExtensionsProgress, withPendingUnitCount: 5)
        
        let installProgress = Progress.discreteProgress(totalUnitCount: 100)
        let installAppOperation = RSTAsyncBlockOperation { (operation) in
            do
            {
                if let error = context.error
                {
                    throw error
                }
                
                guard let application = context.application else { throw OperationError.invalidParameters }
                
                let group = AppManager.shared.install(application, presentingViewController: nil) { (result) in
                    switch result
                    {
                    case .success(let installedApp): context.installedApp = installedApp
                    case .failure(let error): context.error = error
                    }
                    operation.finish()
                }
                installProgress.addChild(group.progress, withPendingUnitCount: 100)
            }
            catch
            {
                context.error = error
                operation.finish()
            }
        }
        installAppOperation.completionBlock = {
            try? FileManager.default.removeItem(at: temporaryDirectory)
            
            DispatchQueue.main.async {
                self.progress = nil
                
                switch Result(context.installedApp, context.error)
                {
                case .success(let app):
                    completion(.success(()))
                    
                    app.managedObjectContext?.perform {
                        print("Successfully installed app:", app.bundleIdentifier)
                    }
                    
                case .failure(OperationError.cancelled):
                    completion(.failure((OperationError.cancelled)))
                    
                case .failure(let error):
                    NotificationManager.shared.reportError(error: error)
                    
                    completion(.failure(error))
                }
            }
        }
        self.progress?.addChild(installProgress, withPendingUnitCount: 65)
        installAppOperation.addDependency(removeAppExtensionsOperation)
        
        let operations = [downloadOperation, unzipAppOperation, removeAppExtensionsOperation, installAppOperation].compactMap { $0 }
        self.operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    
    
    // TODO: Refactor
    private func removeAppExtensions(from application: ALTApplication, completion: @escaping (Result<Void, Error>) -> Void)
    {
        guard !application.appExtensions.isEmpty else { return completion(.success(())) }
        
        let firstSentence: String
        
        if UserDefaults.standard.activeAppLimitIncludesExtensions
        {
            firstSentence = NSLocalizedString("Non-developer Apple IDs are limited to 3 active apps and app extensions.", comment: "")
        }
        else
        {
            firstSentence = NSLocalizedString("Non-developer Apple IDs are limited to creating 10 App IDs per week.", comment: "")
        }
        
        let message = firstSentence + " " + NSLocalizedString("Would you like to remove this app's extensions so they don't count towards your limit?", comment: "")
        
        let alertController = UIAlertController(title: NSLocalizedString("App Contains Extensions", comment: ""), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: UIAlertAction.cancel.title, style: UIAlertAction.cancel.style, handler: { (action) in
            completion(.failure(OperationError.cancelled))
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Keep App Extensions", comment: ""), style: .default) { (action) in
            completion(.success(()))
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Remove App Extensions", comment: ""), style: .destructive) { (action) in
            do
            {
                for appExtension in application.appExtensions
                {
                    try FileManager.default.removeItem(at: appExtension.fileURL)
                }
                
                completion(.success(()))
            }
            catch
            {
                completion(.failure(error))
            }
        })
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
