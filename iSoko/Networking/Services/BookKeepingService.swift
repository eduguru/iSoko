//
//  BookKeepingService.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

import NetworkingKit
import UtilsKit

public protocol BookKeepingService {
    
    func getOrderSummary(userId: Int, accessToken: String) async throws -> StatisticsResponse
    func getAllOrders(page: Int, count: Int, traderType: String, accessToken: String) async throws -> PagedResult<[CustomerOrderResponse]>
    func getOrderProducts(orderId: Int, page: Int, count: Int, accessToken: String) async throws -> PagedResult<[SalesResponse]>
    
    func getSalesType(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[CommonIdNameModel]>
    func getAllSales(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SalesResponse]>
    func getAllSalesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SalesResponse]>
    
    func addExpense(parameters: [String: Any], pickedFiles: [PickedFile]?, accessToken: String) async throws -> ExpenseResponse
    func getAllExpenses(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[ExpenseResponse]>
    func getAllExpensesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[ExpenseResponse]>
    func addExpenseCategories(name: String, accessToken: String) async throws -> SupplierCategoryResponse
    func getExpenseCategories(page: Int, count: Int, accessToken: String) async throws -> PagedResult<[CommonIdNameResponse]>
    
    func getAllStock(userId: Int, page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[StockResponse]>
    func getAllStockByDate(userId: Int, startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[StockResponse]>
    
    func getAllCustomers(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[CustomerResponse]>
    func getAllCustomersByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[CustomerResponse]>
    
    func addSupplier(parameters: [String: Any], accessToken: String) async throws -> SupplierResponse
    func getAllSuppliers(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SupplierResponse]>
    func getAllSuppliersByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SupplierResponse]>
    func getAllSuppliersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> SupplierReportResponse
    func addSupplierCategories(name: String, accessToken: String) async throws -> SupplierCategoryResponse
    func getSupplierCategories(page: Int, count: Int, accessToken: String) async throws -> PagedResult<[CommonIdNameResponse]>
    
    func getAllReports(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<BookKeepingSummaryResponse>
    func getAllReportsByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<BookKeepingSummaryResponse>
    
    func getAllSalesReportByDate(customerId: Int, startDate: String, endDate: String, accessToken: String)  async throws -> SalesReportResponse
    func getAllExpensesReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> ExpenseReportResponse
    func getAllStockReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> StockReportResponse
    func getAllCustomersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> CustomerReportResponse
    
}

public final class BookKeepingServiceImpl: BookKeepingService {
    
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider

    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
}

// MARK: - Sales
public extension BookKeepingServiceImpl {
    func getSalesType(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[CommonIdNameModel]> {
        let envelope = try await manager.request(
            BookKeepingApi.getSalesType(page: page, count: count, accessToken: accessToken))
        
        return envelope.toPagedResult()
    }
    
    func getAllSales(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SalesResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSales(page: page, count: count, accessToken: accessToken))
        
        return envelope.toPagedResult()
    }
    
    func getAllSalesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SalesResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSalesByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
}

// MARK: - Orders
public extension BookKeepingServiceImpl {
    
    func getOrderSummary(userId: Int, accessToken: String) async throws -> StatisticsResponse {
        let envelope = try await manager.request(
            BookKeepingApi.getOrderSummary(userId: userId, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllOrders(page: Int, count: Int, traderType: String = "buyer", accessToken: String) async throws -> PagedResult<[CustomerOrderResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllOrders(page: page, count: count, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getOrderProducts(orderId: Int, page: Int, count: Int, accessToken: String) async throws -> PagedResult<[SalesResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getOrderProducts(orderId: orderId, page: page, count: count, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
}

// MARK: - Expenses
public extension BookKeepingServiceImpl {
    func addExpense(parameters: [String: Any], pickedFiles: [PickedFile]?, accessToken: String) async throws -> ExpenseResponse {
        try await manager.request(BookKeepingApi.addExpense(parameters: parameters, pickedFiles: pickedFiles, accessToken: accessToken))
    }

    func getAllExpenses(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[ExpenseResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllExpenses(page: page, count: count, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllExpensesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[ExpenseResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllExpensesByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getExpenseCategories(page: Int, count: Int, accessToken: String) async throws -> PagedResult<[CommonIdNameResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getExpenseCategories(page: page, count: count, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func addExpenseCategories(name: String, accessToken: String) async throws -> SupplierCategoryResponse {
        let envelope = try await manager.request(
            BookKeepingApi.addExpenseCategories(name: name, accessToken: accessToken)
        )
        
        return envelope
    }
}

// MARK: - Stock
public extension BookKeepingServiceImpl {
    
    func addProduct(parameters: [String: Any], pickedFiles: [PickedFile]?, accessToken: String) async throws -> ExpenseResponse {
        try await manager.request(BookKeepingApi.addProduct(parameters: parameters, pickedFiles: pickedFiles, accessToken: accessToken))
    }
    
    func getAllStock(userId: Int, page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[StockResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllStock(
                userId: userId,
                page: page,
                count: count,
                accessToken: accessToken
            )
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllStockByDate(userId: Int, startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[StockResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllStockByDate(userId: userId, startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
}

// MARK: - Customers
public extension BookKeepingServiceImpl {
    
    func addCustomer(parameters: [String: Any], accessToken: String) async throws -> SupplierResponse {
        let envelope = try await manager.request(
            BookKeepingApi.addCustomer(parameters: parameters, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllCustomers(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[CustomerResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllCustomers(
                page: page,
                count: count,
                accessToken: accessToken
            )
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllCustomersByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[CustomerResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllCustomersByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
}

// MARK: - Suppliers
public extension BookKeepingServiceImpl {
    
    func addSupplier(parameters: [String: Any], accessToken: String) async throws -> SupplierResponse {
        let envelope = try await manager.request(
            BookKeepingApi.addSupplier(parameters: parameters, accessToken: accessToken)
        )
        
        return envelope
    }
        
    func getAllSuppliers(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SupplierResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSuppliers(
                page: page,
                count: count,
                accessToken: accessToken
            )
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllSuppliersByDate(startDate: String, endDate: String, accessToken: String) async throws -> PagedResult<[SupplierResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSuppliersByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getSupplierCategories(page: Int, count: Int, accessToken: String) async throws -> PagedResult<[CommonIdNameResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getSupplierCategories(page: page, count: count, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func addSupplierCategories(name: String, accessToken: String) async throws -> SupplierCategoryResponse {
        let envelope = try await manager.request(
            BookKeepingApi.addSupplierCategories(name: name, accessToken: accessToken)
        )
        
        return envelope
    }
}

// MARK: - Reports
public extension BookKeepingServiceImpl {
    
    func getAllReports(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<BookKeepingSummaryResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllReports(
                page: page,
                count: count,
                accessToken: accessToken
            )
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllReportsByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<BookKeepingSummaryResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllReportsByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllSalesReportByDate(customerId: Int, startDate: String, endDate: String, accessToken: String)  async throws -> SalesReportResponse {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSalesReportByDate(customerId: customerId, startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllExpensesReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> ExpenseReportResponse {
        let envelope = try await manager.request(
            BookKeepingApi.getAllExpensesReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllStockReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> StockReportResponse {
        let envelope = try await manager.request(
            BookKeepingApi.getAllStockReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllCustomersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> CustomerReportResponse {
        let envelope = try await manager.request(
            BookKeepingApi.getAllCustomersReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllSuppliersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> SupplierReportResponse {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSuppliersReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope
    }

}
