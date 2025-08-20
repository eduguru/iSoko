//
//  TitleDescriptionFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class TitleDescriptionFormRow: FormRow {
    
    public let tag: Int
    public let reuseIdentifier: String = String(describing: TitleDescriptionFormCell.self)
    public var cellClass: AnyClass? { TitleDescriptionFormCell.self }
    
    public var title: String
    public var descriptionText: String
    
    public var maxTitleLines: Int
    public var maxDescriptionLines: Int
    
    public var titleEllipsis: EllipsisType
    public var descriptionEllipsis: EllipsisType
    
    public var layoutStyle: StackLayoutStyle
    public var textAlignment: NSTextAlignment
    
    public let rowType: FormRowType = .tableView
    
    public var titleFontStyle: FontStyle
    public var descriptionFontStyle: FontStyle
    
    public init(
        tag: Int,
        title: String,
        description: String,
        maxTitleLines: Int = 2,
        maxDescriptionLines: Int = 0, // 0 = unlimited lines
        titleEllipsis: EllipsisType = .tail,
        descriptionEllipsis: EllipsisType = .tail,
        layoutStyle: StackLayoutStyle = .stackedVertical,
        textAlignment: NSTextAlignment = .left,
        titleFontStyle: FontStyle = .headline,            // <- default font styles
        descriptionFontStyle: FontStyle = .subheadline    // <- default font styles
    ) {
        self.tag = tag
        self.title = title
        self.descriptionText = description
        self.maxTitleLines = maxTitleLines
        self.maxDescriptionLines = maxDescriptionLines
        self.titleEllipsis = titleEllipsis
        self.descriptionEllipsis = descriptionEllipsis
        self.layoutStyle = layoutStyle
        self.textAlignment = textAlignment
        self.titleFontStyle = titleFontStyle
        self.descriptionFontStyle = descriptionFontStyle
    }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? TitleDescriptionFormCell else {
            assertionFailure("Expected TitleDescriptionFormCell")
            return cell
        }
        
        let model = TitleDescriptionModel(
            title: title,
            description: descriptionText,
            maxTitleLines: maxTitleLines,
            maxDescriptionLines: maxDescriptionLines,
            titleEllipsis: titleEllipsis,
            descriptionEllipsis: descriptionEllipsis,
            layoutStyle: layoutStyle,
            textAlignment: textAlignment,
            titleFontStyle: titleFontStyle,
            descriptionFontStyle: descriptionFontStyle
        )
        
        cell.configure(with: model)
        
        return cell
    }

    
    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        // Return automatic dimension, let the tableView calculate height dynamically
        UITableView.automaticDimension
    }
    
    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
