//
//  BookKeepingCoordinator+Create.swift
//  
//
//  Created by Edwin Weru on 30/04/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit

public extension BookKeepingCoordinator {
    
    func goToAddBookKeepingSales() {
        let model = AddBookKeepingSalesViewModel()
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.goToProductSelection = goToProductSelection
        
        model.goToAddCustomer = goToAddBookKeepingCustomer
        
        let vc = AddBookKeepingSalesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToAddBookKeepingStock() {
        let model = AddBookKeepingStockViewModel()
        model.goToShowSuccessScreen = goToShowSuccessScreen
        
        let vc = AddBookKeepingStockViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToAddBookKeepingCustomer() {
        let model = AddBookKeepingCustomersViewModel()
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.gotoSelectSystemCountry = gotoSelectSystemCountry
        
        let vc = AddBookKeepingCustomersViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToAddBookKeepingSupplier() {
        let model = AddBookKeepingSuppliesViewModel()
        
        model.gotoConfirm = { }
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry
        
        model.goToAddCategory = goToAddSupplierCategory
        
        let vc = AddBookKeepingSuppliesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToAddSupplierCategory() {
        let model = AddSupplierCategoryViewModel()
        model.goToAddCategorySuccess = { [weak self] item in
            self?.goToShowSuccessScreen()
        }
        model.gotoConfirm = { }
        
        let vc = AddSupplierCategoryViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToAddExpenseCategory() {
        let model = AddExpenseCategoryViewModel()
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.gotoConfirm = { }
        
        let vc = AddExpenseCategoryViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToShowSuccessScreen() {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.presentSuccessAlert() { [weak self] in
            self?.router.pop()
        }
    }
    
    func goToShowErrorScreen() {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.presentErrorAlert(
            onPrimaryAction:  { [weak self] in
                self?.router.pop()
            },
            onSecondaryAction:  { [weak self] in
                self?.router.pop()
            }
        )
    }
}
