//
//  TransactionCellConfig.swift
//  
//
//  Created by Edwin Weru on 22/01/2026.
//

import UIKit

public struct TransactionCellConfig {

    public let image: UIImage?
    public let imageSize: CGSize
    public let imageStyle: TransactionImageStyle

    public let title: String
    public let description: String?

    public let amount: String
    public let amountColor: UIColor

    public let spacing: CGFloat
    public let contentInsets: UIEdgeInsets
    public let onTap: (() -> Void)?

    public let isCardStyleEnabled: Bool
    public let cardCornerRadius: CGFloat
    public let cardBackgroundColor: UIColor
    public let cardBorderColor: UIColor
    public let cardBorderWidth: CGFloat
}

public struct TransactionImageStyle {

    public enum Shape {
        case square
        case circle
        case rounded(CGFloat)
    }

    public let shape: Shape
    public let backgroundColor: UIColor?
    public let inset: CGFloat

    public init(
        shape: Shape = .circle,
        backgroundColor: UIColor? = nil,
        inset: CGFloat = 4
    ) {
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.inset = inset
    }
}
