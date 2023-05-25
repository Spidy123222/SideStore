//
//  NotificationManager.swift
//  SideStore
//
//  Created by Fabian Thies on 21.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import AltStoreCore

class NotificationManager: ObservableObject {
    
    struct Notification: Identifiable {
        let id: UUID
        let title: String
        let message: String?
    }
    
    static let shared = NotificationManager()
    
    @Published
    var notifications: [UUID: Notification] = [:]
    
    private init() {}
    
    func reportError(error: Error) {
        if case OperationError.cancelled = error {
            // Ignore
            return
        }
        
        var error = error as NSError
        var underlyingError = error.underlyingError
        
        if
            let unwrappedUnderlyingError = underlyingError,
            error.domain == AltServerErrorDomain && error.code == ALTServerError.Code.underlyingError.rawValue
        {
            // Treat underlyingError as the primary error.
            
            error = unwrappedUnderlyingError as NSError
            underlyingError = nil
        }
        
        let text: String
        let detailText: String?
        
        if let failure = error.localizedFailure
        {
            text = failure
            detailText = error.localizedFailureReason ?? error.localizedRecoverySuggestion ?? underlyingError?.localizedDescription ?? error.localizedDescription
        }
        else if let reason = error.localizedFailureReason
        {
            text = reason
            detailText = error.localizedRecoverySuggestion ?? underlyingError?.localizedDescription
        }
        else
        {
            text = error.localizedDescription
            detailText = underlyingError?.localizedDescription ?? error.localizedRecoverySuggestion
        }
        
        self.showNotification(title: text, detailText: detailText)
    }

    func showNotification(title: String, detailText: String? = nil) {
        let notificationId = UUID()
        
        DispatchQueue.main.async {
            self.notifications[notificationId] = Notification(id: notificationId, title: title, message: detailText)
        }
        
        let dismissWorkItem = DispatchWorkItem {
            self.notifications.removeValue(forKey: notificationId)
        }
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(5)), execute: dismissWorkItem)
    }
}
