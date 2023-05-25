//
//  AppAction.swift
//  SideStore
//
//  Created by Fabian Thies on 20.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import Foundation
import SFSafeSymbols

enum AppAction: Int, CaseIterable {
    case install, open, refresh
    case activate, deactivate
    case remove
    case enableJIT
    case backup, exportBackup, restoreBackup
    case chooseCustomIcon, resetCustomIcon
    
    
    var title: String {
        switch self {
        case .install: return L10n.AppAction.install
        case .open: return L10n.AppAction.open
        case .refresh: return L10n.AppAction.refresh
        case .activate: return L10n.AppAction.activate
        case .deactivate: return L10n.AppAction.deactivate
        case .remove: return L10n.AppAction.remove
        case .enableJIT: return L10n.AppAction.enableJIT
        case .backup: return L10n.AppAction.backup
        case .exportBackup: return L10n.AppAction.exportBackup
        case .restoreBackup: return L10n.AppAction.restoreBackup
        case .chooseCustomIcon: return L10n.AppAction.chooseCustomIcon
        case .resetCustomIcon: return L10n.AppAction.resetIcon
        }
    }
    
    var symbol: SFSymbol {
        switch self {
        case .install: return .squareAndArrowDown
        case .open: return .arrowUpForwardApp
        case .refresh: return .arrowClockwise
        case .activate: return .checkmarkCircle
        case .deactivate: return .xmarkCircle
        case .remove: return .trash
        case .enableJIT: return .bolt
        case .backup: return .docOnDoc
        case .exportBackup: return .arrowUpDoc
        case .restoreBackup: return .arrowDownDoc
        case .chooseCustomIcon: return .photo
        case .resetCustomIcon: return .arrowUturnLeft
        }
    }
}
