//
//  CommonUtilitiesApi.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

import Moya
import Foundation
import NetworkingKit

public struct CommonUtilitiesApi {
    
    //MARK: - locations
    public static func getAllLocations(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[LocationResponse]> {
        let parameters: [String: Any] = ["page": page, "size": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "location",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getLocationLevels(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[LocationLevelsResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "location-level",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getLocationsByLevel(page: Int, count: Int, locationLevel: String, accessToken: String) -> OptionalObjectResponseTarget<[LocationResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "location/\(locationLevel)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    //MARK: - Measurement
    
    public static func getMeasurementMetrics(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[MeasurementMetricResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/measurement-metric",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getMeasurementUnits(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[MeasurementUnitResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/measurement-unit",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    //MARK: - Organisation
    
    public static func getOrganisationType(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[OrganisationTypeResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/organisation-type",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getOrganisationSize(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[OrganisationSizeResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/organisation-size",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    
    //MARK: - Common (user - roles - gender)
    
    public static func getUserAgeGroups( accessToken: String) -> OptionalObjectResponseTarget<[CommonIdNameResponse]> {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user-age-group",
            method: .get,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getUserTypes(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[CommonIdNameResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user-type",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getUserRoles(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[CommonIdNameResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/roles",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getUserGender(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[CommonIdNameResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/gender",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    
    //MARK: - Commodities
    
    public static func getCommodityCategory(page: Int, count: Int, module: String, accessToken: String) -> OptionalObjectResponseTarget<[CommodityCategoryResponse]> {
        let parameters: [String: Any] = [
            "page": page,
            "count": count,
            "module": module
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/commodity-category",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getCommoditySubCategory(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[CommoditySubCategoryResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/commodity-sub-category",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getCommodities(
        page: Int,
        count: Int,
        module: String,
        categoryId: String,
        subCategoryId: String,
        accessToken: String
    ) -> OptionalObjectResponseTarget<[CommodityResponse]> {
        let parameters: [String: Any] = [
            "page": page,
            "count": count,
            "module": module,
            "categoryId": categoryId,
            "subCategoryId": subCategoryId
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/commodity",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
}
