//
//  StatusCardModel.swift
//  
//
//  Created by Edwin Weru on 11/05/2026.
//

import UIKit

public struct StatusCardModel {

    public let title: String
    public let subtitle: String?
    
    public let statusText: String
    public let statusStyle: StatusStyle

    public let card: CardSettings?

    public init(
        title: String,
        subtitle: String? = nil,
        statusText: String,
        statusStyle: StatusStyle,
        card: CardSettings? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.statusText = statusText
        self.statusStyle = statusStyle
        self.card = card
    }
}

public struct StatusStyle {
    public let textColor: UIColor
    public let backgroundColor: UIColor
    public let borderColor: UIColor?

    public init(textColor: UIColor,
                backgroundColor: UIColor,
                borderColor: UIColor? = nil) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
    }
}
