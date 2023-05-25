//
//  PillButtonStyle.swift
//  SideStore
//
//  Created by Fabian Thies on 18.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI

struct PillButtonStyle: ButtonStyle {
    
    let tintColor: UIColor
    var progress: Progress?
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if progress == nil {
                configuration.label
                    .opacity(configuration.isPressed ? 0.4 : 1.0)
            } else {
                ProgressView()
                    .progressViewStyle(DefaultProgressViewStyle())
            }
        }
        .frame(minWidth: 40)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(background)
        .foregroundColor(self.progress == nil ? .white : Color(tintColor))
        .clipShape(Capsule())
    }
    
    var background: some View {
        ZStack {
            if let progress {
                Color(tintColor).opacity(0.15)

                ProgressView(progress)
                    .progressViewStyle(PillButtonProgressViewStyle(tint: Color(tintColor)))
            } else {
                Color(tintColor)
            }
        }
    }
}


struct PillButtonStyle_Previews: PreviewProvider {

    static var previews: some View {
        SwiftUI.Button {

        } label: {
            Text("Label").bold()
        }
        .buttonStyle(PillButtonStyle(tintColor: Asset.accentColor.color))
    }
}
