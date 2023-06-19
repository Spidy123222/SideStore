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
    var hideLabelOnLoading: Bool = true
    var tintColor: Color = .accentColor
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if !isLoading || !hideLabelOnLoading {
                configuration.label
            }
            
            if isLoading {
                // We want to add padding to the left if we don't hide the label
                if hideLabelOnLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding([.leading], 2)
                }
            }
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(tintColor)
        )
        .opacity(configuration.isPressed || isLoading ? 0.7 : 1)
        .disabled(isLoading)
        .enableInjection()
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
