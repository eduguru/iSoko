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
            title: "auth.login_required.title".localized,
            message: "auth.login_required.message".localized,
            showCloseButton: true,
            buttons: [
                .init(
                    title: "auth.continue_as_guest".localized,
                    style: .secondary
                ) {
                    onGuest()
                },
                .init(
                    title: "auth.login".localized,
                    style: .primary
                ) {
                    onLogin()
                }
            ]
        )
        
        BottomSheetCoordinator(presenter: viewController).present(model)
    }
}
