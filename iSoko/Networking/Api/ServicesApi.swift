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
    // MARK: - v1 endpoints (API spec): /market-service-categories and /market-services

    /// GET /v1/market-service-categories
    public static func getAllTradeServiceCategories(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[TradeServiceCategoryResponse]> {
        marketList(path: "market-service-categories", parameters: ["page": page, "size": count])
    }

    /// GET /v1/market-services
    public static func getAllTradeServices(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[MarketServiceResponse]> {
        marketList(path: "market-services", parameters: ["page": page, "size": count])
    }

    /// GET /v1/market-services — featured only.
    public static func getFeaturedTradeServices(page: Int, count: Int, accessToken: String) -> UnifiedPagedResponseTarget<[MarketServiceResponse]> {
        marketList(path: "market-services", parameters: ["page": page, "size": count, "featured": true])
    }

    /// GET /v1/market-services — the spec only documents page/size/sort/q here, so the
    /// category filter is sent flat (like /products does) and is not yet verified server-side.
    public static func getTradeServicesByCategory(page: Int, count: Int, categoryId: String, accessToken: String) -> UnifiedPagedResponseTarget<[MarketServiceResponse]> {
        marketList(path: "market-services", parameters: ["page": page, "size": count, "categoryId": categoryId])
    }

    private static func marketList<Payload: Decodable>(path: String, parameters: [String: Any]) -> UnifiedPagedResponseTarget<Payload> {
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: path,
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ],
            authorizationType: .bearer
        )
        return UnifiedPagedResponseTarget(target: target)
    }
    
    public static func getTradeServicesByCurrentUser(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[TradeServiceResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "api/market-service/edit/\(productId)",
            method: .patch,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
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
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.apiBaseURL,
            path: "api/market-service/update-status/\(status)/\(productId)",
            method: .patch,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
}


public extension ServicesApi {
    
    static func getServiceProviderTypes(accessToken: String) -> OptionalObjectResponseTarget<[ServiceProviderTypesResponse]> {
        let parameters: [String: Any] = ["": ""]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/service-providers-type/all",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    static func getServiceProviders(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ServiceProviderResponse]> {
        let parameters: [String: Any] = [
            "page": page,
            "size": count,
            "count": count
        ]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/service-providers/all",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    static func getLogisticsServiceProviders(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[LogisitcisServiceProviderResponse]> {
        let parameters: [String: Any] = [
            "page": page,
            "size": count,
            "count": count
        ]

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            // "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/logistics-provider",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .none
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
}
