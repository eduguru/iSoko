//
//  TwoCardsSummaryModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

public struct TwoCardsSummaryViewModel {

    let title: String?
    let description: String?
    let cards: TwoStatusCardsViewModel

    init(
        title: String? = nil,
        description: String? = nil,
        cards: TwoStatusCardsViewModel
    ) {
        self.title = title
        self.description = description
        self.cards = cards
    }
}
