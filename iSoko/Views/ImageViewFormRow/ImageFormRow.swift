//
//  ImageFormRow.swift
//  iSoko
//
//  Created by Edwin Weru on 04/08/2025.
//

import DesignSystemKit
import UIKit

// MARK: - ImageFormRow
public final class ImageFormRow: FormRow {
    public let tag: Int
    public var image: UIImage?
    public var imageHeight: CGFloat
    
    public let nibName: String? = nil
    public let reuseIdentifier: String = String(describing: ImageFormCell.self)
    public var cellClass: AnyClass? { ImageFormCell.self }
    
    // Callback to receive updates from cell
    public var modelDidUpdate: ((UIImage?, CGFloat) -> Void)?
    
    public init(tag: Int, image: UIImage?, height: CGFloat = 100) {
        self.tag = tag
        self.image = image
        self.imageHeight = height
    }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let imageCell = cell as? ImageFormCell else {
            assertionFailure("Expected ImageFormCell")
            return cell
        }
        
        imageCell.configure(with: image, height: imageHeight)
        
        // Sync updates from the cell back to this row
        imageCell.onModelUpdate = { [weak self] updatedImage, updatedHeight in
            self?.image = updatedImage
            self?.imageHeight = updatedHeight
            self?.modelDidUpdate?(updatedImage, updatedHeight)
        }
        
        return imageCell
    }
    
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        imageHeight + 32 // padding top + bottom (16+16)
    }
    
    // Validation, reset, etc., can be default or overridden as needed
    public func validate() -> Bool { true }
    public func validateWithError() -> Bool { true }
    public func reset() {}
    public func fieldVisibility() -> Bool { true }
}

