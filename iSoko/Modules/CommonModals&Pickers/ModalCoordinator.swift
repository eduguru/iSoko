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
    
    public func goToCommonSelection(_ type: CommonUtilityOption, _ staticOptions: [CommonIdNameModel]? = nil, _ completion: @escaping (CommonIdNameModel?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type, options: staticOptions)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .idName(let model):
                completion(model)
            default:
                completion(nil)
            }
            
            // Pop the screen
            self?.router.pop(animated: true)
        }
        
        let vc = CommonOptionPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.push(vc, animated: true)
    }
    
    public func goToComoditySelection( _ completion: @escaping (CommodityV1Response?) -> Void) {
        let viewModel = CommodityPickerViewModel()
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .commodities(let model):
                completion(model)
            default:
                completion(nil)
            }
            
            // Pop the screen
            self?.router.pop(animated: true)
        }
        
        let vc = CommodityPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.push(vc, animated: true)
    }

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
    
    // MARK: - Generic Modal Presentation
    public func presentModal() {
        let modalVC = UIViewController()
        modalVC.view.backgroundColor = .systemPurple
        modalVC.title = "Modal Flow"
        modalVC.modalPresentationStyle = .fullScreen

        presentModal(modalVC)
    }

    private func dismiss() {
        dismissModal()
    }
}

// ModalCoordinator+DatePicker.swift
extension ModalCoordinator {

    func goToDateSelection(
        config: DatePickerConfig,
        completion: @escaping (Date?) -> Void
    ) {
        let vc = DatePickerViewController()
        vc.config = config

        vc.onComplete = { [weak self] date in
            completion(date)
            self?.dismissModal()
        }

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        router.present(nav)
    }

    func goToCalendarPicker(
        mode: CalendarPickerMode,
        min: Date? = nil,
        max: Date? = nil,
        initial: Date? = nil,
        completion: @escaping (Date?) -> Void
    ) {

        let picker = CalendarPickerFactory.makePicker()

        picker.configure(
            mode: mode,
            minDate: min,
            maxDate: max,
            initialDate: initial
        )

        picker.onConfirm = { [weak self] date in
            completion(date)
            self?.dismissModal()
        }

        picker.onCancel = { [weak self] in
            completion(nil)
            self?.dismissModal()
        }

        let nav = UINavigationController(rootViewController: picker)
        nav.modalPresentationStyle = .pageSheet
        nav.modalTransitionStyle = .coverVertical

        router.present(nav)
    }
    
    func goToAppleStyleCalendar(config: DatePickerConfig, completion: @escaping (Date?) -> Void) {
        let pickerVC = AppleStyleCalendarPickerViewController()
        pickerVC.config = config
        pickerVC.onComplete = { date in
            completion(date)
        }

        let nav = UINavigationController(rootViewController: pickerVC)

        if #available(iOS 15.0, *) {
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]   // Compact height
                sheet.prefersGrabberVisible = true
            }
        } else {
            // iOS 14 fallback: form sheet gives a compact modal on iPad
            nav.modalPresentationStyle = .formSheet
            nav.preferredContentSize = CGSize(width: 350, height: 400) // adjust height as needed
        }

        router.present(nav)
    }
    
    
    func presentSuccessAlert(
        title: String = "Successful",
        message: String = "Your action was completed successfully.",
        onPrimaryAction: (() -> Void)? = nil
    ) {

        DispatchQueue.main.async { [weak self] in
            guard let topVC = self?.router.topViewController() else { return }

            let model = BottomSheetFactory.success(
                title: title,
                message: message,
                icon: UIImage(systemName: "checkmark.circle.fill"),
            )  {
                print("OK tapped")
                onPrimaryAction?()
            }

            BottomSheetCoordinator(presenter: topVC).present(model)
        }
    }
    
    func presentErrorAlert(
        title: String = "Error",
        message: String = "Something went wrong. Please try again.",
        onPrimaryAction: (() -> Void)? = nil,
        onSecondaryAction: (() -> Void)? = nil
    ) {
        
        DispatchQueue.main.async { [weak self] in
            guard let topVC = self?.router.topViewController() else { return }

            let model = BottomSheetModel(
                style: .bottomSheet,
                icon: UIImage(systemName: "xmark.circle.fill"),
                title: title,
                message: message,
                showCloseButton: true,
                state: .error,
                buttons: [
                    .init(title: "Retry", style: .primary) {
                        print("Retry tapped")
                        onSecondaryAction?()
                    },
                    .init(title: "Close", style: .primary) {
                        print("Close tapped")
                        onPrimaryAction?()
                    }
                ]
            )
            
            BottomSheetCoordinator(presenter: topVC).present(model)
        }
        
    }
}
