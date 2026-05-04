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
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        
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
    
    func goToAddBookKeepingExpense() {
        let model = AddBookKeepingExpensesViewModel()
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        
        model.goToAddSupplier = goToAddBookKeepingSupplier
        model.goToAddExpenseCategory = goToAddExpenseCategory
        
        let vc = AddBookKeepingExpensesViewController()
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

//MARK: - -
public extension BookKeepingCoordinator {
    
    func goToEditBookKeepingSales(sale: SalesResponse) {
        let model = EditBookKeepingSalesViewModel(sale: sale)
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.goToProductSelection = goToProductSelection
        
        model.goToAddCustomer = goToAddBookKeepingCustomer
        
        let vc = EditBookKeepingSalesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToEditBookKeepingStock(stock: StockResponse) {
        let model = EditBookKeepingStockViewModel(stock: stock)
        model.goToShowSuccessScreen = goToShowSuccessScreen
        
        let vc = EditBookKeepingStockViewComtroller()
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToEditBookKeepingPurchases(stock: StockResponse) {
        let model = EditBookKeepingStockViewModel(stock: stock)
        model.goToShowSuccessScreen = goToShowSuccessScreen
        
        let vc = EditBookKeepingStockViewComtroller()
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToEditBookKeepingCustomer(customer: CustomerResponse) {
        let model = EditBookKeepingCustomersViewModel(customer: customer)
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.gotoSelectSystemCountry = gotoSelectSystemCountry
        
        let vc = EditBookKeepingCustomersViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToEditBookKeepingSupplier(supplier: SupplierResponse) {
        let model = EditBookKeepingSuppliesViewModel(supplier: supplier)
        
        model.gotoConfirm = { }
        model.goToShowSuccessScreen = goToShowSuccessScreen
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry
        
        model.goToAddCategory = goToAddSupplierCategory
        
        let vc = EditBookKeepingSuppliesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToEditBookKeepingExpenses(expense: ExpenseResponse) {
        let model = EditBookKeepingExpensesViewModel(expense: expense)
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        
        model.goToAddSupplier = goToAddBookKeepingSupplier
        model.goToAddExpenseCategory = goToAddExpenseCategory
        
        let vc = EditBookKeepingExpensesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
}
