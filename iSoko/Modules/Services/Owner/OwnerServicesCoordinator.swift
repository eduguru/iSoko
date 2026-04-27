//
//  OwnerServicesCoordinator.swift
//  
//
//  Created by Edwin Weru on 27/04/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit
import StorageKit

public class OwnerServicesCoordinator: BaseCoordinator {
    
    public override func start() {
        goToMyServices()
    }
    
    // MARK: -
    private func goToMyServices() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = MyServicesListingViewModel()
        viewModel.goToDetails = goToMyServiceDetails
        
        let vc = MyServicesListingViewController()
        vc.viewModel = viewModel
        
        vc.goToCreateAction = { [weak self] in
            self?.gotoCreateService()
        }
        
        vc.closeAction = { [weak self] in
            // self?.router.pop(animated: true)
            self?.finish()
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
    
    private func goToMyServiceDetails(_ item: StockResponse) {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = MyProductDetailsViewModel(item)
        let vc = ProductDetailsViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.push(vc, animated: true)
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
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}

extension OwnerServicesCoordinator {
    private func gotoCreateService() {
        
    }
    
    private func goToCommonSelection(_ type: CommonUtilityOption, _ staticOptions: [CommonIdNameModel]? = nil, _ completion: @escaping (CommonIdNameModel?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToCommonSelection(type, staticOptions) { [weak self] result in
            completion(result)
        }
    }
    
    private func goToComoditySelection(_ completion: @escaping (CommodityV1Response?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToComoditySelection() { [weak self] result in
            completion(result)
        }
    }
    
    private func gotoSelectSystemCountry(_ type: CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) {
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
    
    private func gotoSelectCountry(completion: @escaping (Country) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToCountrySelection { [weak self] result in
            completion(result)
            self?.router.pop()
        }
    }
    
    private func gotoSelectDate(config: DatePickerConfig,completion: @escaping (Date?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToAppleStyleCalendar(config: config) { [weak self] result in
            completion(result)
        }
    }
}
