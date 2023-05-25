//
//  ConfirmAddSourceView.swift
//  SideStore
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
import AltStoreCore

struct ConfirmAddSourceView: View {
    
    let fetchedSource: FetchedSource
    var source: Source {
        fetchedSource.source
    }
    
    var confirmationHandler: (_ source: FetchedSource) -> ()
    var cancellationHandler: () -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text("\(source.apps.count) \(L10n.ConfirmAddSourceView.apps)")
                        
                        Text(source.apps.map { $0.name }.joined(separator: ", "))
                            .font(.callout)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack() {
                        Text("\(source.newsItems.count) \(L10n.ConfirmAddSourceView.newsItems)")
                    }
                } header: {
                    Text(L10n.ConfirmAddSourceView.sourceContents)
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text(L10n.ConfirmAddSourceView.sourceIdentifier)
                        Text(source.identifier)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(L10n.ConfirmAddSourceView.sourceURL)
                        Text(source.sourceURL.absoluteString)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text(L10n.ConfirmAddSourceView.sourceInfo)
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            Spacer()
            
            SwiftUI.Button {
                confirmationHandler(fetchedSource)
            } label: {
                Label(L10n.ConfirmAddSourceView.addSource, systemSymbol: .plus)
            }
            .buttonStyle(FilledButtonStyle())
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                SwiftUI.Button {
                    
                } label: {
                    Image(systemSymbol: .xmarkCircleFill)
                        .foregroundColor(.secondary)
                }

            }
            
            ToolbarItemGroup(placement: .navigation) {
                VStack(alignment: .leading) {
                    Text(source.name)
                        .font(.title3)
                        .bold()
                    
                    Text(source.identifier)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConfirmAddSourceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSourceView(continueHandler: { _ in })
    }
}
