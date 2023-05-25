//
//  ObservableScrollView.swift
//  SideStore
//
//  Created by Fabian Thies on 20.11.22.
//  Copyright © 2022 Fabian Thies. All rights reserved.
//

import SwiftUI

struct ObservableScrollView<Content: View>: View {
    @Namespace var scrollViewNamespace
    
    @Binding var scrollOffset: CGFloat
    
    let content: (ScrollViewProxy) -> Content
    
    init(scrollOffset: Binding<CGFloat>, @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
        self._scrollOffset = scrollOffset
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                content(proxy)
                    .background(GeometryReader { geoReader in
                        let offset = -geoReader.frame(in: .named(scrollViewNamespace)).minY
                        Color.clear
                            .preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    })
            }
        }
        .coordinateSpace(name: scrollViewNamespace)
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
