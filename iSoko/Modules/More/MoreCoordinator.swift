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
        model.goToLanguageSelection = goToLanguageSelection
        model.gotoTradeAssociations = gotoTradeAssociations
        model.gotoMyOrders = gotoMyOrders
        model.gotoShareApp = gotoShareApp
        // model.gotoLegal = gotoLegal
        model.gotoSettings = gotoSettings
        model.gotoHelpFeedback = gotoHelpFeedback
        
        model.showAuthSheet = { [weak self] in
            self?.presentAuthBottomSheet()
        }
        
        let controller = MoreViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        
        return controller
    }
    
    public override func start() {
        // router.push(primaryViewController())
        router.setRoot(primaryViewController())
    }
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
    
    
    private func gotoSignIn() {
        presentAuthBottomSheet() // showLoginFlow()
    }
    
    private func gotoSignOut(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let topVC = self?.router.topViewController() else { return }
            
            // Create the sign-out bottom sheet
            let model = BottomSheetFactory.signOut(
                onConfirm: {  // Perform the sign-out action, e.g., clear user data, log out
                    completion(true)
                    print("User has signed out")
                },
                onCancel: {  // Handle cancellation, e.g., dismiss the bottom sheet
                    completion(false)
                    print("Sign out cancelled")
                }
            )
            
            // Present the bottom sheet
            BottomSheetCoordinator(presenter: topVC).present(model)
        }
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
    
    private func gotoProfile() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
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
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = ProfileEditViewModel()
        viewModel.goToCommonSelectionOptions = goToCommonSelection
        
        let vc = ProfileEditViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToCommonSelection(_ type: CommonUtilityOption, _ staticOptions: [CommonIdNameModel]? = nil, _ completion: @escaping (CommonIdNameModel?) -> Void) {
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
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoOrganisations() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
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
            presentAuthBottomSheet()
            return
        }

        // Use existing router instead of creating a new one
        let coordinator = TradeAssociationFlowCoordinator(router: router)
        addChild(coordinator)
        coordinator.start()
    }

    private func gotoHelpFeedback() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }

        // Use existing router
        let coordinator = HelpFeedbackCoordinator(router: router)
        addChild(coordinator)
        coordinator.start()
    }
    
    @MainActor
    private func gotoMyOrders() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = MyOrdersViewModel()
        viewModel.goToDetails = goToOrderDetails
        
        let vc = MyOrdersViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    func goToOrderDetails(_ item: CustomerOrderResponse) {
        let model = MyOrderDetailsViewModel(item)
        
        let vc = MyOrderDetailsViewController()
        
        // model.goToEdit = { }
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    private func gotoShareApp() {
        let viewModel = ShareAppViewModel()
        
        viewModel.onShareRequested = { [weak self] items in
            guard let self = self else { return }
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.router.present(activityVC, animated: true)
        }
        
        let vc = ShareAppViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            // Dismiss the modal nav instead of popping
            self?.router.dismiss(animated: true)
        }
        
        // Wrap in its own navigation controller
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = false
        
        // Present modally
        router.present(nav, animated: true)
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
        let viewModel = NotificationsViewModel()
        
        let vc = NotificationsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    // MARK: - Language Selection
    @MainActor
    public func goToLanguageSelection(completion: @escaping (Language) -> Void) {
        let model = LanguagePickerViewModel()
        model.confirmSelection = { [weak self] language in
            completion(language)
            self?.dismissModal() // dismiss instead of finish
        }

        let vc = LanguagePickerViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.dismissModal()
        }

        // Wrap in its own navigation controller for modal flow
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen

        // Present using BaseCoordinator helper
        presentModal(nav)
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
