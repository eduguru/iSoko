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
    
    override func start() {
        gotoTradeAssociations()
    }
    
    private func gotoTradeAssociations() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = TradeAssociationListingsViewModel()
        viewModel.goToMoreDetails = { [weak self] in
            self?.gotoTradeAssociationDetails($0)
        }
        
        viewModel.goToButtonAction = showConfirmationBottomSheet
        
        let vc = TradeAssociationListingsViewController()
        vc.viewModel = viewModel
        
        vc.goToCreateAction = { [weak self] in
            self?.gotoCreateTradeAssociations()
        }
        
        vc.closeAction = { [weak self] in
            self?.router.dismiss(animated: true)
            // self?.router.pop(animated: true)
        }
        
        // Wrap dashboard in a navigation controller
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        // Present from the topmost view controller in the main flow
        if let top = router.topViewController() {
            top.present(nav, animated: true)
            
            // Update router so internal pushes go to this modal nav
            self.router = Router(navigationController: nav)
        }
    }

    private func gotoTradeAssociationDetails(_ data: AssociationResponse) {
        let viewModel = TradeAssociationDetailsViewModel(data)
        viewModel.goToNewsDetails = goToNewsDetails
        
        let vc = TradeAssociationDetailsViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoCreateTradeAssociations() {
        let modalCoordinator = ModalCoordinator(router: router)  // coordinator.delegate = self
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
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
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
}
