//
//  ImageFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 04/08/2025.
//

import UIKit

// MARK: - ImageFormCell
public final class ImageFormCell: UITableViewCell {
    
    private let imageViewContainer = UIImageView()
    private var heightConstraint: NSLayoutConstraint?
    
    /// Callback for when the model updates (e.g., image or height changes)
    public var onModelUpdate: ((UIImage?, CGFloat) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(imageViewContainer)
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.contentMode = .scaleAspectFit
        
        heightConstraint = imageViewContainer.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageViewContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageViewContainer.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            imageViewContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Clear selection style
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    /// Configure the cell's image and height
    public func configure(with image: UIImage?, height: CGFloat) {
        imageViewContainer.image = image
        heightConstraint?.constant = height
    }
    
    /// You can call this method when the image or height changes internally (e.g. user interaction)
    public func updateImage(_ image: UIImage?, height: CGFloat) {
        imageViewContainer.image = image
        heightConstraint?.constant = height
        onModelUpdate?(image, height)
    }
}
