//
//  MoreCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit
import StorageKit

public class MoreCoordinator: BaseCoordinator {
    
    func primaryViewController() -> MoreViewController {
        let model = MoreViewModel()
        model.gotoSignIn = gotoSignIn
        model.gotoSignOut = gotoSignOut
        model.gotoProfile = gotoProfile
        model.gotoOrganisations = gotoOrganisations
        model.gotoTradeAssociations = gotoTradeAssociations
        model.gotoMyOrders = gotoMyOrders
        model.gotoShareApp = gotoShareApp
        model.gotoLegal = gotoLegal
        model.gotoSettings = gotoSettings
        model.gotoHelpFeedback = gotoHelpFeedback
        
        let controller = MoreViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        
        return controller
    }
    
    public override func start() {
        router.push(primaryViewController())
        // navigationController?.pushViewController(primaryViewController(), animated: true)
    }
    
    
    public func dismiss() {
        dismissModal()
    }
    
    
    private func gotoSignIn() {
        showLoginFlow()
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
    
    private func gotoSignOut() {
        
    }
    
    private func gotoProfile() {
        guard AppStorage.hasLoggedIn == true else {
            // PendingActionManager.shared.set { [weak self] in self?.showProfile() }
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
            return
        }
        
        let viewModel = ProfileInfoViewModel()
        let vc = ProfileInfoViewController()
        vc.viewModel = viewModel
        
        vc.goToEditAction = { [weak self] in
            self?.goToEditProfile()
        }
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToEditProfile() {
        guard AppStorage.hasLoggedIn == true else {
            // PendingActionManager.shared.set { [weak self] in self?.showProfile() }
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
            return
        }
        
        let viewModel = ProfileEditViewModel()
        
        let vc = ProfileEditViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoOrganisations() {
        guard AppStorage.hasLoggedIn == true else {
            // PendingActionManager.shared.set { [weak self] in self?.showProfile() }
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
            return
        }
        
        let viewModel = OrganisationListingsViewModel()
        
        let vc = OrganisationListingsViewController()
        vc.viewModel = viewModel
        
        vc.goToCreateAction = { [weak self] in }
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoTradeAssociations() {
        guard AppStorage.hasLoggedIn == true else {
            // PendingActionManager.shared.set { [weak self] in self?.showProfile() }
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
            return
        }
        
        guard let presentingVC = navigationController?.tabBarController else { return }
        
        let flow = TradeAssociationFlowCoordinator(presentingVC: presentingVC)
        addChild(flow)
        
        let nav = flow.rootNavigationController
        nav.modalPresentationStyle = .fullScreen
        
        presentingVC.present(nav, animated: true) {
            flow.start()
        }
    }
    
    @MainActor
    private func gotoMyOrders() {
        guard AppStorage.hasLoggedIn == true else {
            // PendingActionManager.shared.set { [weak self] in self?.showProfile() }
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
            return
        }
        
        let viewModel = MyOrdersViewModel()
        
        let vc = MyOrdersViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoShareApp() {
        let viewModel = ShareAppViewModel()
        
        let vc = ShareAppViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoLegal() {
        let viewModel = LegalViewModel()
        
        let vc = LegalViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoSettings() {
        let viewModel = SettingsViewModel()
        
        let vc = SettingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoHelpFeedback() {
        let viewModel = HelpFeedbackViewModel()
        
        let vc = HelpFeedbackViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
}
