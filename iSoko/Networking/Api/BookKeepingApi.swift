//
//  BookKeepingApi.swift
//  
//
//  Created by Edwin Weru on 24/03/2026.
//


import Foundation
import Moya
import NetworkingKit

// MARK: - Sales
public struct BookKeepingApi {

    public static func getAllSales(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllSalesByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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

    public static func getAllExpenses(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllExpensesByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
}

// MARK: - Stock
public extension BookKeepingApi {
    
    public static func getAllStock(userId: Int, page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllStockByDate(userId: Int, startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllCustomers(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllCustomersByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
        
    public static func getAllSuppliers(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllSuppliersByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
}

// MARK: - Reports
public extension BookKeepingApi {
    
    public static func getAllReports(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllReportsByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllSalesReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllExpensesReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
            path: "bookkeeping/reports/expenses",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllStockReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
            path: "bookkeeping/reports/products",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getAllCustomersReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
    
    public static func getAllSuppliersReportByDate(startDate: String, endDate: String, accessToken: String) -> UnifiedPagedResponseTarget<[ProductResponse]> {
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
