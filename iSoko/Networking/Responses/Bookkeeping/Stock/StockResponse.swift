//
//  StockResponse.swift
//
//
//  Created by Edwin Weru on 25/03/2026.
//

public struct StockResponse: Codable {

    public let id: Int?
    public let name: String?
    public let description: String?

    public let price: Double?
    public let stockPrice: Double?

    public let quantity: Int?
    public let minimumOrderQuantity: Int?
    public let lowStockThreshold: Int?

    public let active: Bool?
    public let approved: Bool?
    public let published: Bool?
    public let featured: Bool?
    public let inStock: Bool?
    public let bookkeepingStock: Bool?

    public let datetimeCreated: String?
    public let lastModified: String?

    public let category: IDNamePairInt?
    public let commodity: IDNamePairInt?
    public let measurementUnit: IDNamePairInt?
    public let supplier: IDNamePairInt?

    public let trader: TraderResponse?

    public let images: [ImageResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case stockPrice
        case quantity
        case minimumOrderQuantity
        case lowStockThreshold
        case active
        case approved
        case published
        case featured
        case inStock
        case bookkeepingStock
        case datetimeCreated
        case lastModified
        case category
        case commodity
        case measurementUnit
        case supplier     
        case trader
        case images
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)

        price = try container.decodeIfPresent(Double.self, forKey: .price)
        stockPrice = try container.decodeIfPresent(Double.self, forKey: .stockPrice)

        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        minimumOrderQuantity = try container.decodeIfPresent(Int.self, forKey: .minimumOrderQuantity)
        lowStockThreshold = try container.decodeIfPresent(Int.self, forKey: .lowStockThreshold)

        active = try container.decodeIfPresent(Bool.self, forKey: .active)
        approved = try container.decodeIfPresent(Bool.self, forKey: .approved)
        published = try container.decodeIfPresent(Bool.self, forKey: .published)
        featured = try container.decodeIfPresent(Bool.self, forKey: .featured)
        inStock = try container.decodeIfPresent(Bool.self, forKey: .inStock)
        bookkeepingStock = try container.decodeIfPresent(Bool.self, forKey: .bookkeepingStock)

        datetimeCreated = try container.decodeIfPresent(String.self, forKey: .datetimeCreated)
        lastModified = try container.decodeIfPresent(String.self, forKey: .lastModified)

        category = try container.decodeIfPresent(IDNamePairInt.self, forKey: .category)
        commodity = try container.decodeIfPresent(IDNamePairInt.self, forKey: .commodity)
        measurementUnit = try container.decodeIfPresent(IDNamePairInt.self, forKey: .measurementUnit)
        supplier = try container.decodeIfPresent(IDNamePairInt.self, forKey: .supplier) // <-- Added

        trader = try container.decodeIfPresent(TraderResponse.self, forKey: .trader)

        images = try container.decodeIfPresent([ImageResponse].self, forKey: .images) ?? []
    }
}

extension StockResponse {
    init(
        id: Int,
        name: String?,
        price: Double?
    ) {
        self.id = id
        self.name = name
        self.description = nil

        self.price = price
        self.stockPrice = nil

        self.quantity = nil
        self.minimumOrderQuantity = nil
        self.lowStockThreshold = nil

        self.active = nil
        self.approved = nil
        self.published = nil
        self.featured = nil
        self.inStock = nil
        self.bookkeepingStock = nil

        self.datetimeCreated = nil
        self.lastModified = nil

        self.category = nil
        self.commodity = nil
        self.measurementUnit = nil
        self.supplier = nil

        self.trader = nil
        self.images = []
    }
}

public struct TraderResponse: Codable {
    public let id: Int?
    public let email: String?
    public let firstName: String?
    public let lastName: String?
    public let phoneNumber: String?
    public let location: IDNamePairInt?

    init(from model: CommonIdNameModel) {
        self.id = model.id
        self.email = model.description
        self.firstName = nil
        self.lastName = nil
        self.phoneNumber = nil
        self.location = nil
    }
}

public struct ImageResponse: Codable {
    public let id: Int?
    public let url: String?
    public let approved: Bool?
    public let primary: Bool?
    public let active: Bool?
}
