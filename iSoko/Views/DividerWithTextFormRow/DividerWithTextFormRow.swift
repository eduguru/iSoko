//
//  DividerWithTextFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import DesignSystemKit
import UIKit

public final class DividerWithTextFormRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: DividerWithTextFormCell.self)
    public var cellClass: AnyClass? { DividerWithTextFormCell.self }

    public let text: String?
    public let characterCount: Int?

    public init(tag: Int, text: String?, characterCount: Int? = nil) {
        self.tag = tag
        self.text = text
        self.characterCount = characterCount
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? DividerWithTextFormCell else {
            assertionFailure("Expected DividerWithTextFormCell")
            return cell
        }

        cell.configure(text: text, characterCount: characterCount)
        return cell
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
