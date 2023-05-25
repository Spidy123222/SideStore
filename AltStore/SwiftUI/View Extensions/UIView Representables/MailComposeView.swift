//
//  MailComposeView.swift
//  SideStore
//
//  Created by Fabian Thies on 04.02.23.
//  Copyright © 2023 SideStore. All rights reserved.
//

import SwiftUI
import MessageUI

struct MailComposeView: UIViewControllerRepresentable {
    typealias ActionHandler = () -> Void
    typealias ErrorHandler = (Error) -> Void

    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }

    let recipients: [String]
    let subject: String
    var body: String? = nil

    var onMailSent: ActionHandler? = nil
    var onError: ErrorHandler? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(mailSentHandler: self.onMailSent, errorHandler: self.onError)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = context.coordinator
        mailViewController.setToRecipients(self.recipients)
        mailViewController.setSubject(self.subject)

        if let body {
            mailViewController.setMessageBody(body, isHTML: false)
        }

        return mailViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

extension MailComposeView {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        let mailSentHandler: ActionHandler?
        let errorHandler: ErrorHandler?

        init(mailSentHandler: ActionHandler?, errorHandler: ErrorHandler?) {
            self.mailSentHandler = mailSentHandler
            self.errorHandler = errorHandler
            super.init()
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if result == .sent, let mailSentHandler {
                mailSentHandler()
            } else if result == .failed, let errorHandler, let error {
                errorHandler(error)
            }

            controller.dismiss(animated: true)
        }
    }
}
