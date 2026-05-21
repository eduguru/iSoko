//
//  OrdersService.swift
//
//
//  Created by Edwin Weru on 21/05/2026.
//

import NetworkingKit

public protocol OrdersService {
    
    func getOrderSummary(userId: Int, accessToken: String) async throws -> StatisticsResponse
    func getAllOrders(page: Int, count: Int, traderType: String, accessToken: String) async throws -> PagedResult<[CustomerOrderResponse]>
    func getOrderProducts(orderId: Int, page: Int, count: Int, accessToken: String) async throws -> PagedResult<[SalesResponse]>
    
    func placeOrder(
        sellerId: Int,
        comment: String,
        products: [OrderProductRequest],
        accessToken: String
    ) async throws -> OrderResponse
}

public final class OrdersServiceImpl: OrdersService {
    
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
}

// MARK: - Orders
public extension OrdersServiceImpl {
    
    func getOrderSummary(userId: Int, accessToken: String) async throws -> StatisticsResponse {
        let envelope = try await manager.request(
            OrdersApi.getOrderSummary(userId: userId, accessToken: accessToken)
        )
        
        return envelope
    }
    
    func getAllOrders(
        page: Int,
        count: Int,
        traderType: String = "buyer",
        accessToken: String
    ) async throws -> PagedResult<[CustomerOrderResponse]> {
        
        let envelope = try await manager.request(
            OrdersApi.getAllOrders(
                page: page,
                count: count,
                traderType: traderType,
                accessToken: accessToken
            )
        )
        
        return envelope.toPagedResult()
    }
    
    func getOrderProducts(
        orderId: Int,
        page: Int,
        count: Int,
        accessToken: String
    ) async throws -> PagedResult<[SalesResponse]> {
        
        let envelope = try await manager.request(
            OrdersApi.getOrderProducts(
                orderId: orderId,
                page: page,
                count: count,
                accessToken: accessToken
            )
        )
        
        return envelope.toPagedResult()
    }
    
    func placeOrder(
        sellerId: Int,
        comment: String,
        products: [OrderProductRequest],
        accessToken: String
    ) async throws -> OrderResponse {
        
        let envelope = try await manager.request(
            OrdersApi.placeOrder(
                sellerId: sellerId,
                comment: comment,
                products: products,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
}
