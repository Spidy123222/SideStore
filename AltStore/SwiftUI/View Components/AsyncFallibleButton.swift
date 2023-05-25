//
//  AsyncFallibleButton.swift
//  SideStore
//
//  Created by naturecodevoid on 2/18/23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI

private enum AsyncFallibleButtonState {
    case none
    case loading
    case success
    case error
}

struct AsyncFallibleButton<Label: View>: View {
    @ObservedObject private var iO = Inject.observer
    
    let action: () throws -> Void
    let label: (_ execute: @escaping () -> Void) -> Label
    
    var afterFinish: (_ success: Bool) -> Void = { success in } // runs after the checkmark/X has disappeared
    var wrapInButton = true
    var secondsToDisplayResultIcon: Double = 3
    
    @State private var state: AsyncFallibleButtonState = .none
    @State private var showErrorAlert = false
    @State private var errorAlertMessage = ""
    
    private var inside: some View {
        HStack {
            label(execute)
            if state != .none {
                if wrapInButton {
                    Spacer()
                }
                switch (state) {
                case .loading:
                    ProgressView()
                case .success:
                    Image(systemSymbol: .checkmark)
                        .foregroundColor(Color.green)
                case .error:
                    Image(systemSymbol: .xmark)
                        .foregroundColor(Color.red)
                default:
                    Image(systemSymbol: .questionmark)
                        .foregroundColor(Color.yellow)
                }
            }
        }
    }
    
    private var wrapped: some View {
        if wrapInButton {
            return AnyView(SwiftUI.Button(action: {
                execute()
            }) {
                inside
            })
        } else {
            return AnyView(inside)
        }
    }
    
    var body: some View {
        wrapped
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text(L10n.AsyncFallibleButton.error),
                    message: Text(errorAlertMessage)
                )
            }
            .disabled(state != .none)
            .animation(.default, value: state)
            .enableInjection()
    }
    
    func execute() {
        if state != .none { return }
        state = .loading
        DispatchQueue.global().async {
            do {
                try action()
                DispatchQueue.main.async { state = .success }
            } catch {
                DispatchQueue.main.async {
                    state = .error
                    errorAlertMessage = (error as? LocalizedError)?.failureReason ?? error.localizedDescription
                    showErrorAlert = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDisplayResultIcon) {
                let lastState = state
                state = .none
                afterFinish(lastState == .success)
            }
        }
    }
}

struct AsyncFallibleButton_Previews: PreviewProvider {
    static var previews: some View {
        AsyncFallibleButton(action: {
            print("Start")
            for index in 0...5000000 {
                _ = index + index
            }
            throw NSError(domain: "TestError", code: -1)
            //print("Finish")
        }) { execute in
            Text("Hello World")
        }
    }
}
