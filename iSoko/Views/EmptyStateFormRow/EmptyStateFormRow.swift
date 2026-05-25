//
//  EmptyStateFormRow.swift
//  DesignSystemKit
//
//  Created by Edwin Weru on 24/05/2026.
//

import UIKit
import DesignSystemKit

// MARK: - EmptyStateFormRow

public final class EmptyStateFormRow: FormRow {

    public let tag: Int
    public let reuseIdentifier = String(describing: ContentCardFormCell.self)
    public var cellClass: AnyClass? { ContentCardFormCell.self }

    private let contentRow: ContentCardFormRow

    public init(tag: Int = -9999, config: EmptyStateConfig = .noData) {
        self.tag = tag
        self.contentRow = ContentCardFormRow(
            tag: tag,
            config: ContentCardModel(
                title: config.title,
                text: config.message,
                image: config.image,
                imagePosition: .center,
                imageHeight: config.image != nil ? config.imageHeight : nil,
                cardSettings: CardSettings(
                    backgroundColor: .clear,
                    cornerRadius: 0,
                    borderColor: nil,
                    borderWidth: 0,
                    contentInsets: UIEdgeInsets(top: 40, left: 24, bottom: 40, right: 24)
                )
            )
        )
    }

    public func configure(
        _ cell: UITableViewCell,
        indexPath: IndexPath,
        sender: FormViewController?
    ) -> UITableViewCell {
        contentRow.configure(cell, indexPath: indexPath, sender: sender)
    }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - FormSection + empty state helper
public extension FormSection {

    /// Replaces cells with a single EmptyStateFormRow when the provided array is empty.
    /// Returns self with original cells when data is present.
    static func withEmptyState(
        id: Int = 0,
        title: String? = nil,
        cells: [FormRow],
        emptyConfig: EmptyStateConfig = .noData
    ) -> FormSection {
        FormSection(
            id: id,
            title: title,
            cells: cells.isEmpty ? [EmptyStateFormRow(config: emptyConfig)] : cells
        )
    }
}
