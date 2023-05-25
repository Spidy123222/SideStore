//
//  SourcesView.swift
//  SideStore
//
//  Created by Fabian Thies on 20.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
import AltStoreCore
import CoreData

struct SourcesView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(\.managedObjectContext)
    var managedObjectContext
    
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \Source.name, ascending: true),
        NSSortDescriptor(keyPath: \Source.sourceURL, ascending: true),
        NSSortDescriptor(keyPath: \Source.identifier, ascending: true)
    ])
    var installedSources: FetchedResults<Source>

    @State var trustedSources: [Source] = []
    @State private var isLoadingTrustedSources: Bool = false
    @State private var sourcesFetchContext: NSManagedObjectContext?
    
    @State var isShowingAddSourceAlert = false
    @State var sourceToConfirm: FetchedSource?
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // Installed Sources
                LazyVStack(alignment: .leading, spacing: 12) {
                    Text(L10n.SourcesView.sourcesDescription)
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    ForEach(installedSources, id: \.identifier) { source in
                        
                        VStack(alignment: .leading) {
                            Text(source.name)
                                .bold()
                            
                            Text(source.sourceURL.absoluteString)
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .tintedBackground(.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .circular))
                        .if(source.identifier != Source.altStoreIdentifier) { view in
                            view.contextMenu(ContextMenu(menuItems: {
                                SwiftUI.Button {
                                    self.removeSource(source)
                                } label: {
                                    Label(L10n.SourcesView.remove, systemSymbol: .trash)
                                }
                            }))
                        }
                    }
                }
                
                // Trusted Sources
                LazyVStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 4) {
                        Text(L10n.SourcesView.trustedSources)
                            .font(.title3)
                            .bold()

                        Image(systemSymbol: .shieldLefthalfFill)
                            .foregroundColor(.accentColor)
                    }
                    
                    Text(L10n.SourcesView.reviewedText)
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    if self.isLoadingTrustedSources {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(self.trustedSources, id: \.sourceURL) { source in

                            HStack {
                                VStack(alignment: .leading) {
                                    Text(source.name)
                                        .bold()

                                    Text(source.sourceURL.absoluteString)
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                if self.installedSources.contains(where: { $0.sourceURL == source.sourceURL }) {
                                    Image(systemSymbol: .checkmarkCircle)
                                        .foregroundColor(.accentColor)
                                } else {
                                    SwiftUI.Button {
                                        self.fetchSource(with: source.sourceURL.absoluteString)
                                    } label: {
                                        Text("ADD")
                                            .bold()
                                    }
                                    .buttonStyle(PillButtonStyle(tintColor: Asset.accentColor.color, progress: nil))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .tintedBackground(.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .circular))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(L10n.SourcesView.sources)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                SwiftUI.Button {
                    self.isShowingAddSourceAlert = true
                } label: {
                    Image(systemSymbol: .plus)
                }
                .sheet(isPresented: self.$isShowingAddSourceAlert) {
                    NavigationView {
                        AddSourceView(continueHandler: fetchSource(with:))
                    }
                }
                .sheet(item: self.$sourceToConfirm) { source in
                    if #available(iOS 16.0, *) {
                        NavigationView {
                            ConfirmAddSourceView(fetchedSource: source, confirmationHandler: addSource(_:)) {
                                self.sourceToConfirm = nil
                            }
                        }
                        .presentationDetents([.medium])
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                SwiftUI.Button(action: self.dismiss) {
                    Text(L10n.SourcesView.done).bold()
                }
            }
        }
        .onAppear(perform: self.fetchTrustedSources)
    }
    
    
    func fetchSource(with urlText: String) {
        self.isShowingAddSourceAlert = false
        
        guard let url = URL(string: urlText) else {
            return
        }

        let context = DatabaseManager.shared.persistentContainer.newBackgroundSavingViewContext()

        AppManager.shared.fetchSource(sourceURL: url, managedObjectContext: context) { result in
            
            switch result {
            case let .success(source):
                self.sourceToConfirm = FetchedSource(source: source, context: context)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func addSource(_ source: FetchedSource) {
        source.context.perform {
            do {
                try source.context.save()
            } catch {
                print(error)
                NotificationManager.shared.reportError(error: error)
            }
        }
        
        self.sourceToConfirm = nil
    }
    
    func removeSource(_ source: Source) {
        DatabaseManager.shared.persistentContainer.performBackgroundTask { (context) in
            let source = context.object(with: source.objectID) as! Source
            context.delete(source)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchTrustedSources() {
        self.isLoadingTrustedSources = true

        AppManager.shared.fetchTrustedSources { result in

            switch result {
            case .success(let trustedSources):
                // Cache trusted source IDs.
                UserDefaults.shared.trustedSourceIDs = trustedSources.map { $0.identifier }

                // Don't show sources without a sourceURL.
                let featuredSourceURLs = trustedSources.compactMap { $0.sourceURL }

                // This context is never saved, but keeps the managed sources alive.
                let context = DatabaseManager.shared.persistentContainer.newBackgroundSavingViewContext()
                self.sourcesFetchContext = context

                let dispatchGroup = DispatchGroup()

                var sourcesByURL = [URL: Source]()
                var errors: [(error: Error, sourceURL: URL)] = []

                for sourceURL in featuredSourceURLs {
                    dispatchGroup.enter()

                    AppManager.shared.fetchSource(sourceURL: sourceURL, managedObjectContext: context) { result in
                        defer {
                            dispatchGroup.leave()
                        }

                        // Serialize access to sourcesByURL.
                        context.performAndWait {
                            switch result
                            {
                            case .failure(let error): errors.append((error, sourceURL))
                            case .success(let source): sourcesByURL[source.sourceURL] = source
                            }
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    if let (error, _) = errors.first {
                        NotificationManager.shared.reportError(error: error)
                    }
                    let sources = featuredSourceURLs.compactMap { sourcesByURL[$0] }
                    self.trustedSources = sources

                    self.isLoadingTrustedSources = false
                }

            case .failure(let error):
                NotificationManager.shared.reportError(error: error)
                self.isLoadingTrustedSources = false
            }
        }
    }
}

struct SourcesView_Previews: PreviewProvider {
    static var previews: some View {
            Color.clear
                .sheet(isPresented: .constant(true)) {
                    NavigationView {
                        SourcesView()
                    }
                }
    }
}


extension Source: Identifiable {
    public var id: String {
        self.identifier
    }
}


struct FetchedSource: Identifiable {
    let source: Source
    let context: NSManagedObjectContext
    
    var id: String {
        source.identifier
    }
    
    init(source: Source, context: NSManagedObjectContext) {
        self.source = source
        self.context = context
    }
}
