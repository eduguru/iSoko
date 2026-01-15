//
//  RichDescriptionModel.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import DesignSystemKit
import UIKit

public struct RichDescriptionModel {
    public let title: String?
    public let htmlDescription: String

    public let maxTitleLines: Int
    public let titleFontStyle: FontStyle
    public let descriptionFontStyle: FontStyle
    public let textAlignment: NSTextAlignment

    public init(
        title: String? = nil,
        htmlDescription: String,
        maxTitleLines: Int = 2,
        titleFontStyle: FontStyle = .headline,
        descriptionFontStyle: FontStyle = .body,
        textAlignment: NSTextAlignment = .left
    ) {
        self.title = title
        self.htmlDescription = htmlDescription
        self.maxTitleLines = maxTitleLines
        self.titleFontStyle = titleFontStyle
        self.descriptionFontStyle = descriptionFontStyle
        self.textAlignment = textAlignment
    }
}
