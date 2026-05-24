//
//  OrdersService.swift
//
//
//  Created by Edwin Weru on 21/05/2026.
//

import NetworkingKit

public protocol OrdersService {
    
    func getOrderSummary(userId: Int, accessToken: String) async throws -> StatisticsResponse
    
    func getAllOrders(
        page: Int,
        count: Int,
        traderType: String,
        accessToken: String
    ) async throws -> PagedResult<[CustomerOrderResponse]>
    
    func getOrderProducts(
        orderId: Int,
        page: Int,
        count: Int,
        accessToken: String
    ) async throws -> [OrderProductResponse]
    
    func placeOrder(
        sellerId: Int,
        comment: String,
        products: [OrderProductRequest],
        accessToken: String
    ) async throws -> OrderResponse
    
    func getOrderById(
        orderId: Int,
        accessToken: String
    ) async throws -> OrderResponse
    
    func updateOrderStatus(
        orderId: Int,
        status: String,
        accessToken: String
    ) async throws -> OrderResponse
    
    func addProductToOrder(
        orderId: Int,
        productId: Int,
        quantity: Int,
        accessToken: String
    ) async throws -> OrderResponse
    
    func updateOrderProduct(
        orderId: Int,
        productId: Int,
        quantity: Int,
        accessToken: String
    ) async throws -> OrderResponse
    
    func deleteOrderProduct(
        orderId: Int,
        productId: Int,
        accessToken: String
    ) async throws -> AnyCodable
    
    func addOrderRating(
        orderId: Int,
        rating: Double,
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
    ) async throws -> [OrderProductResponse] {
        
        let envelope = try await manager.request(
            OrdersApi.getOrderProducts(
                orderId: orderId,
                page: page,
                count: count,
                accessToken: accessToken
            )
        )
        
        return envelope
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


// MARK: - Orders
public extension OrdersServiceImpl {
    
    func getOrderById(
        orderId: Int,
        accessToken: String
    ) async throws -> OrderResponse {
        
        let envelope = try await manager.request(
            OrdersApi.getOrderById(
                orderId: orderId,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
    
    func updateOrderStatus(
        orderId: Int,
        status: String,
        accessToken: String
    ) async throws -> OrderResponse {
        
        let envelope = try await manager.request(
            OrdersApi.updateOrderStatus(
                orderId: orderId,
                status: status,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
    
    func addProductToOrder(
        orderId: Int,
        productId: Int,
        quantity: Int,
        accessToken: String
    ) async throws -> OrderResponse {
        
        let envelope = try await manager.request(
            OrdersApi.addProductToOrder(
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
    
    func updateOrderProduct(
        orderId: Int,
        productId: Int,
        quantity: Int,
        accessToken: String
    ) async throws -> OrderResponse {
        
        let envelope = try await manager.request(
            OrdersApi.updateOrderProduct(
                orderId: orderId,
                productId: productId,
                quantity: quantity,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
    
    func deleteOrderProduct(
        orderId: Int,
        productId: Int,
        accessToken: String
    ) async throws -> AnyCodable {
        
        let envelope = try await manager.request(
            OrdersApi.deleteOrderProduct(
                orderId: orderId,
                productId: productId,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
    
    func addOrderRating(
        orderId: Int,
        rating: Double,
        accessToken: String
    ) async throws -> OrderResponse {
        
        let envelope = try await manager.request(
            OrdersApi.addOrderRating(
                orderId: orderId,
                rating: rating,
                accessToken: accessToken
            )
        )
        
        return envelope
    }
}
