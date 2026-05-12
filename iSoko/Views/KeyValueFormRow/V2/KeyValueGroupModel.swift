//
//  KeyValueGroupModel.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

public struct KeyValueGroupModel {

    public let sectionTitle: String?
    public let card: CardSettings?
    public let rows: [KeyValueRowModel]

    public init(
        sectionTitle: String? = nil,
        card: CardSettings? = nil,
        rows: [KeyValueRowModel]
    ) {
        self.sectionTitle = sectionTitle
        self.card = card
        self.rows = rows
    }
}
