//
//  EditableImageFormCell.swift
//  
//
//  Created by Edwin Weru on 11/11/2025.
//

import UIKit

public final class EditableImageFormCell: UITableViewCell {

    // MARK: - UI Components
    private let imageViewContainer = UIImageView()
    private let editButton = UIButton(type: .system)

    // MARK: - Constraints
    private var heightConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var centerXConstraint: NSLayoutConstraint?
    private var aspectRatioConstraint: NSLayoutConstraint?

    // MARK: - Callbacks
    public var onEditTapped: (() -> Void)?
    public var onModelUpdate: ((UIImage?, CGFloat) -> Void)?

    // MARK: - Padding (matches TitleDescriptionFormCell)
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 12

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Image view
        contentView.addSubview(imageViewContainer)
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.contentMode = .scaleAspectFit
        imageViewContainer.clipsToBounds = true

        // Edit button
        contentView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        editButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        editButton.layer.cornerRadius = 6
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)

        // Constraints
        leadingConstraint = imageViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding)
        trailingConstraint = imageViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding)
        centerXConstraint = imageViewContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        heightConstraint = imageViewContainer.heightAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([
            imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            imageViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            heightConstraint!,

            // Edit button centered on image
            editButton.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    // MARK: - Configure
    public func configure(with config: EditableImageFormRowConfig) {
        imageViewContainer.image = config.image
        heightConstraint?.constant = config.imageHeight

        // Deactivate all alignment constraints first
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        centerXConstraint?.isActive = false

        if config.fillWidth {
            imageViewContainer.contentMode = .scaleAspectFill
            imageViewContainer.clipsToBounds = true

            leadingConstraint?.constant = horizontalPadding
            trailingConstraint?.constant = -horizontalPadding

            leadingConstraint?.isActive = true
            trailingConstraint?.isActive = true
        } else {
            imageViewContainer.contentMode = .scaleAspectFit
            imageViewContainer.clipsToBounds = true

            switch config.alignment {
            case .left:
                leadingConstraint?.constant = 0
                leadingConstraint?.isActive = true
            case .right:
                trailingConstraint?.constant = 0
                trailingConstraint?.isActive = true
            case .center:
                centerXConstraint?.isActive = true
            }
        }

        // Background color
        imageViewContainer.backgroundColor = config.backgroundColor ?? .clear

        // Corner radius
        if let radius = config.cornerRadius {
            imageViewContainer.layer.cornerRadius = radius
            imageViewContainer.clipsToBounds = true
        } else {
            imageViewContainer.layer.cornerRadius = 0
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
        } else if let old = aspectRatioConstraint {
            imageViewContainer.removeConstraint(old)
            aspectRatioConstraint = nil
        }

        // Show/hide edit button
        editButton.isHidden = !config.editable
        if let buttonImage = config.editButtonImage {
            editButton.setImage(buttonImage, for: .normal)
            editButton.setTitle(nil, for: .normal)
        } else {
            editButton.setTitle("Edit", for: .normal)
            editButton.setImage(nil, for: .normal)
        }
    }

    // MARK: - Actions
    @objc private func editTapped() {
        onEditTapped?()
    }
}
