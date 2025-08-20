//
//  PDFFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import DesignSystemKit
import UIKit

public final class PDFFormRow: FormRow {
    public var reuseIdentifier: String { "PDFPreviewCell" }
    public var tag: Int
    public var cellTag: String { "pdf_row_\(tag)" }
    
    public var nibName: String? { nil }
    public var cellClass: AnyClass? { PDFPreviewCell.self }

    public let title: String
    public let pdfURL: URL
    
    public var didTap: (() -> Void)? // Optional routing callback

    public init(tag: Int, title: String, pdfURL: URL, didTap: (() -> Void)? = nil) {
        self.tag = tag
        self.title = title
        self.pdfURL = pdfURL
        self.didTap = didTap
    }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? PDFPreviewCell else { return cell }
        cell.titleLabel.text = title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    public func configure(_ cell: UICollectionViewCell, indexPath: IndexPath, sender: FormViewController?) -> UICollectionViewCell {
        return cell
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }

    @MainActor
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
