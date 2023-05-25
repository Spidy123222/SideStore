//
//  UIApplication+Alert.swift
//  SideStore
//
//  Created by naturecodevoid on 5/20/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

extension UIApplication {
    static func alertOk(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default))
        
        DispatchQueue.main.async {
            let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true)
            } else {
                print("No key window!")
            }
        }
    }
}
