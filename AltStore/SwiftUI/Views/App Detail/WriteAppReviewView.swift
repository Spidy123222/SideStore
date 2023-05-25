//
//  WriteAppReviewView.swift
//  SideStore
//
//  Created by Fabian Thies on 19.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import AltStoreCore

struct WriteAppReviewView: View {
    @Environment(\.dismiss) var dismiss

    let storeApp: StoreApp

    @State var currentRating = 0
    @State var reviewText = ""

    var canSendReview: Bool {
        // Only allow the user to send the review if a rating has been set and
        // the review text is either empty or doesn't contain only whitespaces.
        self.currentRating > 0 && (
            self.reviewText.isEmpty || !self.reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        )
    }

    var body: some View {
        List {
            // App Information
            HStack {
                AppIconView(iconUrl: storeApp.iconURL, isSideStore: storeApp.isSideStore, size: 50)
                VStack(alignment: .leading) {
                    Text(storeApp.name)
                        .bold()
                    Text(storeApp.developerName)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }

            // Rating
            Section {
                HStack {
                    Spacer()
                    ForEach(1...5) { rating in
                        SwiftUI.Button {
                            self.currentRating = rating
                        } label: {
                            Image(systemSymbol: rating > self.currentRating ? .star : .starFill)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxHeight: 40)
                    }
                    Spacer()
                }
                .foregroundColor(.yellow)
            } header: {
                Text("Rate the App")
            }

            // Review
            Section {
                TextEditor(text: self.$reviewText)
                    .frame(minHeight: 100, maxHeight: 250)
            } header: {
                Text("Leave a Review (optional)")
            }
        }
        .navigationTitle("Write a Review")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                SwiftUI.Button("Cancel", action: self.dismiss)
            }

            ToolbarItem(placement: .confirmationAction) {
                SwiftUI.Button("Send", action: self.sendReview)
                    .disabled(!self.canSendReview)
            }
        }
    }


    private func sendReview() {
        NotificationManager.shared.showNotification(title: "Feature not Implemented")
        self.dismiss()
    }
}

struct WriteAppReviewView_Previews: PreviewProvider {

    static let context = DatabaseManager.shared.viewContext
    static let app = StoreApp.makeAltStoreApp(in: context)

    static var previews: some View {
        NavigationView {
            WriteAppReviewView(storeApp: app)
        }
    }
}
