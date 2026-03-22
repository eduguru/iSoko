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
        
        model.goToFilter = goToDetails
        model.goToDetails = goToDetails
        
        model.goToTotalSales =  goToBookKeepingSalesPayments
        model.goToTotalProducts = goToBookKeepingPurchases
        model.goToTotalExpense = goToBookKeepingExpenses
        model.goToLowStock = goToBookKeepingStock
        
        model.goToLowStock = goToBookKeepingLowStock
        model.goToRecordSales = goToBookKeepingRecordSales
        model.goToAddExpense = goToBookKeepingAddExpense
        
        model.goToManageStock = goToBookKeepingStock
        model.goToViewReports = goToBookKeepingReports
        
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
    
    public func goToDetails() {
        goToBookKeepingPurchases()
    }
 
    public func goToBookKeepingLowStock() {
        let model = LowBookKeepingStockViewModel()
        
        let vc = LowBookKeepingStockViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingRecordSales() {
        let model = AddBookKeepingSalesViewModel()
        
        let vc = AddBookKeepingSalesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingAddExpense() {
        let model = AddBookKeepingExpensesViewModel()
        
        let vc = AddBookKeepingExpensesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
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
        model.gotoConfirm = goToReportTypes
        
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
    
    private func dismiss() {
        dismissModal()
    }
    
    private func finish() {
        dismissModal() // will call router.dismiss()
        parentCoordinator?.removeChild(self)
    }
}

extension BookKeepingCoordinator {
    
    @MainActor
    public func goToReportTypes(_ payload: ReportSelectionPayload) {
        
        let model: FormViewModel
        
        switch payload.report {
        case .sales: model = SalesReportsViewModel()
        case .expenses: model = ExpensesReportsViewModel()
        case .stock: model = StockReportsViewModel()
        case .profitLoss: model = ProfitLossReportsViewModel()
        case .customers: model = CustomersReportsViewModel()
        case .suppliers: model = SuppliersReportsViewModel()
        }
        
        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }
        router.push(vc)
    }
    
    public func goToSalesReport() {
    }
    
    public func goToExpensesReport() {
    }
    
    public func goToStockReport() {
    }
    
    public func goToProfitLossReport() {
    }
    
    public func goToCustomersReport() {
    }
    
    public func goToSuppliersReport() {
    }
}
