//
//  BottomSheetFactory.swift
//  
//
//  Created by Edwin Weru on 22/05/2026.
//

import UIKit


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

    static func signOut(
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> BottomSheetModel {
        BottomSheetModel(
            style: .bottomSheet,
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            showCloseButton: true,
            buttons: [
                .init(title: "Cancel", style: .secondary) { onCancel() },
                .init(title: "Sign Out", style: .primary) { onConfirm() }
            ]
        )
    }

    static func success(
        title: String,
        message: String?,
        icon: UIImage? = UIImage(systemName: "checkmark.circle.fill"),
        buttonTitle: String = "Okay",
        onTap: @escaping () -> Void
    ) -> BottomSheetModel {
        BottomSheetModel(
            style: .bottomSheet,
            icon: icon,
            title: title,
            message: message,
            showCloseButton: false,
            state: .success,
            buttons: [
                .init(title: buttonTitle, style: .primary, action: onTap)
            ]
        )
    }

    static func confirmation(
        title: String,
        message: String?,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> BottomSheetModel {
        BottomSheetModel(
            style: .bottomSheet,
            title: title,
            message: message ?? "",
            showCloseButton: true,
            buttons: [
                .init(title: "Cancel", style: .secondary) { onCancel() },
                .init(title: "Okay", style: .primary) { onConfirm() }
            ]
        )
    }

    // MARK: - New: Radio List Example

    static func selectOption(
        title: String,
        message: String?,
        options: [BottomSheetModel.BottomSheetItem],
        onSelect: @escaping (BottomSheetModel.BottomSheetItem) -> Void
    ) -> BottomSheetModel {
        BottomSheetModel(
            style: .bottomSheet,
            title: title,
            message: message,
            showCloseButton: true,
            buttons: [
                .init(title: "Done", style: .primary) { }
            ], items: options,
            onItemSelected: onSelect
        )
    }
}

//Here’s how you actually use your updated bottom sheet system with the success state.
//
//✅ 1. Auth sheet
//
//You don’t need to touch anything here:
//
//AuthBottomSheet.present(
//    from: self,
//    onLogin: {
//        print("Login tapped")
//    },
//    onGuest: {
//        print("Guest tapped")
//    }
//)
//✅ 2. Success sheet (NEW usage)
//
//Now you can show success like this:
//
//let model = BottomSheetFactory.success(
//    title: "Payment Successful",
//    message: "Your order has been placed successfully.",
//    icon: UIImage(systemName: "checkmark.circle.fill")
//) {
//    print("OK tapped")
//}
//
//BottomSheetCoordinator(presenter: self).present(model)

//💡 3. Inline usage (no factory)
//
//If you want to build it directly:
//
//let model = BottomSheetModel(
//    style: .bottomSheet,
//    icon: UIImage(systemName: "checkmark.circle.fill"),
//    title: "Success",
//    message: "Operation completed successfully.",
//    showCloseButton: false,
//    state: .success,
//    buttons: [
//        .init(title: "OK", style: .primary) {
//            print("Dismissed")
//        }
//    ]
//)
//
//BottomSheetCoordinator(presenter: self).present(model)
//🎯 4. Error example (now supported cleanly)
//let model = BottomSheetModel(
//    style: .bottomSheet,
//    icon: UIImage(systemName: "xmark.circle.fill"),
//    title: "Error",
//    message: "Something went wrong. Please try again.",
//    showCloseButton: true,
//    state: .error,
//    buttons: [
//        .init(title: "Retry", style: .primary) {
//            print("Retry tapped")
//        }
//    ]
//)
//
//BottomSheetCoordinator(presenter: self).present(model)
