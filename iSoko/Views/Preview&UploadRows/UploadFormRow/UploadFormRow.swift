//
//  UploadFormRow.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import DesignSystemKit
import UIKit

public final class UploadFormRow: FormRow {

    public let tag: Int
    public var config: UploadFormRowConfig

    public var selectedImage: UIImage?
    public var selectedDocumentName: String?

    public let nibName: String? = nil
    public let reuseIdentifier: String = String(describing: UploadFormCell.self)
    public var cellClass: AnyClass? { UploadFormCell.self }

    public var modelDidUpdate: ((UploadResult) -> Void)?

    public init(tag: Int, config: UploadFormRowConfig) {
        self.tag = tag
        self.config = config
    }

    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let uploadCell = cell as? UploadFormCell else {
            assertionFailure("Expected UploadFormCell")
            return cell
        }

        uploadCell.configure(
            with: config,
            previewImage: selectedImage,
            documentName: selectedDocumentName
        )

        uploadCell.onTap = { [weak self] in
            self?.modelDidUpdate?(.pick)
        }

        return uploadCell
    }

    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        config.height + 16
    }

    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {
        selectedImage = nil
        selectedDocumentName = nil
    }
    public func fieldVisibility() -> Bool { true }
}
