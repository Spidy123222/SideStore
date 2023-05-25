//
//  FilledButtonStyle.swift
//  SideStore
//
//  Created by Fabian Thies on 29.11.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    var isLoading: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .opacity(isLoading ? 0 : 1)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.accentColor)
        )
        .opacity(configuration.isPressed || isLoading ? 0.7 : 1)
        .disabled(isLoading)
    }
}

struct FilledButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI.Button {
            
        } label: {
            Label("Test Button", systemImage: "testtube.2")
                .buttonStyle(FilledButtonStyle())
        }

    }
}
