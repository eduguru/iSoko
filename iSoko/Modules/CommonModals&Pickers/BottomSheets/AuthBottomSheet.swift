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




//AuthBottomSheet.present(
//    from: self,
//    onLogin: { print("Login tapped") },
//    onGuest: { print("Guest tapped") }
//)
//
//let model = BottomSheetModel(
//    style: .bottomSheet,
//    title: "One Button",
//    message: "Only one action available",
//    showCloseButton: true,
//    buttons: [
//        .init(title: "Continue", style: .primary, isFullWidth: true) {
//            print("Continue tapped")
//        }
//    ]
//)
//
//BottomSheetCoordinator(presenter: self).present(model)
//
//
//let model = BottomSheetModel(
//    style: .bottomSheet,
//    title: "Choose Action",
//    message: "Select one option",
//    showCloseButton: false,
//    buttons: [
//        .init(title: "Option 1", style: .secondary) { print("Option 1") },
//        .init(title: "Option 2", style: .primary) { print("Option 2") }
//    ]
//)
//
//BottomSheetCoordinator(presenter: self).present(model)


//AuthBottomSheet.present(
//    from: self,
//    style: .floating,
//    onLogin: { print("Login tapped") },
//    onGuest: { print("Guest tapped") }
//)
//
//AuthBottomSheet.present(
//    from: self,
//    style: .bottomSheet,
//    onLogin: { print("Login tapped") },
//    onGuest: { print("Guest tapped") }
//)
