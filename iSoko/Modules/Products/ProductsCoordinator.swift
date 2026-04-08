//
//  ProductsCoordinator.swift
//  
//
//  Created by Edwin Weru on 01/04/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit
import StorageKit

public class ProductsCoordinator: BaseCoordinator {
    
    public override func start() {
        goToMyProducts()
    }
    
    // MARK: -
    private func goToMyProducts() {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = MyProductListingsViewModel()
        viewModel.goToDetails = goToMyProductDetails
        
        let vc = MyProductListingsViewController()
        vc.viewModel = viewModel
        
        vc.goToCreateAction = { [weak self] in
            self?.gotoCreateProduct()
        }
        
        vc.closeAction = { [weak self] in
            // self?.router.pop(animated: true)
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
    
    private func goToMyProductDetails(_ item: StockResponse) {
        guard AppStorage.hasLoggedIn == true else {
            presentAuthBottomSheet()
            return
        }
        
        let viewModel = MyProductDetailsViewModel(item)
        let vc = ProductDetailsViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.push(vc, animated: true)
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
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}

extension ProductsCoordinator {
    
    private func gotoCreateProduct() {
        let modalCoordinator = ModalCoordinator(router: router)  // coordinator.delegate = self
        addChild(modalCoordinator)
        
        let viewModel = AddProductViewModel()
        viewModel.gotoConfirm = { [weak self] in
            self?.gotoCompleteCreateProduct()
        }
        
        let vc = AddProductViewController()
        vc.viewModel = viewModel
        
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoCompleteCreateProduct() {
        let viewModel = AddProductImagesViewModel()
        let vc = AddProductImagesViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        
        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
}
