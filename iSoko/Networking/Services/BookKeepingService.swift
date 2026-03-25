//
//  BookKeepingService.swift
//  
//
//  Created by Edwin Weru on 25/03/2026.
//

import NetworkingKit

public protocol BookKeepingService {
    func getAllSales(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SalesResponse]>
    func getAllSalesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SalesResponse]>
    
    func getAllExpenses(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[ExpenseResponse]>
    func getAllExpensesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[ExpenseResponse]>
    
    func getAllStock(userId: Int, page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[StockResponse]>
    func getAllStockByDate(userId: Int, startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[StockResponse]>
    
    func getAllCustomers(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[CustomerResponse]>
    func getAllCustomersByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[CustomerResponse]>
    
    func getAllSuppliers(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SupplierResponse]>
    func getAllSuppliersByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SupplierResponse]>
    
    func getAllReports(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<BookKeepingSummaryResponse>
    func getAllReportsByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<BookKeepingSummaryResponse>
    
    func getAllSalesReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<SalesReportResponse>
    func getAllExpensesReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<ExpenseReportResponse>
    func getAllStockReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<StockReportResponse>
    func getAllCustomersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<CustomerReportResponse>
    func getAllSuppliersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<SupplierReportResponse>
    
}

public final class BookKeepingServiceImpl: BookKeepingService {
    
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider

    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }

    public func getAllSales(page: Int, count: Int, accessToken: String)  async throws -> PagedResult<[SalesResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSales(page: page, count: count, accessToken: accessToken))
        
        return envelope.toPagedResult()
    }
    
    public func getAllSalesByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SalesResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSalesByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
}

// MARK: - Expenses
public extension BookKeepingServiceImpl {

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
}

// MARK: - Stock
public extension BookKeepingServiceImpl {
    
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
    
    func getAllSuppliersByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<[SupplierResponse]> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSuppliersByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
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
    
    func getAllSalesReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<SalesReportResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSalesReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllExpensesReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<ExpenseReportResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllExpensesReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllStockReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<StockReportResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllStockReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllCustomersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<CustomerReportResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllCustomersReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }
    
    func getAllSuppliersReportByDate(startDate: String, endDate: String, accessToken: String)  async throws -> PagedResult<SupplierReportResponse> {
        let envelope = try await manager.request(
            BookKeepingApi.getAllSuppliersReportByDate(startDate: startDate, endDate: endDate, accessToken: accessToken)
        )
        
        return envelope.toPagedResult()
    }

}
