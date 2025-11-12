//
//  EditableImageFormRow.swift
//  
//
//  Created by Edwin Weru on 11/11/2025.
//

import DesignSystemKit
import UIKit

public final class EditableImageFormRow: FormRow {
    public let tag: Int
    public var config: EditableImageFormRowConfig

    public var onEditTapped: (() -> Void)?

    public let nibName: String? = nil
    public let reuseIdentifier: String = String(describing: EditableImageFormCell.self)
    public var cellClass: AnyClass? { EditableImageFormCell.self }

    public var modelDidUpdate: ((UIImage?, CGFloat) -> Void)?

    public init(
        tag: Int,
        config: EditableImageFormRowConfig,
        onEditTapped: (() -> Void)? = nil
    ) {
        self.tag = tag
        self.config = config
        self.onEditTapped = onEditTapped
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController? = nil
    ) -> UITableViewCell {
        guard let editableCell = cell as? EditableImageFormCell else {
            assertionFailure("Expected EditableImageFormCell")
            return cell
        }

        editableCell.configure(with: config)
        editableCell.onEditTapped = { [weak self] in
            self?.onEditTapped?()
        }
        editableCell.onModelUpdate = { [weak self] updatedImage, updatedHeight in
            self?.config.image = updatedImage
            self?.config.imageHeight = updatedHeight
            self?.modelDidUpdate?(updatedImage, updatedHeight)
        }

        return editableCell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        config.imageHeight + 32 // padding top/bottom = 16 each
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}
