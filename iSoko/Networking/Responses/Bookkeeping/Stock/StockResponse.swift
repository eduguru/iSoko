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
    public let minimumOrderQuantity: Int?

    public let active: Bool?
    public let published: Bool?
    public let featured: Bool?
    public let inStock: Bool?

    public let category: IDNamePairInt?
    public let commodity: IDNamePairInt?
    public let measurementUnit: IDNamePairInt?

    public let trader: TraderResponse?

    public let images: [ImageResponse]   // keep non-optional but safe

    // MARK: - Decoder

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)

        price = try container.decodeIfPresent(Double.self, forKey: .price)
        minimumOrderQuantity = try container.decodeIfPresent(Int.self, forKey: .minimumOrderQuantity)

        active = try container.decodeIfPresent(Bool.self, forKey: .active)
        published = try container.decodeIfPresent(Bool.self, forKey: .published)
        featured = try container.decodeIfPresent(Bool.self, forKey: .featured)
        inStock = try container.decodeIfPresent(Bool.self, forKey: .inStock)

        category = try container.decodeIfPresent(IDNamePairInt.self, forKey: .category)
        commodity = try container.decodeIfPresent(IDNamePairInt.self, forKey: .commodity)
        measurementUnit = try container.decodeIfPresent(IDNamePairInt.self, forKey: .measurementUnit)

        trader = try container.decodeIfPresent(TraderResponse.self, forKey: .trader)

        // Always safe array
        images = try container.decodeIfPresent([ImageResponse].self, forKey: .images) ?? []
    }
}

public struct TraderResponse: Codable {
    public let id: Int?
    public let email: String?
    public let firstName: String?
    public let lastName: String?

    init(from model: CommonIdNameModel) {
        self.id = model.id
        self.email = model.description
        self.firstName = nil
        self.lastName = nil
    }
}

public struct ImageResponse: Codable {
    public let id: Int?
    public let url: String?
    public let approved: Bool?
    public let primary: Bool?
    public let active: Bool?
}
