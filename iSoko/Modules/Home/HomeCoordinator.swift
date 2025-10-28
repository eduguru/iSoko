//
//  HomeCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UtilsKit
import UIKit

public class HomeCoordinator: BaseCoordinator {
    
    func primaryViewController() -> HomeViewController {
        let model = HomeViewModel()
        model.onTapProduct = goToProduct
        model.onTapMoreProduct = goToAllProduct
        model.onTapMoreServices = onTapMoreServices
        model.onTapMoreProductCategories = onTapMoreProductCategories
        model.onTapMoreServiceCategories = onTapMoreServiceCategories
        
        let controller = HomeViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    public override func start() {
        navigationController?.pushViewController(primaryViewController(), animated: true)
    }
    
    private  func goToProduct(_ product: ProductResponse) {
        let viewModel = ProductDetailsViewModel(product)
        
        let vc = ProductDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private  func goToAllProduct() {
        let viewModel = ProductListingsViewModel()
        
        let vc = ProductListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private  func onTapMoreServices() {
        let viewModel = ServiceListingsViewModel()
        
        let vc = ServiceListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private  func onTapMoreProductCategories() {
        let viewModel = ProductCategoriesViewModel()
        
        let vc = ProductCategoriesViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private  func onTapMoreServiceCategories() {
        let viewModel = ServiceCategoriesViewModel()
        
        let vc = ServiceCategoriesViewController()
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
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func backAction() {
        dismiss()
    }
    
    public func dismiss() {
        dismissModal()
    }
}


extension HomeCoordinator: CoordinatorDelegate {
    public func coordinatorDidFinish(_ coordinator: Coordinator) {
        removeChild(coordinator)
    }
    
    public func coordinatorDidPresentModal(_ coordinator: Coordinator) {
        print("Modal coordinator presented")
    }
    
    public func coordinatorDidDismissModal(_ coordinator: Coordinator) {
        print("Modal coordinator dismissed")
        removeChild(coordinator)
    }
}
