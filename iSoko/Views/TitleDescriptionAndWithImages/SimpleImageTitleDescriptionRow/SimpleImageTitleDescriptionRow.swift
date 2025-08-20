//
//  SimpleImageTitleDescriptionRow.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit
import DesignSystemKit

public final class SimpleImageTitleDescriptionRow: FormRow {
    public let tag: Int
    public let reuseIdentifier: String = String(describing: SimpleImageTitleDescriptionCell.self)
    public var cellClass: AnyClass? { SimpleImageTitleDescriptionCell.self }

    public var image: UIImage?
    public var imageIsRounded: Bool
    public var title: String
    public var description: String?
    public var showsArrow: Bool
    public var onTap: (() -> Void)?

    public init(
        tag: Int,
        image: UIImage? = nil,
        imageIsRounded: Bool = false,
        title: String,
        description: String? = nil,
        showsArrow: Bool = true,
        onTap: (() -> Void)? = nil
    ) {
        self.tag = tag
        self.image = image
        self.imageIsRounded = imageIsRounded
        self.title = title
        self.description = description
        self.showsArrow = showsArrow
        self.onTap = onTap
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? SimpleImageTitleDescriptionCell else {
            assertionFailure("Expected ImageTitleDescriptionCell")
            return cell
        }

        cell.configure(
            image: image,
            isRounded: imageIsRounded,
            title: title,
            description: description,
            showsArrow: showsArrow
        )

        cell.onTap = { [weak self] in
            self?.onTap?()
        }

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
