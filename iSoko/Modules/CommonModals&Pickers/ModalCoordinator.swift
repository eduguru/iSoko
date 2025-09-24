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
            self?.router.pop()
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
            self?.router.pop()
        }

        let vc = LanguagePickerViewController()
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
}
