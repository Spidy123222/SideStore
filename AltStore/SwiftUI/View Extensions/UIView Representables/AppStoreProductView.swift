//
//  AppStoreProductView.swift
//  SideStore
//
//  Created by Fabian Thies on 25.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import StoreKit


struct AppStoreView: UIViewControllerRepresentable {
    typealias UIViewControllerType = AppStoreProductViewController

    var isVisible: Binding<Bool>
    let itunesItemId: Int

    func makeUIViewController(context: Context) -> AppStoreProductViewController {
        AppStoreProductViewController(isVisible: self.isVisible, itunesId: self.itunesItemId)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if self.isVisible.wrappedValue {
            uiViewController.presentStoreProduct()
        }
    }
}


class AppStoreProductViewController: UIViewController {

    private var isVisible: Binding<Bool>
    private let itunesId: Int

    init(isVisible: Binding<Bool>, itunesId: Int) {
        self.isVisible = isVisible
        self.itunesId = itunesId

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func presentStoreProduct() {
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = self

        let parameters = [SKStoreProductParameterITunesItemIdentifier: self.itunesId]
        storeProductViewController.loadProduct(withParameters: parameters) { (success, error) -> Void in
            if let error = error {
                print("Failed to load App Store product: \(error.localizedDescription)")
            }
            guard success else {
                return
            }

            self.present(storeProductViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - SKStoreProductViewControllerDelegate

extension AppStoreProductViewController: SKStoreProductViewControllerDelegate {

    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        DispatchQueue.main.async {
            self.isVisible.wrappedValue = false
        }
//        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
