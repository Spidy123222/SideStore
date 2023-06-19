//
//  UIApplication+SideStore.swift
//  SideStore
//
//  Created by naturecodevoid on 5/20/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

extension UIApplication {
    static var keyWindow: UIWindow? {
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first
    }
    
    static var topController: UIViewController? {
        guard var topController = keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
    static func alert(
        title: String? = nil,
        message: String? = nil,
        leftButton: (text: String, action: ((UIAlertAction) -> Void)?)? = nil,
        rightButton: (text: String, action: ((UIAlertAction) -> Void)?)? = nil,
        leftButtonStyle: UIAlertAction.Style = .default,
        rightButtonStyle: UIAlertAction.Style = .default
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let leftButton = leftButton {
            alert.addAction(UIAlertAction(title: leftButton.text, style: leftButtonStyle, handler: leftButton.action))
        }
        if let rightButton = rightButton {
            alert.addAction(UIAlertAction(title: rightButton.text, style: rightButtonStyle, handler: rightButton.action))
        }
        if rightButton == nil && leftButton == nil {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default))
        }
        
        DispatchQueue.main.async {
            topController?.present(alert, animated: true)
        }
    }
}
