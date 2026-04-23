//
//  BookKeepingApi.swift
//  
//
//  Created by Edwin Weru on 24/03/2026.
//


import Foundation
import Moya
import NetworkingKit
import UtilsKit

// MARK: - orders
public struct BookKeepingApi {
    
    static func getOrderSummary(userId: Int, accessToken: String) -> ValueResponseTarget<StatisticsResponse> {
        let parameters: [String: Any] = [:]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "users/\(userId)/summary",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
    
    static func getAllOrders(page: Int, count: Int, traderType: String = "buyer", accessToken: String) -> UnifiedPagedResponseTarget<[CustomerOrderResponse]> {
        let parameters: [String: Any] = [
            "page": page,
            "traderType": traderType,
            "count": count
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "orders",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getOrderProducts(orderId: Int, page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[SalesResponse]> {
        let parameters: [String: Any] = [
            "page": page,
            "count": count
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "orders/\(orderId)/products",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
}

// MARK: - Sales
public extension BookKeepingApi {
    
    static func getSalesType(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[CommonIdNameModel]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/sale-types",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getAllSales(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[SalesResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/sales",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getAllSalesByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[SalesResponse]> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
}

// MARK: - Expenses
public extension BookKeepingApi {
    
    static func addExpense(
        parameters: [String: Any],
        pickedFiles: [PickedFile]?,
        accessToken: String
    ) -> ValueResponseTarget<ExpenseResponse> {
        
        let headers: [String: String] = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let paramsJson = try? JSONSerialization.data(withJSONObject: parameters)
        var files: [UploadFile] = Helpers.mapPickedFile2UploadFile(pickedFiles, name: "documents")

        let target = MultipartUploadTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/expenses",
            method: .post,
            jsonPartName: "expense",
            jsonData: paramsJson,
            files: files,
            headers: headers,
            requiresAuth: false
        )

        return ValueResponseTarget(target: target.asAnyTarget())
    }

    static func getAllExpenses(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ExpenseResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/expenses",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getAllExpensesByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ExpenseResponse]> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/expenses",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getExpenseCategories(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[CommonIdNameResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/expense-categories",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func addExpenseCategories(name: String, accessToken: String) -> ValueResponseTarget<SupplierCategoryResponse> {
        let parameters: [String: Any] = ["name": name]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/expense-categories",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
}

// MARK: - Stock
public extension BookKeepingApi {
    
    static func addProduct(
        parameters: [String: Any],
        pickedFiles: [PickedFile]?,
        accessToken: String
    ) -> ValueResponseTarget<ExpenseResponse> {
        
        let headers: [String: String] = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let paramsJson = try? JSONSerialization.data(withJSONObject: parameters)
        var files: [UploadFile] = Helpers.mapPickedFile2UploadFile(pickedFiles, name: "images")

        let target = MultipartUploadTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "products",
            method: .post,
            jsonPartName: "product",
            jsonData: paramsJson,
            files: files,
            headers: headers,
            requiresAuth: false
        )

        return ValueResponseTarget(target: target.asAnyTarget())
    }
    
    static func getAllStock(userId: Int, page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[StockResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "users/\(userId)/products",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllStockByDate(userId: Int, startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[StockResponse]> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "users/\(userId)/products",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
}

// MARK: - Customers
public extension BookKeepingApi {
    
    static func addCustomer(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<SupplierResponse> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/customers",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
    
    static func getAllCustomers(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[CustomerResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/customers",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getAllCustomersByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[CustomerResponse]> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/customers",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
}

// MARK: - Suppliers
public extension BookKeepingApi {
    
    static func addSupplier(parameters: [String: Any], accessToken: String) -> ValueResponseTarget<SupplierResponse> {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/suppliers",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
        
    static func getAllSuppliers(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[SupplierResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/suppliers",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getAllSuppliersByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[SupplierResponse]> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/suppliers",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func getSupplierCategories(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[CommonIdNameResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/supplier-categories",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    static func addSupplierCategories(name: String, accessToken: String) -> ValueResponseTarget<SupplierCategoryResponse> {
        let parameters: [String: Any] = ["name": name]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/supplier-categories",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
    
}

// MARK: - Reports
public extension BookKeepingApi {
    
    public static func getAllReports(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<BookKeepingSummaryResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllReportsByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<BookKeepingSummaryResponse> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllSalesReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<SalesReportResponse> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/reports/sales",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllExpensesReportByDate(startDate: String, endDate: String, accessToken: String) -> ValueResponseTarget<ExpenseReportResponse> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/expenses/reports",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
    
    public static func getAllStockReportByDate(startDate: String, endDate: String, accessToken: String) -> ValueResponseTarget<StockReportResponse> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "products/reports",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
    
    public static func getAllCustomersReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<CustomerReportResponse> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/reports/customers",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllSuppliersReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<SupplierReportResponse> {
        let parameters: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "bookkeeping/reports/suppliers",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }

}
