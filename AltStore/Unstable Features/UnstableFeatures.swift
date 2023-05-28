//
//  UnstableFeatures.swift
//  SideStore
//
//  Created by naturecodevoid on 5/20/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import Foundation

class UnstableFeatures {
    fileprivate struct Metadata {
        var availableOutsideDevMode = false
        var onEnable = {}
        var onDisable = {}
    }
    
    enum Feature: String, CaseIterable {
        // The value will be the GitHub Issue number. For example, "123" would correspond to https://github.com/SideStore/SideStore/issues/123
        //
        // Unstable features must have a GitHub Issue for tracking progress, PRs and feedback/bug reporting/commenting.
        //
        // Please order the case by the issue number. They will be ordered by issue number (ascending) in the unstable features menu, so please order them the same way here and in `metadata`.
        
        case swiftUI = "0"
        case jitUrlScheme = "00"
        
        /// Dummy variant to ensure there is always at least one variant. DO NOT USE!
        case dummy = "dummy"
        
        fileprivate var metadata: Metadata {
            switch self {
            // If your unstable feature is stable enough to be used by nightly users who are not alpha testers or developers,
            // you may want to have it available in the Unstable Features menu in Advanced Settings (outside of dev mode). To do so, add this:
            //case .yourFeature: return Metadata(availableOutsideDevMode: true)
            // You can also add custom hooks for when your feature is enabled or disabled. However, we strongly recommend moving these to a new file. Example: https://github.com/SideStore/SideStore/blob/026392dbc7a5454a39b9287f469d32b5e6768bb8/AltStore/Unstable%20Features/UnstableFeatures%2BSwiftUI.swift
            // Please keep the ordering of the cases in this switch statement the same as the ordering of the enum variants!

            case .swiftUI: return Metadata(availableOutsideDevMode: true, onEnable: SwiftUI.onEnable, onDisable: SwiftUI.onDisable)
            case .jitUrlScheme: return Metadata(availableOutsideDevMode: true)
                
            default: return Metadata()
            }
        }
    }
    
    #if UNSTABLE
    private static var features: [Feature: Bool] = [:]
    
    static func getFeatures(_ inDevMode: Bool) -> [(key: Feature, value: Bool)] {
        // Ensure every feature is in the dictionary
        for feature in Feature.allCases {
            if features[feature] == nil {
                features[feature] = false
            }
        }
        
        return features
            .filter { feature, _ in
                feature != .dummy &&
                (inDevMode || feature.metadata.availableOutsideDevMode)
            }.sorted { a, b in a.key.rawValue > b.key.rawValue } // Convert to array of keys and values (and also sort them by issue number)
    }
    
    static func load() {
        if features.count > 0 { return print("It seems unstable features have already been loaded, skipping") }
        
        if let rawFeatures = UserDefaults.shared.unstableFeatures,
           let rawFeatures = try? JSONDecoder().decode([String: Bool].self, from: rawFeatures) {
            for rawFeature in rawFeatures {
                if let feature = Feature.allCases.first(where: { feature in String(describing: feature) == rawFeature.key }) {
                    features[feature] = rawFeature.value
                } else {
                    print("Unknown unstable feature: \(rawFeature.key) = \(rawFeature.value)")
                }
            }
            
            save(load: true)
        } else {
            print("Setting all unstable features to false since we couldn't load them from UserDefaults (either they were never saved or there was an error decoding JSON)")
            for feature in Feature.allCases {
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
    
    static func set(_ feature: Feature, enabled: Bool) {
        features[feature] = enabled
        // Let's save before running the hooks... they might crash the app or something
        save()
        // Should be no-op for features with the default hooks (they do nothing)
        if enabled {
            feature.metadata.onEnable()
        } else {
            feature.metadata.onDisable()
        }
    }
    #endif
    
    @inline(__always) // hopefully this will help the compiler realize that if statements that use this function should be removed on non-unstable builds
    static func enabled(_ feature: Feature) -> Bool {
        #if UNSTABLE
        features[feature] ?? false
        #else
        false
        #endif
    }
}
