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
        model.onTapService = goToServiceDetails
        
        model.onTapMoreProduct = goToAllProduct
        model.onTapMoreServices = onTapMoreServices
        model.onTapMoreProductCategories = onTapMoreProductCategories
        model.onTapMoreServiceCategories = onTapMoreServiceCategories
        
        model.onTapProductCategory = onTapProductCategory
        model.onTapServiceCategory = onTapServiceCategory
        
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
    
    private  func goToServiceDetails(_ product: TradeServiceResponse) {
        let viewModel = ServiceDetailsViewModel(product)
        
        let vc = ServiceDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in // goToMainTabs
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToAllProduct() {
        let viewModel = ProductListingsViewModel()
        viewModel.onTapProduct = { [weak self] in
            self?.goToProduct($0)
        }
        
        let vc = ProductListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func onTapMoreServices() {
        let viewModel = ServiceListingsViewModel()
        viewModel.onTapService = { [weak self] in
            self?.goToServiceDetails($0)
        }
        
        let vc = ServiceListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func  onTapProductCategory(_ item: CommodityCategoryResponse) {
        let id = item.id ?? 0
        
        let viewModel = ProductListingsViewModel(categoryId: "\(id)")
        viewModel.onTapProduct = { [weak self] in
            self?.goToProduct($0)
        }
        
        let vc = ProductListingsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func  onTapServiceCategory(_ item: TradeServiceCategoryResponse) {
        let id = item.id ?? 0
        
        let viewModel = ServiceListingsViewModel(categoryId: "\(id)")
        viewModel.onTapService = { [weak self] in
            self?.goToServiceDetails($0)
        }
        
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
        viewModel.onTapProduct = onTapProductCategory
        
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
        viewModel.onTapProduct = onTapServiceCategory
        
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
