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
        let router = Router(navigationController: navigationController)
        let cordinator = AuthCoordinator(router: router)
        addChild(cordinator)
        cordinator.popLogginFlow()
    }
    
    private func gotoSignOut() {
        
    }
    
    private func gotoProfile() {
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
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
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
        viewModel.gotoConfirm = { [weak self] in
            self?.gotoCompleteCreateTradeAssociations()
        }
        
        let vc = NewTradeAssociationViewController()
        vc.viewModel = viewModel

        viewModel.selectFoundedYear = { [weak self] completion in
            modalCoordinator.goToCalendarPicker(
                mode: .year,
                min: Date.from(year: 1900)
            ) { date in
                completion(date?.yearComponent)
            }
        }
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoCompleteCreateTradeAssociations() {
        let viewModel = CompleteNewTradeAssociationViewModel()
        let vc = CompleteNewTradeAssociationViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoMyOrders() {
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
    
    private func goToNewsDetails(_ item: AssociationNewsItem) {
        let viewModel = NewsDetailsViewModel(item)
        
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
}
