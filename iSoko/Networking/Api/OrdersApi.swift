//
//  OrdersApi.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import Foundation
import Moya
import NetworkingKit
import UtilsKit

// MARK: - orders
public struct OrdersApi {
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

extension OrdersApi {
    
    static func placeOrder(
        sellerId: Int,
        comment: String = "",
        products: [OrderProductRequest],
        accessToken: String
    ) -> ValueResponseTarget<OrderResponse> {
        
        let parameters: [String: Any] = [
            "comment": comment,
            "sellerId": sellerId,
            "products": products.map { $0.toDictionary() }
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "orders",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return ValueResponseTarget(target: target)
    }
}
