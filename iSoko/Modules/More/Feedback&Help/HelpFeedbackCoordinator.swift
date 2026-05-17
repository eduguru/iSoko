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
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}
