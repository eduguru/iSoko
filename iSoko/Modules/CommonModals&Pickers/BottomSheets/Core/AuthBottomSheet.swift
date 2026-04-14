//
//  AuthBottomSheet.swift
//  
//
//  Created by Edwin Weru on 11/02/2026.
//

import UIKit

@MainActor
enum AuthBottomSheet {

    static func present(
        from viewController: UIViewController,
        style: BottomSheetModel.Style = .bottomSheet,
        onLogin: @escaping () -> Void,
        onGuest: @escaping () -> Void
    ) {
        let model = BottomSheetModel(
            style: style,
            title: "Login required",
            message: "Please login to continue, or continue as guest.",
            showCloseButton: true,
            buttons: [
                .init(title: "Continue as Guest", style: .secondary) { onGuest() },
                .init(title: "Login", style: .primary) { onLogin() }
            ]
        )

        BottomSheetCoordinator(presenter: viewController).present(model)
    }
}

enum BottomSheetFactory {
    
    static func auth(
        onLogin: @escaping () -> Void,
        onGuest: @escaping () -> Void
    ) -> BottomSheetModel {
        
        BottomSheetModel(
            style: .bottomSheet,
            title: "Login required",
            message: "Please login to continue, or continue as guest.",
            showCloseButton: true,
            buttons: [
                .init(title: "Continue as Guest", style: .secondary) { onGuest() },
                .init(title: "Login", style: .primary) { onLogin() }
            ]
        )
    }
}
