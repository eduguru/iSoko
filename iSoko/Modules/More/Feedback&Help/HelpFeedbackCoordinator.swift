//
//  HelpFeedbackCoordinator.swift
//  
//
//  Created by Edwin Weru on 13/05/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit

public class HelpFeedbackCoordinator: BaseCoordinator {
    
    public override func start() {
        goToMainDashboard()
    }
    
    // MARK: -
    public func goToMainDashboard() {
        let viewModel = HelpFeedbackViewModel()
        
        viewModel.gotoContactUs = gotoContactUs
        viewModel.gotoAboutUs = gotoAboutUs
        viewModel.gotoFAQs = gotoFAQs
        viewModel.gotoPrivacyacyPolicy = gotoPrivacyacyPolicy
        viewModel.gotoTermsAndConditions = gotoTermsAndConditions
        
        let vc = HelpFeedbackViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
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
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}


public extension HelpFeedbackCoordinator {
    
    private func gotoContactUs() {
        let viewModel = ContactUsViewModel()
        
        let vc = ContactUsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoAboutUs() {
        let viewModel = AboutUsViewModel()
        
        let vc = AboutUsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoFAQs() {
        let viewModel = FAQsViewModel()
        
        let vc = FAQsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoPrivacyacyPolicy() {
        let viewModel = PrivacyPolicyViewModel()
        
        let vc = PrivacyPolicyViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoTermsAndConditions() {
        let viewModel = TermsConditionsViewModel()
        
        let vc = TermsConditionsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }

}
