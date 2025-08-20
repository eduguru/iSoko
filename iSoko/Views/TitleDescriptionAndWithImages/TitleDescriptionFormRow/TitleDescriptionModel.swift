//
//  TitleDescriptionModel.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit
import DesignSystemKit

public struct TitleDescriptionModel {
    public var title: String
    public var description: String
    public var maxTitleLines: Int
    public var maxDescriptionLines: Int
    public var titleEllipsis: EllipsisType
    public var descriptionEllipsis: EllipsisType
    public var layoutStyle: StackLayoutStyle
    public var textAlignment: NSTextAlignment
    public var titleFontStyle: FontStyle
    public var descriptionFontStyle: FontStyle
    
    public init(
        title: String,
        description: String,
        maxTitleLines: Int = 2,
        maxDescriptionLines: Int = 0,
        titleEllipsis: EllipsisType = .tail,
        descriptionEllipsis: EllipsisType = .tail,
        layoutStyle: StackLayoutStyle = .stackedVertical,
        textAlignment: NSTextAlignment = .left,
        titleFontStyle: FontStyle = .headline,
        descriptionFontStyle: FontStyle = .subheadline
    ) {
        self.title = title
        self.description = description
        self.maxTitleLines = maxTitleLines
        self.maxDescriptionLines = maxDescriptionLines
        self.titleEllipsis = titleEllipsis
        self.descriptionEllipsis = descriptionEllipsis
        self.layoutStyle = layoutStyle
        self.textAlignment = textAlignment
        self.titleFontStyle = titleFontStyle
        self.descriptionFontStyle = descriptionFontStyle
    }
}
