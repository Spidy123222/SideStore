//
//  ActivityView.swift
//  SideStore
//
//  Created by Fabian Thies on 19.05.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import UIKit


struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}
