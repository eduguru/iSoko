//
//  ProductResponse.swift
//
//
//  Created by Edwin Weru on 28/08/2025.
//

public struct ProductResponse: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let minimumOrderQuantity: Int?
    let commodityId: Int?
    let categoryId: Int?
    let subCategoryId: Int?
    let commodityName: String?
    let categoryName: String?
    let subCategoryName: String?
    let measurementUnit: String?
    let measurementUnitId: Int?
    let measurementMetric: String?
    let measurementMetricId: Int?
    let primaryImage: String?
    let traderId: Int?
    let traderName: String?
    let traderVerified:  Bool?
    let locationName: String?
    let isInStock:  Bool?
    let isFeatured:  Bool?
    let discountId: String?
    let discountPrice: String?
    let discountPromoMessage: String?
    let discountUntilDate: String?
    let price: Double?
    
    //MARK: this are additional when you request product based on current user(logged in)
    let measurementMetricIdlet: Int?
    let language: String?
    let isPostToInventory:  Bool?
    let isUpdateSales:  Bool?
    let isApproved:  Bool?
    let dateAdded: Int?
    let isPublished:  Bool?
    let isActive:  Bool?
    let images: [String]?
}


public struct ProductResponseV1: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    
    let category: CategoryV1?
    let commodity: CommodityV1?
    let measurementUnit: MeasurementUnitV1?
    
    let price: Double?
    let minimumOrderQuantity: Int?
    
    let inStock: Bool?
    let published: Bool?
    let featured: Bool?
    let active: Bool?
    
    let trader: TraderV1?
    let images: [ProductImageV1]?
}

// MARK: - Category
public struct CategoryV1: Decodable {
    let id: Int?
    let name: String?
}

// MARK: - Commodity
public struct CommodityV1: Decodable {
    let id: Int?
    let name: String?
}

// MARK: - Measurement Unit
public struct MeasurementUnitV1: Decodable {
    let id: Int?
    let name: String?
}

// MARK: - Trader
public struct TraderV1: Decodable {
    let id: Int?
    let email: String?
    let firstName: String?
    let lastName: String?
}

// MARK: - Product Image
public struct ProductImageV1: Decodable {
    let id: Int?
    let url: String?
    let primary: Bool?
    let active: Bool?
    let approved: Bool?
}

extension ProductResponseV1 {
    
    var traderFullName: String? {
        guard let first = trader?.firstName, let last = trader?.lastName else { return nil }
        return "\(first) \(last)"
    }
    
    var primaryImageURL: String? {
        
        // Only valid images
        let validImages = images?.filter {
            $0.active == true && $0.url != nil
        }

        // 1. (primary)
        if let primary = validImages?.first(where: { $0.primary == true })?.url {
            return primary
        }

        // 2. fallback
        return validImages?.first?.url
    }
    
    var allImageURLs: [String] {
        images?
            .filter { $0.active == true }
            .compactMap { $0.url }
        ?? []
    }
    
    var categoryName: String? {
        category?.name
    }
}
