//
//  ImageFormCell.swift
//  Base App
//
//  Created by Edwin Weru on 04/08/2025.
//

import UIKit

// MARK: - ImageFormCell

public final class ImageFormCell: UITableViewCell {
    
    private let imageViewContainer = UIImageView()
    private var heightConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var aspectRatioConstraint: NSLayoutConstraint?

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

        leadingConstraint = imageViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = imageViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        NSLayoutConstraint.activate([
            imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            heightConstraint!,
            leadingConstraint!,
            trailingConstraint!
        ])

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    public func configure(with config: ImageFormRowConfig) {
        imageViewContainer.image = config.image
        heightConstraint?.constant = config.imageHeight

        // Fill width vs centered
        if config.fillWidth {
            imageViewContainer.contentMode = .scaleAspectFill
            imageViewContainer.clipsToBounds = true
            leadingConstraint?.constant = 0
            trailingConstraint?.constant = 0
        } else {
            imageViewContainer.contentMode = .scaleAspectFit
            imageViewContainer.clipsToBounds = true
            leadingConstraint?.constant = 16
            trailingConstraint?.constant = -16
        }

        // Background
        if let bgColor = config.backgroundColor {
            imageViewContainer.backgroundColor = bgColor
        } else {
            imageViewContainer.backgroundColor = .clear
        }

        // Corner radius
        if let radius = config.cornerRadius {
            imageViewContainer.layer.cornerRadius = radius
            imageViewContainer.clipsToBounds = true
        } else {
            imageViewContainer.layer.cornerRadius = 0
            imageViewContainer.clipsToBounds = config.fillWidth // only clip if needed
        }

        // Aspect ratio (width / height)
        if let ratio = config.aspectRatio {
            // Remove old constraint
            if let old = aspectRatioConstraint {
                imageViewContainer.removeConstraint(old)
            }

            aspectRatioConstraint = imageViewContainer.widthAnchor.constraint(equalTo: imageViewContainer.heightAnchor, multiplier: ratio)
            aspectRatioConstraint?.isActive = true
        }

        layoutIfNeeded()
    }

    public func updateImage(_ image: UIImage?, height: CGFloat) {
        imageViewContainer.image = image
        heightConstraint?.constant = height
        onModelUpdate?(image, height)
    }
}
