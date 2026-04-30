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
        let model = BookKeepingCustomerDetailsViewModel()
        
        let vc = BookKeepingCustomerDetailsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingPurchaseDetails(_ item: ExpenseResponse) {
        let model = BookKeepingPurchasesDetailsViewModel()
        
        let vc = BookKeepingPurchasesDetailsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingSupplierDetails(_ item: SupplierResponse) {
        let model = BookKeepingSuppliesDetailsViewModel()
        
        let vc = BookKeepingSuppliesDetailsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingStockDetails(_ item: StockResponse) {
        let model = BookKeepingStockDetailsViewModel()
        
        let vc = BookKeepingStockDetailsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingExpenseDetails(_ item: ExpenseResponse) {
        let model = BookKeepingExpensesDetailsViewModel()
        
        let vc = BookKeepingExpensesDetailsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    func goToBookKeepingSalesDetails(_ item: SalesResponse) {
        let model = BookKeepingSaleDetailsViewModel()
        
        let vc = BookKeepingSaleDetailsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
}
