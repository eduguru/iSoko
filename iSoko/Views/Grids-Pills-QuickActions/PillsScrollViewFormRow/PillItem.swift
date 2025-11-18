//
//  PillItem.swift
//  
//
//  Created by Edwin Weru on 17/11/2025.
//

import UIKit

public struct PillItem {
    public let id: String
    public let title: String

    public var isSelected: Bool = false

    public let backgroundColor: UIColor
    public let selectedBackgroundColor: UIColor

    public let textColor: UIColor
    public let selectedTextColor: UIColor

    public let borderColor: UIColor
    public let selectedBorderColor: UIColor

    public let font: UIFont
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat

    public init(
        id: String,
        title: String,
        isSelected: Bool = false,
        backgroundColor: UIColor = .systemGray5,
        selectedBackgroundColor: UIColor = .systemBlue,
        textColor: UIColor = .label,
        selectedTextColor: UIColor = .white,
        borderColor: UIColor = .clear,
        selectedBorderColor: UIColor = .systemBlue,
        font: UIFont = .systemFont(ofSize: 14),
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 12
    ) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.borderColor = borderColor
        self.selectedBorderColor = selectedBorderColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
    }
}
