//
//  Remove3AppLimitView.swift
//  SideStore
//
//  Created by naturecodevoid on 5/29/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

#if MDC
import SwiftUI
import AltStoreCore

fileprivate extension View {
    func common() -> some View {
        self
            .padding()
            .transition(.opacity.animation(.linear))
    }
}

struct Remove3AppLimitView: View {
    @ObservedObject private var iO = Inject.observer
    
    @State var runningPatch = false
    @State private var showErrorAlert = false
    @State private var errorAlertMessage = ""
    @State private var showSuccessAlert = false
    
    @ViewBuilder
    private var notSupported: some View {
        Text(L10n.Remove3AppLimitView.notSupported)
    }
    
    @ViewBuilder
    private var installdHasBeenPatched: some View {
        Text(L10n.Remove3AppLimitView.alreadyPatched)
        Text(L10n.Remove3AppLimitView.tenAppsInfo)
    }
    
    @ViewBuilder
    private var applyPatch: some View {
        Text(L10n.Remove3AppLimitView.patchInfo)
        Text(L10n.Remove3AppLimitView.tenAppsInfo)
    }
    
    var body: some View {
        VStack {
            if !MDC.isSupported {
                notSupported.common()
            } else {
                if MDC.installdHasBeenPatched {
                    installdHasBeenPatched.common()
                } else {
                    applyPatch.common()
                    SwiftUI.Button(action: {
                        Task {
                            do {
                                guard !runningPatch else { return }
                                runningPatch = true
                                
                                try await MDC.patch3AppLimit()
                                
                                showSuccessAlert = true
                            } catch {
                                errorAlertMessage = error.message()
                                showErrorAlert = true
                            }
                            runningPatch = false
                        }
                    }) { Text(L10n.Remove3AppLimitView.applyPatch) }
                    .buttonStyle(FilledButtonStyle(isLoading: runningPatch, hideLabelOnLoading: false))
                    .padding()
                }
            }
            Spacer()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(L10n.AsyncFallibleButton.error),
                message: Text(errorAlertMessage)
            )
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text(L10n.Action.success),
                message: Text(L10n.Remove3AppLimitView.success)
            )
        }
        .navigationTitle(L10n.Remove3AppLimitView.title)
        .enableInjection()
    }
}

struct Remove3AppLimitView_Previews: PreviewProvider {
    static var previews: some View {
        Remove3AppLimitView()
    }
}
#endif
