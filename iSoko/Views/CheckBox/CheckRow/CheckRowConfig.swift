//
//  CheckRowConfig.swift
//  
//
//  Created by Edwin Weru on 10/07/2026.
//

import UIKit

public struct CheckRowConfig {
    public var isChecked: Bool
    public var title: String
    public var onToggle: ((Bool) -> Void)?

    public var checkboxTintColor: UIColor
    public var textColor: UIColor
    public var font: UIFont

    public var useCardStyle: Bool
    public var cardBackgroundColor: UIColor

    public init(
        isChecked: Bool = false,
        title: String,
        onToggle: ((Bool) -> Void)? = nil,
        checkboxTintColor: UIColor = .app(.primary),
        textColor: UIColor = .label,
        font: UIFont = .preferredFont(forTextStyle: .body),
        useCardStyle: Bool = false,
        cardBackgroundColor: UIColor = .secondarySystemGroupedBackground
    ) {
        self.isChecked = isChecked
        self.title = title
        self.onToggle = onToggle
        self.checkboxTintColor = checkboxTintColor
        self.textColor = textColor
        self.font = font
        self.useCardStyle = useCardStyle
        self.cardBackgroundColor = cardBackgroundColor
    }
}
