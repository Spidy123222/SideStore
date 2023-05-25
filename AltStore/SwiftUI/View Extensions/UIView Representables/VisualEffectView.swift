//
//  VisualEffectView.swift
//  SideStore
//
//  Created by Fabian Thies on 01.12.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}


extension View {
    @ViewBuilder
    func blurBackground(_ style: UIBlurEffect.Style) -> some View {
        self
            .background(VisualEffectView(blurStyle: style))
    }
}
