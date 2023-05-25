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
    
    var inDevMode: Bool
    
    var body: some View {
        List {
            let features = UnstableFeatures.getFeatures(inDevMode)
            
            let description = L10n.UnstableFeaturesView.description + (features.count <= 0 ? "\n\n" + L10n.UnstableFeaturesView.noUnstableFeatures : "")
            Section {} footer: {
                if #available(iOS 15.0, *),
                   let string = try? AttributedString(markdown: description, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
                    Text(string).font(.callout).foregroundColor(.primary)
                } else {
                    Text(description).font(.callout).foregroundColor(.primary)
                }
            }.listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            
            if features.count > 0 {
                ForEach(features.sorted(by: { _, _ in true }), id: \.key) { feature, _ in
                    Toggle(isOn: Binding(get: { UnstableFeatures.enabled(feature) }, set: { newValue in UnstableFeatures.set(feature, enabled: newValue) })) {
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
