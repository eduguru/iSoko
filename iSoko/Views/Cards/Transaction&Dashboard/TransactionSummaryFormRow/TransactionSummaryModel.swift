//
//  TransactionSummaryModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

public struct TransactionSummaryModel {

    // Content
    let image: UIImage?
    let title: String?
    let callout: String?
    let description: String?

    // Styling
    let backgroundColor: UIColor?
    let cornerRadius: CGFloat?
    let isHidden: Bool?

    // Tap callback
    let onTap: (() -> Void)?

    init(
        image: UIImage? = nil,
        title: String? = nil,
        callout: String? = nil,
        description: String? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        isHidden: Bool? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.image = image
        self.title = title
        self.callout = callout
        self.description = description
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.isHidden = isHidden
        self.onTap = onTap
    }
}
