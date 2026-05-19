//
//  TradeAssociationCoordinator.swift
//
//
//  Created by Edwin Weru on 09/02/2026.
//

import RouterKit
import UIKit
import StorageKit

@MainActor
final class TradeAssociationFlowCoordinator: BaseCoordinator {

    // Track if the main modal is already shown
    private var isModalPresented = false

    override func start() {
        gotoTradeAssociations()
    }

    private func gotoTradeAssociations() {
        guard AppStorage.hasLoggedIn ?? false else {
            presentAuthBottomSheet()
            return
        }

        // Avoid presenting again if already presented
        guard !isModalPresented else { return }

        let viewModel = TradeAssociationListingsViewModel()
        viewModel.goToMoreDetails = { [weak self] in
            self?.gotoTradeAssociationDetails($0)
        }

        viewModel.goToButtonAction = { [weak self] actionTitle, item, completion in
            guard let self else { return }

            let message = "Are you sure you want to \(actionTitle.lowercased()) \(item.name ?? "")?"

            self.presentConfirmaionAlert(
                title: actionTitle,
                message: message,
                onConfirm: { completion(true) },
                onCancel: { completion(false) }
            )
        }

        let vc = TradeAssociationListingsViewController()
        vc.viewModel = viewModel

        vc.goToCreateAction = { [weak self] in
            self?.gotoCreateTradeAssociations()
        }

        vc.closeAction = { [weak self] in
            self?.router.dismiss(animated: true)
            self?.isModalPresented = false
        }

        // Present modally using BaseCoordinator helper
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen

        isModalPresented = true
        presentModal(nav)
    }

    private func gotoTradeAssociationDetails(_ data: AssociationResponse) {
        let viewModel = TradeAssociationDetailsViewModel(data)
        viewModel.goToNewsDetails = goToNewsDetails

        let vc = TradeAssociationDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }

    private func gotoCreateTradeAssociations() {
        let modalCoordinator = ModalCoordinator(router: router)
        addChild(modalCoordinator)

        let viewModel = NewTradeAssociationViewModel()
        viewModel.goToDateSelection = gotoSelectDate
        viewModel.gotoSelectSystemCountry = gotoSelectSystemCountry
        viewModel.onStep1Complete = gotoCompleteCreateTradeAssociations

        let vc = NewTradeAssociationViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.push(vc, animated: true)
        router.navigationControllerInstance?.navigationBar.isHidden = false
    }
    
    private func gotoCompleteCreateTradeAssociations(_ data: [String: Any]) {
        let viewModel = CompleteNewTradeAssociationViewModel(data)
        let vc = CompleteNewTradeAssociationViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    func gotoSelectDate(config: DatePickerConfig,completion: @escaping (Date?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToAppleStyleCalendar(config: config) { [weak self] result in
            completion(result)
        }
    }
    
    func gotoSelectSystemCountry(_ type: CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .countries(let response):
                let model = response
                completion(model)
            default:
                completion(nil)
            }
            
            self?.router.pop(animated: true)
        }
        
        let vc = CommonOptionPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToNewsDetails(_ item: AssociationNewsItem) {
        let viewModel = NewsDetailsViewModel(item.toDomain())
        
        let vc = NewsDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func showConfirmationBottomSheet(title: String, message: String,completion: @escaping (Bool) -> Void) {
        
    }
    
    private func dismiss() {
        dismissModal()
    }
    
    private func showLoginFlow() {
        AppStorage.hasShownInitialLoginOptions = false
        
        let nav = BaseNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = AuthCoordinator(router: router)
        
        addChild(coordinator)
        coordinator.start()
        
        nav.modalPresentationStyle = .fullScreen
        self.router.present(nav, animated: true)
    }
    
    private func presentAuthBottomSheet() {
        guard let topVC = router.topViewController() else { return }
        
        AuthBottomSheet.present(
            from: topVC,
            onLogin: { [weak self] in
                self?.showLoginFlow()
            },
            onGuest: {
                RuntimeSession.authState = .guest
                AppStorage.hasLoggedIn = false
            }
        )
    }
    
    func goToShowSuccessScreen() {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.presentSuccessAlert() { [weak self] in
            self?.router.pop()
        }
    }
    
    func goToShowErrorScreen() {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.presentErrorAlert(
            onPrimaryAction:  { [weak self] in
                self?.router.pop()
            },
            onSecondaryAction:  { [weak self] in
                self?.router.pop()
            }
        )
    }
    
    func presentConfirmaionAlert(title: String, message: String?, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.presentConfirmationBottomSheet(title: title, message: message, onConfirm: { [weak self] in
            onConfirm()
        }, onCancel: { [weak self] in
            onCancel()
        })
            
    }
}
