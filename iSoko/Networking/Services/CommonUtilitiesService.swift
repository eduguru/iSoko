//
//  CommonUtilitiesService.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

import NetworkingKit

public protocol CommonUtilitiesService {
    //MARK: - locations
    func getAllLocations(page: Int, count: Int, accessToken: String) async throws -> [LocationResponse]
    func getLocationLevels(page: Int, count: Int, accessToken: String) async throws -> [LocationLevelsResponse]
    func getLocationsByLevel(page: Int, count: Int, locationLevel: String, accessToken: String) async throws -> [LocationResponse]
    
    //MARK: - Measurement
    func getMeasurementMetrics(page: Int, count: Int, accessToken: String) async throws -> [MeasurementMetricResponse]
    func getMeasurementUnits(page: Int, count: Int, accessToken: String) async throws -> [MeasurementUnitResponse]
    
    //MARK: - Organisation
    func getOrganisationType(page: Int, count: Int, accessToken: String) async throws -> [OrganisationTypeResponse]
    func getOrganisationSize(page: Int, count: Int, accessToken: String) async throws -> [OrganisationSizeResponse]
    
    
    //MARK: - Common (user - roles - gender)
    func getUserAgeGroups( accessToken: String) async throws -> [CommonIdNameResponse]
    func getUserTypes(page: Int, count: Int, accessToken: String) async throws -> [CommonIdNameResponse]
    func getUserRoles(page: Int, count: Int, accessToken: String) async throws -> [CommonIdNameResponse]
    func getUserGender(page: Int, count: Int, accessToken: String) async throws -> [CommonIdNameResponse]
    
    
    //MARK: - Commodities
    func getCommodityCategory(page: Int, count: Int, module: String, accessToken: String) async throws -> [CommodityCategoryResponse]
    func getCommoditySubCategory(page: Int, count: Int, accessToken: String) async throws -> [CommoditySubCategoryResponse]
    
    func getCommodities(
        page: Int,
        count: Int,
        module: String,
        categoryId: String,
        subCategoryId: String,
        accessToken: String
    ) async throws -> [CommodityResponse]
    
}

public final class CommonUtilitiesServiceImpl: CommonUtilitiesService {
    private let manager: NetworkManager<AnyTarget>
    private let tokenProvider: RefreshableTokenProvider
    
    public init(provider: NetworkProvider, tokenProvider: RefreshableTokenProvider) {
        self.manager = provider.manager()
        self.tokenProvider = tokenProvider
    }
    
//    public func getAllLocations(page: Int, count: Int, accessToken: String) async throws -> [LocationResponse] {
//        let response: NewPagedResponse<[LocationResponse]> =
//            try await manager.request(
//                CommonUtilitiesApi.getAllLocations(page: page, count: count, accessToken: accessToken)
//            )
//
//        return response.data
//    }
    
//    public func getAllLocations(page: Int, count: Int, accessToken: String) async throws -> PagedResult<[LocationResponse]> {
//        let response: NewPagedResponse<[LocationResponse]> =
//            try await manager.request(CommonUtilitiesApi.getAllLocations(page: page, count: count, accessToken: accessToken))
//
//        return PagedResult(
//            data: response.data,
//            page: response.page.number,
//            size: response.page.size,
//            totalPages: response.page.totalPages,
//            totalElements: response.page.totalElements
//        )
//    }
    
    public func getAllLocations(page: Int, count: Int, accessToken: String) async throws -> [LocationResponse] {

        let response: UnifiedPagedEnvelope<[LocationResponse]> =
            try await manager.request(
                CommonUtilitiesApi.getAllLocations(page: page, count: count, accessToken: accessToken)
            )

        switch response {
        case .old(let data):
            return data

        case .new(let data, _):
            return data
        }
    }
    
    public func getAllLocationsPaged(page: Int, count: Int, accessToken: String) async throws -> PagedResult<[LocationResponse]> {

        let response: UnifiedPagedEnvelope<[LocationResponse]> =
            try await manager.request(CommonUtilitiesApi.getAllLocations(page: page, count: count, accessToken: accessToken))

        switch response {
        case .old(let data):
            return PagedResult(
                data: data,
                page: nil,
                size: nil,
                totalPages: nil,
                totalElements: nil
            )

        case .new(let data, let pageInfo):
            return PagedResult(
                data: data,
                page: pageInfo.number,
                size: pageInfo.size,
                totalPages: pageInfo.totalPages,
                totalElements: pageInfo.totalElements
            )
        }
    }

    
    public func getLocationLevels(page: Int, count: Int, accessToken: String) async throws -> [LocationLevelsResponse] {
        let response: [LocationLevelsResponse] = try await manager.request(CommonUtilitiesApi.getLocationLevels(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getLocationsByLevel(page: Int, count: Int, locationLevel: String, accessToken: String) async throws -> [LocationResponse] {
        let response: [LocationResponse] = try await manager.request(CommonUtilitiesApi.getLocationsByLevel(page: page, count: count, locationLevel: locationLevel, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getMeasurementMetrics(page: Int, count: Int, accessToken: String) async throws -> [MeasurementMetricResponse] {
        let response: [MeasurementMetricResponse] = try await manager.request(CommonUtilitiesApi.getMeasurementMetrics(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getMeasurementUnits(page: Int, count: Int, accessToken: String) async throws -> [MeasurementUnitResponse] {
        let response: [MeasurementUnitResponse] = try await manager.request(CommonUtilitiesApi.getMeasurementUnits(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getOrganisationType(page: Int, count: Int, accessToken: String) async throws -> [OrganisationTypeResponse] {
        let response: [OrganisationTypeResponse] = try await manager.request(CommonUtilitiesApi.getOrganisationType(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getOrganisationSize(page: Int, count: Int, accessToken: String) async throws -> [OrganisationSizeResponse] {
        let response: [OrganisationSizeResponse] = try await manager.request(CommonUtilitiesApi.getOrganisationSize(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getUserAgeGroups(accessToken: String) async throws -> [CommonIdNameResponse] {
        let response: [CommonIdNameResponse] = try await manager.request(CommonUtilitiesApi.getUserAgeGroups(accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getUserTypes(page: Int, count: Int, accessToken: String) async throws -> [CommonIdNameResponse] {
        let response: [CommonIdNameResponse] = try await manager.request(CommonUtilitiesApi.getUserTypes(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getUserRoles(page: Int, count: Int, accessToken: String) async throws -> [CommonIdNameResponse] {
        let response: [CommonIdNameResponse] = try await manager.request(CommonUtilitiesApi.getUserRoles(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getUserGender(page: Int, count: Int, accessToken: String) async throws -> [CommonIdNameResponse] {
        let response: [CommonIdNameResponse] = try await manager.request(CommonUtilitiesApi.getUserGender(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getCommodityCategory(page: Int, count: Int, module: String, accessToken: String) async throws -> [CommodityCategoryResponse] {
        let response: [CommodityCategoryResponse] = try await manager.request(CommonUtilitiesApi.getCommodityCategory(page: page, count: count, module: module, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getCommoditySubCategory(page: Int, count: Int, accessToken: String) async throws -> [CommoditySubCategoryResponse] {
        let response: [CommoditySubCategoryResponse] = try await manager.request(CommonUtilitiesApi.getCommoditySubCategory(page: page, count: count, accessToken: accessToken)) ?? []
        
        return response
    }
    
    public func getCommodities(page: Int, count: Int, module: String, categoryId: String, subCategoryId: String, accessToken: String) async throws -> [CommodityResponse] {
        let response: [CommodityResponse] = try await manager.request(CommonUtilitiesApi.getCommodities(page: page, count: count, module: module, categoryId: categoryId, subCategoryId: subCategoryId, accessToken: accessToken)) ?? []
        
        return response
    }
}
