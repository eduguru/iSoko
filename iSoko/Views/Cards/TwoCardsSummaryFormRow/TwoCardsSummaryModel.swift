//
//  TwoCardsSummaryModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

public struct TwoCardsSummaryModel {
    let title: String?
    let description: String?
    let leftCard: SummaryCardModel?
    let rightCard: SummaryCardModel?
}

public struct SummaryCardModel {

    let image: UIImage?
    let title: String?

    // Styling
    let backgroundColor: UIColor?
    let cornerRadius: CGFloat?
    let isHidden: Bool?

    // Tap callback
    let onTap: (() -> Void)?

    init(
        image: UIImage? = nil,
        title: String? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        isHidden: Bool? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.image = image
        self.title = title
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.isHidden = isHidden
        self.onTap = onTap
    }
}
