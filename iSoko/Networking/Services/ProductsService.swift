//
//  ProductsService.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import NetworkingKit

public protocol ProductsService {
    // MARK: - Listings
    func getAllProducts(page: Int, count: Int, accessToken: String) async throws -> [ProductResponse]
    func getFeaturedProducts(page: Int, count: Int, accessToken: String) async throws -> [ProductResponse]
    func getProductsByCategory(page: Int, count: Int, categoryId: String, accessToken: String) async throws -> [ProductResponse]
    func getProductsByCurrentUser(page: Int, count: Int, accessToken: String) async throws -> [ProductResponse]
    func getProductDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> ProductResponse?
    func getProductOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> ProductOwnerResponse?

    // MARK: - Trader products
    func createProduct(product: CreateProductDto, accessToken: String) async throws -> ProductOwnerResponse?
    func updateProduct(productId: String, product: UpdateProductDto, accessToken: String) async throws -> ProductOwnerResponse?
    func addProductImages(uploadFile: [UploadFile], productId: String, accessToken: String) async throws -> ProductOwnerResponse?
    func removeProductImage(imageId: String, accessToken: String) async throws -> ProductOwnerResponse?
    func setProductPrimaryImage(imageId: String, accessToken: String) async throws -> ProductOwnerResponse?
    func updateProductStatus(status: String, productId: String, accessToken: String) async throws -> ProductOwnerResponse?
}

public final class ProductsServiceImpl: ProductsService {
    
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider

    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }

    public func getAllProducts(page: Int, count: Int, accessToken: String) async throws -> [ProductResponse] {
        try await manager.request(ProductsApi.getAllProducts(page: page, count: count, accessToken: accessToken)) ?? []
    }

    public func getFeaturedProducts(page: Int, count: Int, accessToken: String) async throws -> [ProductResponse] {
        try await manager.request(ProductsApi.getFeaturedProducts(page: page, count: count, accessToken: accessToken)) ?? []
    }

    public func getProductsByCategory(page: Int, count: Int, categoryId: String, accessToken: String) async throws -> [ProductResponse] {
        try await manager.request(ProductsApi.getProductsByCategory(page: page, count: count, categoryId: categoryId, accessToken: accessToken)) ?? []
    }

    public func getProductsByCurrentUser(page: Int, count: Int, accessToken: String) async throws -> [ProductResponse] {
        try await manager.request(ProductsApi.getProductsByCurrentUser(page: page, count: count, accessToken: accessToken)) ?? []
    }

    public func getProductDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> ProductResponse? {
        try await manager.request(ProductsApi.getProductDetails(page: page, count: count, productId: productId, accessToken: accessToken))
    }

    public func getProductOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.getProductOwnerDetails(page: page, count: count, productId: productId, accessToken: accessToken))
    }

    public func createProduct(product: CreateProductDto, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.createProduct(product: product, accessToken: accessToken))
    }

    public func updateProduct(productId: String, product: UpdateProductDto, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.updateProduct(productId: productId, product: product, accessToken: accessToken))
    }

    public func addProductImages(uploadFile: [UploadFile], productId: String, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.addProductImages(uploadFile: uploadFile, productId: productId, accessToken: accessToken))
    }

    public func removeProductImage(imageId: String, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.removeProductImage(imageId: imageId, accessToken: accessToken))
    }

    public func setProductPrimaryImage(imageId: String, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.setProductPrimaryImage(imageId: imageId, accessToken: accessToken))
    }

    public func updateProductStatus(status: String, productId: String, accessToken: String) async throws -> ProductOwnerResponse? {
        try await manager.request(ProductsApi.updateProductStatus(status: status, productId: productId, accessToken: accessToken))
    }
}
