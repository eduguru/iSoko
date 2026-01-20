//
//  TwoCardsModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

public struct TwoCardsModel {
    let leftCard: CardModel?
    let rightCard: CardModel?
}

public struct CardModel {

    // Header
    let title: String?
    let titleIcon: UIImage?

    // Description
    let description: String?

    // Inner status card
    let statusModel: StatusCardViewModel?

    // Styling
    let backgroundColor: UIColor?
    let isHidden: Bool?

    // Tap callback
    let onTap: (() -> Void)?

    init(
        title: String? = nil,
        titleIcon: UIImage? = nil,
        description: String? = nil,
        statusModel: StatusCardViewModel? = nil,
        backgroundColor: UIColor? = nil,
        isHidden: Bool? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.titleIcon = titleIcon
        self.description = description
        self.statusModel = statusModel
        self.backgroundColor = backgroundColor
        self.isHidden = isHidden
        self.onTap = onTap
    }
}

