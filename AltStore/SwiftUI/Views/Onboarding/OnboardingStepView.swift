//
//  OnboardingStepView.swift
//  SideStore
//
//  Created by Fabian Thies on 25.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI


struct OnboardingStepView<Title: View, Hero: View, Content: View, Action: View>: View {
    @ViewBuilder
    var title: Title

    @ViewBuilder
    var hero: Hero

    @ViewBuilder
    var content: Content

    @ViewBuilder
    var action: Action

    var body: some View {
        VStack(spacing: 64) {
            self.title
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            self.hero
                .frame(height: 150)

            self.content
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            self.action
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct OnboardingStepView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStepView(title: {
            VStack(alignment: .leading) {
                Text("Welcome to")
                Text("SideStore")
                    .foregroundColor(.accentColor)
            }
        }, hero: {
            AppIconsShowcase()
        }, content: {
            VStack(spacing: 16) {
                Text("Before you can start sideloading apps, there is some setup to do.")
                Text("The following setup will guide you through the steps one by one.")
                Text("You will need a computer (Windows, macOS, Linux) and your Apple ID.")
            }
        }, action: {
            SwiftUI.Button("Continue") {

            }
            .buttonStyle(FilledButtonStyle())
        })
    }
}

