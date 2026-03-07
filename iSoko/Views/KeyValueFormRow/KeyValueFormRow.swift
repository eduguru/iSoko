//
//  KeyValueFormRow.swift
//  
//
//  Created by Edwin Weru on 05/03/2026.
//

import DesignSystemKit
import UIKit

public final class KeyValueFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier: String = String(describing: KeyValueFormCell.self)
    public var cellClass: AnyClass? { KeyValueFormCell.self }

    public let rowType: FormRowType = .tableView

    public var leftText: String
    public var rightText: String

    public var leftFontStyle: FontStyle
    public var rightFontStyle: FontStyle

    public var leftColor: UIColor?
    public var rightColor: UIColor?

    public var maxLeftLines: Int
    public var maxRightLines: Int

    public var leftEllipsis: EllipsisType
    public var rightEllipsis: EllipsisType

    public var showsCard: Bool
    public var showsTopDivider: Bool
    public var showsBottomDivider: Bool
    public var isEmphasized: Bool
    public var usesMonospacedDigits: Bool

    public init(
        tag: Int,
        leftText: String,
        rightText: String,
        leftFontStyle: FontStyle = .body,
        rightFontStyle: FontStyle = .body,
        leftColor: UIColor? = nil,
        rightColor: UIColor? = nil,
        maxLeftLines: Int = 1,
        maxRightLines: Int = 1,
        leftEllipsis: EllipsisType = .tail,
        rightEllipsis: EllipsisType = .tail,
        showsCard: Bool = false,
        showsTopDivider: Bool = false,
        showsBottomDivider: Bool = false,
        isEmphasized: Bool = false,
        usesMonospacedDigits: Bool = false
    ) {
        self.tag = tag
        self.leftText = leftText
        self.rightText = rightText
        self.leftFontStyle = leftFontStyle
        self.rightFontStyle = rightFontStyle
        self.leftColor = leftColor
        self.rightColor = rightColor
        self.maxLeftLines = maxLeftLines
        self.maxRightLines = maxRightLines
        self.leftEllipsis = leftEllipsis
        self.rightEllipsis = rightEllipsis
        self.showsCard = showsCard
        self.showsTopDivider = showsTopDivider
        self.showsBottomDivider = showsBottomDivider
        self.isEmphasized = isEmphasized
        self.usesMonospacedDigits = usesMonospacedDigits
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {

        guard let cell = cell as? KeyValueFormCell else {
            assertionFailure("Expected KeyValueFormCell")
            return cell
        }

        let model = KeyValueRowModel(
            leftText: leftText,
            rightText: rightText,
            leftFontStyle: leftFontStyle,
            rightFontStyle: rightFontStyle,
            leftColor: leftColor,
            rightColor: rightColor,
            maxLeftLines: maxLeftLines,
            maxRightLines: maxRightLines,
            leftEllipsis: leftEllipsis,
            rightEllipsis: rightEllipsis,
            showsCard: showsCard,
            showsTopDivider: showsTopDivider,
            showsBottomDivider: showsBottomDivider,
            isEmphasized: isEmphasized,
            usesMonospacedDigits: usesMonospacedDigits
        )

        cell.configure(with: model)

        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
