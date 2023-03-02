//
//  SendAppOperation.swift
//  AltStore
//
//  Created by Riley Testut on 6/7/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//
import Foundation
import Network

import SideStoreCore
import Shared
import SideKit
import MiniMuxerSwift

@objc(SendAppOperation)
final class SendAppOperation: ResultOperation<Void> {
    let context: InstallAppOperationContext

    private let dispatchQueue = DispatchQueue(label: "com.sidestore.SendAppOperation")

    init(context: InstallAppOperationContext) {
        self.context = context

        super.init()

        progress.totalUnitCount = 1
    }

    override func main() {
        super.main()

        if let error = context.error {
            finish(.failure(error))
            return
        }

        guard let resignedApp = context.resignedApp else { return finish(.failure(OperationError.invalidParameters)) }

        // self.context.resignedApp.fileURL points to the app bundle, but we want the .ipa.
        let app = AnyApp(name: resignedApp.name, bundleIdentifier: context.bundleIdentifier, url: resignedApp.fileURL)
        let fileURL = InstalledApp.refreshedIPAURL(for: app)

        print("AFC App `fileURL`: \(fileURL.absoluteString)")

        let ns_bundle = NSString(string: app.bundleIdentifier)
        let ns_bundle_ptr = UnsafeMutablePointer<CChar>(mutating: ns_bundle.utf8String)

        if let data = NSData(contentsOf: fileURL) {
            let pls = UnsafeMutablePointer<UInt8>.allocate(capacity: data.length)
            for (index, data) in data.enumerated() {
                pls[index] = data
            }
            let res = minimuxer_yeet_app_afc(ns_bundle_ptr, pls, UInt(data.length))
            if res == 0 {
                print("minimuxer_yeet_app_afc `res` == \(res)")
                progress.completedUnitCount += 1
                finish(.success(()))
            } else {
                finish(.failure(minimuxer_to_operation(code: res)))
            }

        } else {
            finish(.failure(ALTServerError.unknownResponse))
        }
    }
}