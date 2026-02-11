//
//  TradeAssociationCoordinator.swift
//
//
//  Created by Edwin Weru on 09/02/2026.
//

import RouterKit
import UIKit

@MainActor
final class TradeAssociationFlowCoordinator: BaseCoordinator {
    
    private weak var presentingVC: UIViewController?
    
    init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
        
        // 🔑 Create a BRAND NEW navigation controller
        let nav = BaseNavigationController()
        let router = Router(navigationController: nav)
        
        super.init(parentCoordinator: nil, router: router)
    }
    
    override func start() {
        gotoTradeAssociations()
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
            self?.router.dismiss(animated: true)
            // self?.router.pop(animated: true)
        }
        
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
    
    private func finishFlow() {
        presentingVC?.dismiss(animated: true) { [weak self] in
            self?.finishWorkflow()
        }
    }
    
    var rootNavigationController: UINavigationController {
        router.navigationControllerInstance!
    }
}
