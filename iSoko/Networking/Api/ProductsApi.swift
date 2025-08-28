//
//  ProductsApi.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import Foundation
import Moya

public struct ProductsApi {
    
    //MARK: - products lisitings
    public static func getAllProducts(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getFeaturedProducts(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count, "isFeatured": "active"]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductsByCategory(page: Int, count: Int, categoryId: String, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count, "categoryId": categoryId]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductsByCurrentUser(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/current-user",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductDetails(page: Int, count: Int, productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/product-details/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/product-trader-details/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }

    //MARK: - trader products
    public static func createProduct(product: CreateProductDto, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func updateProduct(productId: String, product: UpdateProductDto, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = product.asDictionary

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/edit/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func addProductImages(uploadFile: [UploadFile], productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/image/add/\(productId)",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func removeProductImage(imageId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/image/remove/\(imageId)",
            method: .put,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func setProductPrimaryImage(imageId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/image/set-primary/\(imageId)",
            method: .put,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func updateProductStatus(status: String, productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = ["status": status]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            path: "api/product/update-status/\(status)/\(productId)",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
}
