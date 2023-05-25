//
//  ConnectAppleIDView.swift
//  SideStore
//
//  Created by Fabian Thies on 29.11.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI
import AltSign

struct ConnectAppleIDView: View {
    typealias AuthenticationHandler = (String, String, @escaping (Result<(ALTAccount, ALTAppleAPISession), Error>) -> Void) -> Void
    typealias CompletionHandler = ((ALTAccount, ALTAppleAPISession, String)?) -> Void
    
    @Environment(\.dismiss)
    private var dismiss
    
    var authenticationHandler: AuthenticationHandler?
    var completionHandler: CompletionHandler?
    
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoading: Bool = false
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                Text(L10n.ConnectAppleIDView.startWithSignIn)
                
                VStack(spacing: 16) {
                    RoundedTextField(title: L10n.ConnectAppleIDView.appleID, placeholder: "user@sidestore.io", text: $email)
                    
                    RoundedTextField(title: L10n.ConnectAppleIDView.password, placeholder: "••••••", text: $password, isSecure: true)
                }
                
                SwiftUI.Button(action: signIn) {
                    Text(L10n.ConnectAppleIDView.signIn)
                        .bold()
                }
                .buttonStyle(FilledButtonStyle(isLoading: isLoading))
                .disabled(!isFormValid)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(L10n.ConnectAppleIDView.whyDoWeNeedThis)
                        .bold()
                    
                    Text(L10n.ConnectAppleIDView.footer)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(.secondarySystemBackground))
                )
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(L10n.ConnectAppleIDView.connectYourAppleID)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                SwiftUI.Button(action: self.cancel) {
                    Text(L10n.ConnectAppleIDView.cancel)
                }
            }
        }
    }
    
    
    func signIn() {
        self.isLoading = true
        self.authenticationHandler?(email, password) { (result) in
            defer {
                self.isLoading = false
            }
            
            switch result
            {
            case .failure(ALTAppleAPIError.requiresTwoFactorAuthentication):
                // Ignore
                break
                
            case .failure(let error as NSError):
                let error = error.withLocalizedFailure(NSLocalizedString(L10n.ConnectAppleIDView.failedToSignIn, comment: ""))
                print(error)
                
            case .success((let account, let session)):
                self.completionHandler?((account, session, password))
            }
        }
    }
    
    func cancel() {
        self.completionHandler?(nil)
//        self.dismiss()
    }
}

struct ConnectAppleIDView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectAppleIDView()
    }
}
