//
//  RefreshAttemptsView.swift
//  SideStore
//
//  Created by Fabian Thies on 04.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import AltStoreCore

struct RefreshAttemptsView: View {
    @SwiftUI.FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \RefreshAttempt.date, ascending: false)
    ])
    var refreshAttempts: FetchedResults<RefreshAttempt>

    var groupedRefreshAttempts: [Date: [RefreshAttempt]] {
        Dictionary(grouping: refreshAttempts, by: { Calendar.current.startOfDay(for: $0.date) })
    }

    var body: some View {
        List {
            ForEach(groupedRefreshAttempts.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                Section {
                    let attempts = groupedRefreshAttempts[date] ?? []
                    ForEach(attempts, id: \.date) { attempt in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                if attempt.isSuccess {
                                    Text("Success")
                                        .bold()
                                        .foregroundColor(.green)
                                } else {
                                    Text("Failure")
                                        .bold()
                                        .foregroundColor(.red)
                                }

                                Spacer()

                                Text(DateFormatterHelper.timeString(for: attempt.date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            if let description = attempt.errorDescription {
                                Text(description)
                            }
                        }
                    }
                } header: {
                    Text(DateFormatterHelper.string(for: date))
                }
            }
        }
        .background(self.listBackground)
        .navigationTitle("Refresh Attempts")
    }

    @ViewBuilder
    var listBackground: some View {
        if self.refreshAttempts.isEmpty {
            VStack(spacing: 8) {
                Spacer()
                Text("No Refresh Attempts")
                    .font(.title)

                Text("The more you use SideStore, the more often iOS will allow it to refresh apps in the background.")

                Spacer()
            }
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
            .padding()
        } else {
            Color.clear
        }
    }
}


struct RefreshAttemptsView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            RefreshAttemptsView()
        }
    }
}
