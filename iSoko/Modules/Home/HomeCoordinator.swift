//
//  HomeCoordinator.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import RouterKit
import UtilsKit
import UIKit
import StorageKit

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
        
        model.onTapTradeAssociation = gotoTradeAssociations
        
        let controller = HomeViewController()
        controller.makeRoot = true
        controller.viewModel = model
        controller.closeAction = finishWorkflow
        
        controller.onCountryTapped = { [weak self] in
            self?.gotoSelectCountry(completion: { val in
                self?.goToReloadApp()
            })
        }
        
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
    
    public override func start() {
        router.setRoot(primaryViewController())
    }
    
    private func goToProduct(_ product: ProductResponseV1) {
        let viewModel = ProductDetailsViewModel(product)
        viewModel.onPlaceOrder = goToPlaceOrder
        viewModel.onViewStoreTap = goToViewStoreTap
        
        let vc = ProductDetailsViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        // Set callbacks
        viewModel.onProductTap = { [weak self] tappedProduct in
            guard let self = self else { return }
            // Create a new details screen for the tapped product
            self.goToProduct(tappedProduct)
        }
        
        viewModel.onToggleFavorite = { tappedProduct, isFav in
            print("\(tappedProduct.name ?? "") favorite toggled: \(isFav)")
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func goToPlaceOrder(with order: PlaceOrderPayload) {

        let viewModel = PlaceOrderConfirmationViewModel(order)
        let vc = PlaceOrderConfirmationViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.push(vc, animated: true)
        
    }
    
    func goToViewStoreTap(_ data: TraderV1) {
        let viewModel = StoreProfileViewModel(data)

        let vc = StoreProfileViewController()
        vc.viewModel = viewModel

        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.push(vc, animated: true)
    }
    
    private  func goToServiceDetails(_ product: TradeServiceResponse) {
        let viewModel = ServiceDetailsViewModel(product)
        
        let vc = ServiceDetailsViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in 
            self?.router.pop(animated: true)
        }
        
        viewModel.onServiceTap = { [weak self] service in
            let newViewModel = ServiceDetailsViewModel(service)
            let vc = ServiceDetailsViewController()
            vc.viewModel = newViewModel
            vc.closeAction = { [weak vc] in
                vc?.navigationController?.popViewController(animated: true)
            }

            // Pass callbacks to the new VM if needed
            newViewModel.onServiceTap = viewModel.onServiceTap
            newViewModel.onToggleFavorite = viewModel.onToggleFavorite

            self?.router.push(vc, animated: true)
        }

        viewModel.onToggleFavorite = { service, isFav in
            print("\(service.name ?? "") favorite toggled: \(isFav)")
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
        let viewModel = ProductListingsViewModel(category: item)
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
        let viewModel = ServiceListingsViewModel(item: item)
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
        vc.closeAction = { [weak self] in 
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func backAction() {
        dismiss()
    }
    
    private func dismiss() {
        dismissModal()
    }
}

extension HomeCoordinator {
    private func gotoTradeAssociations(_ item: AssociationResponse) {
        let coordinator = TradeAssociationFlowCoordinator(router: router)
        addChild(coordinator)
        coordinator.goToTradeAssociationProducs(item)
    }
    
    func gotoSelectCountry(completion: @escaping (Country) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToCountrySelection { [weak self] result in
            AppStorage.selectedRegion = result.name
            AppStorage.selectedRegionCode = result.id.lowercased()
            AppStorage.hasSelectedRegion = true
            
            completion(result)
            self?.router.pop()
        }
    }
    
    private func goToReloadApp() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 1. Reuse the current root navigation controller
            let router = Router(navigationController: self.router.navigationControllerInstance)
            
            // 2. Create MainCoordinator using the same nav
            let mainCoordinator = MainCoordinator(router: router)
            
            // 3. Retain coordinator to prevent deinit
            self.addChild(mainCoordinator)
            
            // 4. Start flow
            mainCoordinator.start()
        }
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
