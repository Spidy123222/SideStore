//
//  UnstableFeaturesView.swift
//  SideStore
//
//  Created by naturecodevoid on 5/20/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

#if UNSTABLE
import SwiftUI

struct UnstableFeaturesView: View {
    @ObservedObject private var iO = Inject.observer
    
    // Keeping a cache of the features allows us to reload the view every time we change one
    // If we don't reload the view there is a bug where the toggle will be reset to previous value if you go to another tab and then back
    @State private var featureCache: [(key: UnstableFeatures.Feature, value: Bool)]
    
    var inDevMode: Bool
    
    init(inDevMode: Bool) {
        self.inDevMode = inDevMode
        self.featureCache = UnstableFeatures.getFeatures(inDevMode)
    }
    
    var body: some View {
        List {
            let description = L10n.UnstableFeaturesView.description + (featureCache.count <= 0 ? "\n\n" + L10n.UnstableFeaturesView.noUnstableFeatures : "")
            Section {} footer: {
                if #available(iOS 15.0, *),
                   let string = try? AttributedString(markdown: description, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
                    Text(string).font(.callout).foregroundColor(.primary)
                } else {
                    Text(description).font(.callout).foregroundColor(.primary)
                }
            }.listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            if featureCache.count > 0 {
                ForEach(featureCache.sorted(by: { _, _ in true }), id: \.key) { feature, _ in
                    Toggle(isOn: Binding(get: { UnstableFeatures.enabled(feature) }, set: { newValue in
                        UnstableFeatures.set(feature, enabled: newValue)
                        // Update the cache so we reload the view (this fixes the toggle resetting to the previous value if you go to another tab and then back)
                        featureCache = UnstableFeatures.getFeatures(inDevMode)
                    })) {
                        Text(String(describing: feature))
                        let link = "https://github.com/SideStore/SideStore/issues/\(feature.rawValue)"
                        Link(link, destination: URL(string: link)!)
                    }
                }
            }
        }
        .navigationTitle(L10n.UnstableFeaturesView.title)
        .enableInjection()
    }
}

struct UnstableFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        UnstableFeaturesView(inDevMode: true)
    }
}
#endif
