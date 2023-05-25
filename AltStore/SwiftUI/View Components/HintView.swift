//
//  HintView.swift
//  SideStore
//
//  Created by Fabian Thies on 15.01.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI

struct HintView<Content: View>: View {

    var backgroundColor: Color = Color(.tertiarySystemBackground)

    @ViewBuilder
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            self.content()
        }
        .padding()
        .background(self.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct HintView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.secondarySystemBackground).edgesIgnoringSafeArea(.all)

            HintView {
                Text("Hint Title")
                    .bold()

                Text("This hint view can be used to tell the user something about how SideStore works.")
                    .foregroundColor(.secondary)
            }
        }
    }
}
