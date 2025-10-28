//
//  ServicesApi.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import Foundation
import Moya
import NetworkingKit

public struct ServicesApi {
    
    //MARK: - listings
    public static func getAllTradeServiceCategories(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[TradeServiceCategoryResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service-category",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getAllTradeServices(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[TradeServiceResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getFeaturedTradeServices(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[TradeServiceResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count, "isFeatured": "active"]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getTradeServicesByCategory(page: Int, count: Int, categoryId: String, accessToken: String) -> OptionalObjectResponseTarget<[TradeServiceResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count, "categoryId": categoryId]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getTradeServicesByCurrentUser(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[TradeServiceResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/current-user",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getTradeServiceDetails(page: Int, count: Int, productId: String, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/product-details/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getTradeServiceOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceOwnerResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/product-details/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }

    //MARK: - trader TradeServices
    public static func createService(product: CreateProductDto, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func updateTradeService(productId: String, product: UpdateProductDto, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = product.asDictionary

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/edit/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func addTradeServiceImages(uploadFile: [UploadFile], productId: String, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/image/add/\(productId)",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func removeTradeServiceImage(imageId: String, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/image/remove/\(imageId)",
            method: .put,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func setTradeServicePrimaryImage(imageId: String, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/image/set-primary/\(imageId)",
            method: .put,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func updateTradeServiceStatus(status: String, productId: String, accessToken: String) -> OptionalObjectResponseTarget<TradeServiceResponse> {
        let parameters: [String: Any] = ["status": status]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/market-service/update-status/\(status)/\(productId)",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
}
