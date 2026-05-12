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
        imageViewContainer.backgroundColor = config.backgroundColor ?? .clear

        // Corner radius
        if let radius = config.cornerRadius {
            imageViewContainer.layer.cornerRadius = radius
            imageViewContainer.clipsToBounds = true
        } else {
            imageViewContainer.layer.cornerRadius = 0
            imageViewContainer.clipsToBounds = config.fillWidth
        }

        // Aspect ratio
        if let ratio = config.aspectRatio {
            if let old = aspectRatioConstraint {
                imageViewContainer.removeConstraint(old)
            }

            aspectRatioConstraint = imageViewContainer.widthAnchor.constraint(
                equalTo: imageViewContainer.heightAnchor,
                multiplier: ratio
            )
            aspectRatioConstraint?.isActive = true
        }

        if let url = config.imageURL {

            imageViewContainer.kf.indicatorType = .activity

            imageViewContainer.kf.setImage(
                with: url,
                placeholder: config.image,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.onModelUpdate?(value.image, config.imageHeight)

                case .failure:
                    // fallback already handled by placeholder
                    self?.imageViewContainer.image = config.image
                }
            }

        } else {
            // fallback local image
            imageViewContainer.kf.cancelDownloadTask()
            imageViewContainer.image = config.image
        }

        layoutIfNeeded()
    }

    public func updateImage(_ image: UIImage?, height: CGFloat) {
        imageViewContainer.image = image
        heightConstraint?.constant = height
        onModelUpdate?(image, height)
    }
}
