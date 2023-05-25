//
//  PillButtonProgressViewStyle.swift
//  SideStore
//
//  Created by Fabian Thies on 22.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI

struct PillButtonProgressViewStyle: ProgressViewStyle {
    let tint: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            Capsule(style: .continuous)
                .foregroundColor(tint.opacity(0.15))
            
            GeometryReader { proxy in
                Capsule(style: .continuous)
//                    .frame(width: proxy.size.width * (configuration.fractionCompleted ?? 0.0))
                    .foregroundColor(tint)
                    .offset(x: -proxy.size.width * (1 - (configuration.fractionCompleted ?? 1)))
            }
        }
        .animation(.easeInOut(duration: 0.2))
    }
}
