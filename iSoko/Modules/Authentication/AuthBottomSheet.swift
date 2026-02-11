//
//  AuthBottomSheet.swift
//  
//
//  Created by Edwin Weru on 11/02/2026.
//

import UIKit

final class PendingActionManager {
    static let shared = PendingActionManager()
    private init() {}

    private var pendingAction: (() -> Void)?

    func set(_ action: @escaping () -> Void) {
        pendingAction = action
    }

    func execute() {
        pendingAction?()
        pendingAction = nil
    }

    func clear() {
        pendingAction = nil
    }
}

@MainActor
enum AuthBottomSheet {

    static func present(
        from viewController: UIViewController,
        onLogin: @escaping () -> Void,
        onGuest: @escaping () -> Void
    ) {
        let sheet = UIAlertController(
            title: "Login required",
            message: "Please login to continue, or continue as guest.",
            preferredStyle: .actionSheet
        )

        sheet.addAction(.init(title: "Cancel", style: .cancel))

        sheet.addAction(.init(title: "Continue as Guest", style: .default) { _ in
            onGuest()
        })

        sheet.addAction(.init(title: "Login", style: .default) { _ in
            onLogin()
        })

        if let pop = sheet.popoverPresentationController {
            pop.sourceView = viewController.view
            pop.sourceRect = CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 0,
                height: 0
            )
            pop.permittedArrowDirections = []
        }

        viewController.present(sheet, animated: true)
    }
}
