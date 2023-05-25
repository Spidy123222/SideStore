//
//  ErrorLogView.swift
//  SideStore
//
//  Created by Fabian Thies on 03.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import AltStoreCore
import ExpandableText

struct ErrorLogView: View {
    @Environment(\.dismiss) var dismiss

    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \LoggedError.date, ascending: false)
    ])
    var loggedErrors: FetchedResults<LoggedError>

    var groupedLoggedErrors: [Date: [LoggedError]] {
        Dictionary(grouping: loggedErrors, by: { Calendar.current.startOfDay(for: $0.date) })
    }

    @State var currentFaqUrl: URL?
    @State var isShowingMinimuxerLog: Bool = false
    @State var isShowingDeleteConfirmation: Bool = false


    var body: some View {
        List {
            ForEach(groupedLoggedErrors.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                Section {
                    let errors = groupedLoggedErrors[date] ?? []
                    ForEach(errors, id: \.date) { error in
                        VStack(spacing: 8) {
                            HStack(alignment: .top) {
                                Group {
                                    if let storeApp = error.storeApp {
                                        AppIconView(iconUrl: storeApp.iconURL, isSideStore: storeApp.isSideStore, size: 50)
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 50*0.234, style: .continuous)
                                                .foregroundColor(Color(UIColor.secondarySystemFill))

                                            Image(systemSymbol: .exclamationmarkCircle)
                                                .imageScale(.large)
                                                .foregroundColor(.red)
                                        }
                                        .frame(width: 50, height: 50)
                                    }
                                }

                                VStack(alignment: .leading) {
                                    Text(error.localizedFailure ?? "Operation Failed")
                                        .bold()

                                    Group {
                                        switch error.domain {
                                        case AltServerErrorDomain: Text("SideServer Error \(error.code)")
                                        case OperationError.domain: Text("SideStore Error \(error.code)")
                                        default: Text(error.error.localizedErrorCode)
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text(DateFormatterHelper.timeString(for: error.date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            let nsError = error.error as NSError
                            let errorDescription = [nsError.localizedDescription, nsError.localizedRecoverySuggestion].compactMap { $0 }.joined(separator: "\n\n")

                            Menu {
                                SwiftUI.Button {
                                    UIPasteboard.general.string = errorDescription
                                } label: {
                                    Label("Copy Error Message", systemSymbol: .docOnDoc)
                                }

                                SwiftUI.Button {
                                    UIPasteboard.general.string = error.error.localizedErrorCode
                                } label: {
                                    Label("Copy Error Code", systemSymbol: .docOnDoc)
                                }

                                SwiftUI.Button {
                                    self.searchFAQ(for: error)
                                } label: {
                                    Label("Search FAQ", systemSymbol: .magnifyingglass)
                                }

                            } label: {
                                Text(errorDescription)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                } header: {
                    Text(DateFormatterHelper.string(for: date))
                }
            }
        }
        .navigationBarTitle("Error Log")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ModalNavigationLink {
                    FilePreviewView(urls: [
                        FileManager.default.documentsDirectory.appendingPathComponent("minimuxer.log")
                    ])
                    .ignoresSafeArea()
                } label: {
                    Image(systemSymbol: .ladybug)
                }


                SwiftUI.Button {
                    self.isShowingDeleteConfirmation = true
                } label: {
                    Image(systemSymbol: .trash)
                }
                .actionSheet(isPresented: self.$isShowingDeleteConfirmation) {
                    ActionSheet(
                        title: Text("Are you sure you want to clear the error log?"),
                        buttons: [
                            .destructive(Text("Clear Error Log"), action: self.clearLoggedErrors),
                            .cancel()
                        ]
                    )
                }
            }
        }
        .sheet(item: self.$currentFaqUrl) { url in
            SafariView(url: url)
        }
    }

    func searchFAQ(for error: LoggedError) {
        let baseURL = URL(string: "https://faq.altstore.io/getting-started/troubleshooting-guide")!
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        let query = [error.domain, "\(error.code)"].joined(separator: "+")
        components.queryItems = [URLQueryItem(name: "q", value: query)]

        self.currentFaqUrl = components.url ?? baseURL
    }

    func clearLoggedErrors() {
        DatabaseManager.shared.purgeLoggedErrors { result in
            if case let .failure(error) = result {
                NotificationManager.shared.reportError(error: error)
            }
        }
    }
}

struct ErrorLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ErrorLogView()
        }
    }
}
