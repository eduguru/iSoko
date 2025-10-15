//
//  ServicesService.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import NetworkingKit

public protocol ServicesService {
    //MARK: - listings
    func getAllTradeServiceCategories(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceCategoryResponse]
    
    func getAllTradeServices(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceResponse]
    
    func getFeaturedTradeServices(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceResponse]
    
    func getTradeServicesByCategory(page: Int, count: Int, categoryId: String, accessToken: String) async throws -> [TradeServiceCategoryResponse]
    
    func getTradeServicesByCurrentUser(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceResponse]
    
    func getTradeServiceDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> TradeServiceResponse?
    
    func getTradeServiceOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> TradeServiceOwnerResponse?

    //MARK: - trader TradeServices
    func createService(product: CreateProductDto, accessToken: String) async throws -> TradeServiceResponse?
    
    func updateTradeService(productId: String, product: UpdateProductDto, accessToken: String) async throws -> TradeServiceResponse?
    
    func addTradeServiceImages(uploadFile: [UploadFile], productId: String, accessToken: String) async throws -> TradeServiceResponse?
    
    func removeTradeServiceImage(imageId: String, accessToken: String) async throws -> TradeServiceResponse?
    
    func setTradeServicePrimaryImage(imageId: String, accessToken: String) async throws -> TradeServiceResponse?
    
    func updateTradeServiceStatus(status: String, productId: String, accessToken: String) async throws -> TradeServiceResponse?
    
}


public final class ServicesServiceImpl: ServicesService {
    
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
    public func getAllTradeServiceCategories(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceCategoryResponse] {
        let response: [TradeServiceCategoryResponse] = try await manager.request(ServicesApi.getAllTradeServiceCategories(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getAllTradeServices(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceResponse] {
        let response: [TradeServiceResponse] = try await manager.request(ServicesApi.getAllTradeServices(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getFeaturedTradeServices(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceResponse] {
        let response: [TradeServiceResponse] = try await manager.request(ServicesApi.getFeaturedTradeServices(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getTradeServicesByCategory(page: Int, count: Int, categoryId: String, accessToken: String) async throws -> [TradeServiceCategoryResponse] {
        let response: [TradeServiceCategoryResponse] = try await manager.request(ServicesApi.getTradeServicesByCategory(page: page, count: count, categoryId: categoryId, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getTradeServicesByCurrentUser(page: Int, count: Int, accessToken: String) async throws -> [TradeServiceResponse] {
        let response: [TradeServiceResponse] = try await manager.request(ServicesApi.getTradeServicesByCurrentUser(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getTradeServiceDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.getTradeServiceDetails(page: page, count: count, productId: productId, accessToken: accessToken))
        
        return response
    }
    
    public func getTradeServiceOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> TradeServiceOwnerResponse? {
        let response: TradeServiceOwnerResponse? = try await manager.request(ServicesApi.getTradeServiceOwnerDetails(page: page, count: count, productId: productId, accessToken: accessToken))
        
        return response
    }
    
    public func createService(product: CreateProductDto, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.createService(product: product, accessToken: accessToken))
        
        return response
    }
    
    public func updateTradeService(productId: String, product: UpdateProductDto, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.updateTradeService(productId: productId, product: product, accessToken: accessToken))
        
        return response
    }
    
    public func addTradeServiceImages(uploadFile: [NetworkingKit.UploadFile], productId: String, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.addTradeServiceImages(uploadFile: uploadFile, productId: productId, accessToken: accessToken))
        
        return response
    }
    
    public func removeTradeServiceImage(imageId: String, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.removeTradeServiceImage(imageId: imageId, accessToken: accessToken))
        
        return response
    }
    
    public func setTradeServicePrimaryImage(imageId: String, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.setTradeServicePrimaryImage(imageId: imageId, accessToken: accessToken))
        
        return response
    }
    
    public func updateTradeServiceStatus(status: String, productId: String, accessToken: String) async throws -> TradeServiceResponse? {
        let response: TradeServiceResponse? = try await manager.request(ServicesApi.updateTradeServiceStatus(status: status, productId: productId, accessToken: accessToken))
        
        return response
    }
}
