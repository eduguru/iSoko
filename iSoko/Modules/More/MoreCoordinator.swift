//
//  MoreCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UtilsKit
import UIKit

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
        
    }
    
    private func gotoSignOut() {
        
    }
    
    private func gotoProfile() {
        let viewModel = ResetPasswordViewModel()
        
        let vc = ResetPasswordViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoOrganisations() {
        let viewModel = OrganisationListingsViewModel()
        
        let vc = OrganisationListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoTradeAssociations() {
        let viewModel = TradeAssociationListingsViewModel()
        
        let vc = TradeAssociationListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoMyOrders() {
        let viewModel = MyOrdersViewModel()
        
        let vc = MyOrdersViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoShareApp() {
        let viewModel = ShareAppViewModel()
        
        let vc = ShareAppViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoLegal() {
        let viewModel = LegalViewModel()
        
        let vc = LegalViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoSettings() {
        let viewModel = SettingsViewModel()
        
        let vc = SettingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoHelpFeedback() {
        let viewModel = HelpFeedbackViewModel()
        
        let vc = HelpFeedbackViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
}
