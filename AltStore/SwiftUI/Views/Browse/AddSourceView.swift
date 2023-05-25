//
//  AddSourceView.swift
//  SideStore
//
//  Created by Fabian Thies on 20.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import SFSafeSymbols

struct AddSourceView: View {
    
    @State var sourceUrlText: String = ""
    
    var continueHandler: (_ urlText: String) -> ()
    
    var body: some View {
        List {
            Section {
                TextField("https://connect.altstore.ml", text: $sourceUrlText)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            } header: {
                Text(L10n.AddSourceView.sourceURL)
            } footer: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.AddSourceView.sourceWarning)
                    
                    HStack(alignment: .top) {
                        Image(systemSymbol: .exclamationmarkTriangleFill)
                        
                        Text(L10n.AddSourceView.sourceWarningContinued)
                    }
                }
            }
            
            SwiftUI.Button {
                self.continueHandler(self.sourceUrlText)
            } label: {
                Text(L10n.AddSourceView.continue)
            }
            .disabled(URL(string: self.sourceUrlText)?.host == nil)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(L10n.AddSourceView.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddSourceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSourceView(continueHandler: { _ in })
    }
}
