//
//  DateFormatterHelper.swift
//  SideStore
//
//  Created by Fabian Thies on 20.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import Foundation

struct DateFormatterHelper {
    
    private static let appExpirationDateFormatter: DateComponentsFormatter = {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.zeroFormattingBehavior = [.pad]
        dateComponentsFormatter.collapsesLargestUnit = false
        return dateComponentsFormatter
    }()

    private static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    private static let mediumDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()

    private static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    
    
    static func string(forExpirationDate date: Date) -> String {
        let startDate = Date()
        let interval = date.timeIntervalSince(startDate)
        guard interval > 0 else {
            return "EXPIRED"
        }
        
        if interval < (24 * 60 * 60) {
            self.appExpirationDateFormatter.unitsStyle = .positional
            self.appExpirationDateFormatter.allowedUnits = [.minute, .second]
        } else {
            self.appExpirationDateFormatter.unitsStyle = .full
            self.appExpirationDateFormatter.allowedUnits = [.day]
        }
        
        return self.appExpirationDateFormatter.string(from: startDate, to: date) ?? ""
    }

    static func string(forRelativeDate date: Date, to referenceDate: Date = Date()) -> String {
        self.relativeDateFormatter.localizedString(for: date, relativeTo: referenceDate)
    }

    static func string(for date: Date) -> String {
        self.mediumDateFormatter.string(from: date)
    }

    static func timeString(for date: Date) -> String {
        self.timeFormatter.string(from: date)
    }
}
