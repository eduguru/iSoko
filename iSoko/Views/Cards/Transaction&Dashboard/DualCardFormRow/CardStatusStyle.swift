//
//  CardStatusStyle.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public struct CardStatusStyle {
    public let text: String
    public let textColor: UIColor
    public let backgroundColor: UIColor
    public let icon: UIImage?

    public init(
        text: String,
        textColor: UIColor = .label,
        backgroundColor: UIColor = .systemGray6,
        icon: UIImage? = nil
    ) {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.icon = icon
    }
}
