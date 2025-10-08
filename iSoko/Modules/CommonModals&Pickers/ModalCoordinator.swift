//
//  ModalCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 29/07/2025.
//

import RouterKit
import UtilsKit
import UIKit

public class ModalCoordinator: BaseCoordinator {
    
    public override func start() { }

    // MARK: - Country Selection

    public func goToCountrySelection(completion: @escaping (Country) -> Void) {
        let model = CountryPickerViewModel()
        model.confirmSelection = { [weak self] country in
            completion(country)
        }

        let vc = CountryPickerViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }

        router.push(vc)
    }

    // MARK: - Language Selection

    public func goToLanguageSelection(completion: @escaping (Language) -> Void) {
        let model = LanguagePickerViewModel()
        model.confirmSelection = { [weak self] language in
            completion(language)
        }

        let vc = LanguagePickerViewController()
        vc.makeRoot = true
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }

        router.push(vc)
    }

    // MARK: - Generic Modal Presentation

    public func presentModal() {
        let modalVC = UIViewController()
        modalVC.view.backgroundColor = .systemPurple
        modalVC.title = "Modal Flow"
        modalVC.modalPresentationStyle = .fullScreen

        presentModal(modalVC)
    }

    public func dismiss() {
        dismissModal()
    }

    public func goToOtpVerification( type: OTPVerificationType, onSuccess: (() -> Void)? = nil ) {
        let viewModel = OTPFormViewModel(type: type)

        viewModel.gotoConfirm = { [weak self] in
            onSuccess?()
            self?.router.pop(animated: true)
        }

        viewModel.onResendCode = {
            print("🔁 Resend requested for \(type.targetValue)")
        }

        viewModel.onOTPComplete = { otp in
            print("✅ OTP entered: \(otp)")
            // Optional: add server validation logic here
        }

        let vc = OTPFormViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
}
