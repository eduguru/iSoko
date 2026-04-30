//
//  BookKeepingCoordinator.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit

public class BookKeepingCoordinator: BaseCoordinator {
    
    public override func start() {
        goToBookKeepingDashboard()
    }
    
    // MARK: -
    public func goToBookKeepingDashboard() {
        
        let model = BookKeepingDashboardViewModel()
        
        model.goToFilter = goToFilter
        // model.goToDetails = goToDetails
        
        model.goToTotalSales =  goToBookKeepingSalesPayments
        model.goToRecordSales = goToBookKeepingSalesPayments// goToBookKeepingRecordSales
        
        model.goToTotalExpense = goToBookKeepingExpenses
        model.goToAddExpense = goToAddBookKeepingExpense
        
        model.goToLowStock = goToBookKeepingStock
        
        model.goToManageStock = goToBookKeepingStock
        
        model.goToViewReports = goToBookKeepingReports
        model.goToTotalProducts = goToBookKeepingPurchases
        model.goToCustomers = goToBookKeepingCustomers
        model.goToSuppliers = goToBookKeepingSupplies
        
        let vc = BookKeepingDashboardViewController()
        vc.viewModel = model
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
    
    public func goToBookKeepingReports() {
        let model = BookKeepingReportsViewModel()
        
        model.goToDateSelection = gotoSelectDate
        model.gotoConfirm = goToReportTypes
        
        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToFilter() {

    }
    
    public func goToBookKeepingLowStock() {
        let model = LowBookKeepingStockViewModel()
        model.goToDetails = goToBookKeepingStockDetails
        
        let vc = LowBookKeepingStockViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingStock()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingCustomers() {
        let model = BookKeepingCustomersViewModel()
        model.goToDetails = goToBookKeepingCustomerDetails
        
        let vc = BookKeepingCustomersViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingCustomer()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingPurchases() {
        let model = BookKeepingPurchasesViewModel()
        model.goToDetails = goToBookKeepingPurchaseDetails
        
        let vc = BookKeepingPurchasesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingStock()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingSupplies() {
        let model = BookKeepingSuppliesViewModel()
        model.goToDetails = goToBookKeepingSupplierDetails
        
        let vc = BookKeepingSuppliesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingSupplier()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingStock() {
        let model = BookKeepingStockViewModel()
        model.goToDetails = goToBookKeepingStockDetails
        
        let vc = BookKeepingStockViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingStock()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingExpenses() {
        let model = BookKeepingExpensesViewModel()
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.goToDetails = goToBookKeepingExpenseDetails
        
        let vc = BookKeepingExpensesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingExpense()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingSalesPayments() {
        let model = BookKeepingSalesViewModel()
        model.goToDetails = goToBookKeepingSalesDetails
        
        let vc = BookKeepingSalesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingSales()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingProfitLoss() {
        let model = BookKeepingProfitLossViewModel()
        
        let vc = BookKeepingProfitLossViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}
