//
//  BookKeepingCoordinator.swift
//
//
//  Created by Edwin Weru on 20/01/2026.
//

import RouterKit
import UtilsKit
import UIKit

public class BookKeepingCoordinator: BaseCoordinator {
    
    public override func start() {
        goToBookKeepingDashboard()
    }
    
    // MARK: -
    public func goToBookKeepingDashboard() {
        
        let model = BookKeepingDashboardViewModel()
        
        model.goToFilter = goToDetails
        model.goToDetails = goToDetails
        
        model.goToRecordSales = goToBookKeepingSalesPayments
        model.goToAddExpense = goToBookKeepingExpenses
        model.goToManageStock = goToBookKeepingStock
        model.goToViewReports = goToBookKeepingReports
        model.goToCusomers = goToBookKeepingCustomers
        model.goToSuppliers = goToBookKeepingSupplies
        model.goToSpending = goToBookKeepingPurchases
        model.goToBills = goToBookKeepingExpenses
        
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
    
    public func goToDetails() {
        goToBookKeepingPurchases()
    }
    
    public func goToBookKeepingCustomers() {
        let model = BookKeepingCustomersViewModel()
        
        let vc = BookKeepingCustomersViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingPurchases() {
        let model = BookKeepingPurchasesViewModel()
        
        let vc = BookKeepingPurchasesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingSupplies() {
        let model = BookKeepingSuppliesViewModel()
        
        let vc = BookKeepingSuppliesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingStock() {
        let model = BookKeepingStockViewModel()
        
        let vc = BookKeepingStockViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingExpenses() {
        let model = BookKeepingExpensesViewModel()
        
        let vc = BookKeepingExpensesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingSalesPayments() {
        let model = BookKeepingSalesViewModel()
        
        let vc = BookKeepingSalesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingReports() {
        let model = BookKeepingReportsViewModel()
        
        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
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
    
    public func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}
