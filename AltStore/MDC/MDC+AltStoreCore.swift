//
//  MDC+AltStoreCore.swift
//  AltStoreCore
//
//  Created by naturecodevoid on 5/31/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import Foundation

// Parts of MDC we need in AltStoreCore
// TODO: destroy AltStoreCore

public class MDC {
    #if MDC
    public static var installdHasBeenPatched: Bool {
        guard let lastInstalldPatchBootTime = UserDefaults.shared.lastInstalldPatchBootTime else { return false }
        return lastInstalldPatchBootTime == bootTime()
    }
    #endif
}

#if MDC
public func bootTime() -> Date? {
    var tv = timeval()
    var tvSize = MemoryLayout<timeval>.size
    let err = sysctlbyname("kern.boottime", &tv, &tvSize, nil, 0)
    guard err == 0, tvSize == MemoryLayout<timeval>.size else {
        return nil
    }
    return Date(timeIntervalSince1970: Double(tv.tv_sec) + Double(tv.tv_usec) / 1_000_000.0)
}
#endif
