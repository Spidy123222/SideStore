//
//  UnstableFeatures.swift
//  SideStore
//
//  Created by naturecodevoid on 5/20/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI

// I prefixed it with Available to make UnstableFeatures come up first in autocomplete, feel free to rename it if you know a better name
enum AvailableUnstableFeature: String, CaseIterable {
    // The value will be the GitHub Issue number. For example, "123" would correspond to https://github.com/SideStore/SideStore/issues/123
    //
    // Unstable features must have a GitHub Issue for tracking progress, PRs and feedback/commenting.
    
    case jitUrlScheme = "0"
    
    /// Dummy variant to ensure there is always at least one variant. DO NOT USE!
    case dummy = "dummy"
    
    func availableOutsideDevMode() -> Bool {
        switch self {
        // If your unstable feature is stable enough to be used by nightly users who are not alpha testers or developers,
        // you may want to have it available in the Unstable Features menu in Advanced Settings (outside of dev mode). To do so, add this:
        //case .yourFeature: return true
        case .jitUrlScheme: return true
        
        default: return false
        }
    }
}


class UnstableFeatures: ObservableObject {
    #if UNSTABLE
    private static var features: [AvailableUnstableFeature: Bool] = [:]
    
    static func getFeatures(_ inDevMode: Bool) -> [(key: AvailableUnstableFeature, value: Bool)] {
        return features
            .filter { feature, _ in
                feature != .dummy &&
                (inDevMode || feature.availableOutsideDevMode())
            }.sorted { a, b in a.key.rawValue > b.key.rawValue } // Convert to array of keys and values
    }
    
    static func load() {
        if features.count > 0 { return print("It seems unstable features have already been loaded, skipping") }
        
        if let rawFeatures = UserDefaults.shared.unstableFeatures,
           let rawFeatures = try? JSONDecoder().decode([String: Bool].self, from: rawFeatures) {
            for rawFeature in rawFeatures {
                if let feature = AvailableUnstableFeature.allCases.first(where: { feature in String(describing: feature) == rawFeature.key }) {
                    features[feature] = rawFeature.value
                } else {
                    print("Unknown unstable feature: \(rawFeature.key) = \(rawFeature.value)")
                }
            }
            
            // If there's a new feature that wasn't saved and therefore wasn't loaded, let's set it to false
            // Technically we shouldn't have to do this because enabled() will fallback to false
            for feature in AvailableUnstableFeature.allCases {
                if features[feature] == nil {
                    features[feature] = false
                }
            }
            
            save(load: true)
        } else {
            print("Setting all unstable features to false since we couldn't load them from UserDefaults (either they were never saved or there was an error decoding JSON)")
            for feature in AvailableUnstableFeature.allCases {
                features[feature] = false
            }
            save()
        }
    }
    
    private static func save(load: Bool = false) {
        var rawFeatures: [String: Bool] = [:]
        for feature in features {
            rawFeatures[String(describing: feature.key)] = feature.value
        }
        UserDefaults.shared.unstableFeatures = try! JSONEncoder().encode(rawFeatures)
        print("\(load ? "Loaded" : "Saved") unstable features: \(String(describing: rawFeatures))")
    }
    
    static func set(_ feature: AvailableUnstableFeature, enabled: Bool) {
        features[feature] = enabled
        save()
    }
    #endif
    
    @inline(__always) // hopefully this will help the compiler realize that if statements that use this function should be removed on non-unstable builds
    static func enabled(_ feature: AvailableUnstableFeature) -> Bool {
        #if UNSTABLE
        features[feature] ?? false
        #else
        false
        #endif
    }
}
