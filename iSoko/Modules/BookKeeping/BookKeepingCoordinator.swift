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
        model.goToRecordSales = goToBookKeepingSalesPayments// goToBookKeepingRecordSales
        
        model.goToTotalExpense = goToBookKeepingExpenses
        model.goToAddExpense = goToAddBookKeepingExpense
        
        model.goToLowStock = goToBookKeepingStock
        model.goToLowStock = goToBookKeepingLowStock
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
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingStock()
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
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingCustomer()
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
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingStock()
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
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingSupplier()
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
        
        vc.goToCreateAction = { [weak self] in
            self?.goToAddBookKeepingStock()
        }
        
        router.push(vc)
    }
    
    public func goToBookKeepingExpenses() {
        let model = BookKeepingExpensesViewModel()
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        
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
    private func goToCommonSelection(_ type: CommonUtilityOption, _ staticOptions: [CommonIdNameModel]? = nil, _ completion: @escaping (CommonIdNameModel?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToCommonSelection(type, staticOptions) { [weak self] result in
            completion(result)
        }
    }
    
    private func gotoSelectSystemCountry(_ type: CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) {
        let viewModel = CommonOptionPickerViewModel(option: type)
        
        viewModel.confirmSelection = { [weak self] selection in
            switch selection {
            case .countries(let response):
                let model = response
                completion(model)
            default:
                completion(nil)
            }

            self?.router.pop(animated: true)
        }

        let vc = CommonOptionPickerViewController()
        vc.viewModel = viewModel
        vc.closeAction = { [weak self] in
            self?.router.pop(animated: true)
        }

        router.navigationControllerInstance?.navigationBar.isHidden = false
        router.push(vc, animated: true)
    }
    
    private func gotoSelectCountry(completion: @escaping (Country) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        // coordinator.delegate = self
        addChild(coordinator)
        coordinator.goToCountrySelection { [weak self] result in
            completion(result)
            self?.router.pop()
        }
    }
    
    private func gotoSelectDate(config: DatePickerConfig,completion: @escaping (Date?) -> Void) {
        let coordinator = ModalCoordinator(router: router)
        addChild(coordinator)
        
        coordinator.goToAppleStyleCalendar(config: config) { [weak self] result in
            completion(result)
        }
    }
    
    public func goToAddBookKeepingExpense() {
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
    
    public func goToSelectExpenseCategory() {
        goToCommonSelection(CommonUtilityOption.ageGroups, nil) { [weak self]_ in
            
        }
    }
    
    public func goToAddBookKeepingSales() {
        let model = AddBookKeepingSalesViewModel()
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        
        model.goToAddCustomer = goToAddBookKeepingCustomer
        
        let vc = AddBookKeepingSalesViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToAddBookKeepingStock() {
        let model = AddBookKeepingStockViewModel()
        
        let vc = AddBookKeepingStockViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToAddBookKeepingCustomer() {
        let model = AddBookKeepingCustomersViewModel()
        model.gotoSelectSystemCountry = gotoSelectSystemCountry

        let vc = AddBookKeepingCustomersViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToAddBookKeepingSupplier() {
        let model = AddBookKeepingSuppliesViewModel()
        
        model.gotoConfirm = { }
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
    
    public func goToAddSupplierCategory() {
        let model = AddSupplierCategoryViewModel()
        model.gotoConfirm = { }
        
        let vc = AddSupplierCategoryViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
    public func goToAddExpenseCategory() {
        let model = AddExpenseCategoryViewModel()
        model.gotoConfirm = { }
        
        let vc = AddExpenseCategoryViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in
            self?.router.pop()
        }
        
        router.push(vc)
    }
    
}

extension BookKeepingCoordinator {
    
    @MainActor
    public func goToReportTypes(_ payload: ReportSelectionPayload) {

        switch payload.report {
        case .sales:
            goToSalesReport(payload)

        case .expenses:
            goToExpensesReport(payload)

        case .stock:
            goToStockReport(payload)

        case .profitLoss:
            goToProfitLossReport(payload)

        case .customers:
            goToCustomersReport(payload)

        case .suppliers:
            goToSuppliersReport(payload)
        }
    }
    
    @MainActor
    public func goToSalesReport(_ payload: ReportSelectionPayload) {

        let model = SalesReportsViewModel(payload: payload)
        model.gotoConfirm = { }
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry
        
        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }

        router.push(vc)
    }
    
    @MainActor
    public func goToExpensesReport(_ payload: ReportSelectionPayload) {
        
        let model = ExpensesReportsViewModel(payload: payload)
        model.gotoConfirm = { }
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry

        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }

        router.push(vc)
    }
    
    @MainActor
    public func goToSuppliersReport(_ payload: ReportSelectionPayload) {
        
        let model = SuppliersReportsViewModel(payload: payload)
        model.gotoConfirm = { }
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry

        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }

        router.push(vc)
    }
    
    @MainActor
    public func goToCustomersReport(_ payload: ReportSelectionPayload) {
        
        let model = CustomersReportsViewModel(payload: payload)
        model.gotoConfirm = { }
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry

        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }

        router.push(vc)
    }
    
    @MainActor
    public func goToStockReport(_ payload: ReportSelectionPayload) {
        
        let model = StockReportsViewModel(payload: payload)
        model.gotoConfirm = { }
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry

        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }

        router.push(vc)
    }
    
    @MainActor
    public func goToProfitLossReport(_ payload: ReportSelectionPayload) {
        
        let model = ProfitLossReportsViewModel(payload: payload)
        model.gotoConfirm = { }
        model.goToDateSelection = gotoSelectDate
        model.goToCommonSelectionOptions = goToCommonSelection
        model.gotoSelectSystemCountry = gotoSelectSystemCountry

        let vc = BookKeepingReportsViewController()
        vc.viewModel = model
        vc.closeAction = { [weak self] in self?.router.pop() }

        router.push(vc)
    }
}
