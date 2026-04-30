//
//  BookKeepingCoordinator+Reports.swift
//  
//
//  Created by Edwin Weru on 30/04/2026.
//

import RouterKit
import UtilsKit
import UIKit
import DesignSystemKit

public extension BookKeepingCoordinator {
    
    @MainActor
    func goToReportTypes(_ payload: ReportSelectionPayload) {
        
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
    func goToSalesReport(_ payload: ReportSelectionPayload) {
        
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
    func goToExpensesReport(_ payload: ReportSelectionPayload) {
        
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
    func goToSuppliersReport(_ payload: ReportSelectionPayload) {
        
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
    func goToCustomersReport(_ payload: ReportSelectionPayload) {
        
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
    func goToStockReport(_ payload: ReportSelectionPayload) {
        
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
    func goToProfitLossReport(_ payload: ReportSelectionPayload) {
        
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
