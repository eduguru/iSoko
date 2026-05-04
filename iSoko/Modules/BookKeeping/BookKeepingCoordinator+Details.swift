//
//  BookKeepingCoordinator+Details.swift
//  
//
//  Created by Edwin Weru on 30/04/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit

public extension BookKeepingCoordinator {
    
    func goToBookKeepingCustomerDetails(_ item: CustomerResponse) {
        let model = BookKeepingCustomerDetailsViewModel(item)
        model.goToEdit = goToEditBookKeepingCustomer
        
        let vc = BookKeepingCustomerDetailsViewController()
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingPurchaseDetails(_ item: ExpenseResponse) {
        let model = BookKeepingPurchasesDetailsViewModel(item)
        
        let vc = BookKeepingPurchasesDetailsViewController()
        
//        vc.goToEditAction = { [weak self] in
//            self?.goToEditBookKeepingPurchases(stock: item)
//        }
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingSupplierDetails(_ item: SupplierResponse) {
        let model = BookKeepingSuppliesDetailsViewModel(item)
        
        let vc = BookKeepingSuppliesDetailsViewController()
        
        model.goToEdit = goToEditBookKeepingSupplier
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingStockDetails(_ item: StockResponse) {
        let model = BookKeepingStockDetailsViewModel(item)
        
        let vc = BookKeepingStockDetailsViewController()
        
        model.goToEdit = goToEditBookKeepingStock
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingExpenseDetails(_ item: ExpenseResponse) {
        let model = BookKeepingExpensesDetailsViewModel(item)
        
        let vc = BookKeepingExpensesDetailsViewController()
        
        model.goToEdit = goToEditBookKeepingExpenses
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingSalesDetails(_ item: SalesResponse) {
        let model = BookKeepingSaleDetailsViewModel(item)
        
        let vc = BookKeepingSaleDetailsViewController()
        
        model.goToEdit = goToEditBookKeepingSales
        
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
}
