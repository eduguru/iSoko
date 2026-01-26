//
//  StatusCardView.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

final class StatusCardView: UIView {

    private let contentView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    // Store the model
    private var model: StatusCardViewModel?

    private var iconWidthConstraint: NSLayoutConstraint!
    private var iconHeightConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        clipsToBounds = false

        // Shadow on outer view
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        contentView.addSubview(titleLabel)

        iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 20)
        iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconWidthConstraint,
            iconHeightConstraint,

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        // Add gesture recognizer to detect tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true  // Enable user interaction
    }

    // MARK: - Handle tap event
    @objc private func handleCardTap() {
        // Invoke the callback if it's provided
        model?.onTapAction?()
    }

    // MARK: - Configure
    func configure(with model: StatusCardViewModel) {
        self.model = model  // Store the model

        // Content
        titleLabel.text = model.title
        iconImageView.image = model.image

        // Background & radius
        contentView.backgroundColor = model.backgroundColor ?? .clear
        contentView.layer.cornerRadius = model.cornerRadius ?? 14

        // Border
        contentView.layer.borderColor = model.borderColor?.cgColor
        contentView.layer.borderWidth = model.borderWidth ?? 0

        // Shadow
        layer.shadowColor = (model.shadowColor ?? .black).cgColor
        layer.shadowOpacity = model.shadowOpacity ?? 0.12
        layer.shadowRadius = model.shadowRadius ?? 8
        layer.shadowOffset = model.shadowOffset ?? CGSize(width: 0, height: 4)

        // Icon tint
        if let tintColor = model.iconTintColor {
            iconImageView.tintColor = tintColor
            iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        }

        // Text
        titleLabel.textColor = model.textColor ?? .label
        titleLabel.font = model.font ?? .systemFont(ofSize: 16, weight: .medium)

        // Icon size override
        if let iconSize = model.iconSize {
            iconWidthConstraint.constant = iconSize.width
            iconHeightConstraint.constant = iconSize.height
        } else {
            iconWidthConstraint.constant = 20
            iconHeightConstraint.constant = 20
        }

        // Fixed height (optional)
        if let fixedHeight = model.fixedHeight {
            if heightConstraint == nil {
                heightConstraint = heightAnchor.constraint(equalToConstant: fixedHeight)
                heightConstraint?.priority = .required
                heightConstraint?.isActive = true
            } else {
                heightConstraint?.constant = fixedHeight
                heightConstraint?.isActive = true
            }
        } else {
            heightConstraint?.isActive = false
        }

        setNeedsLayout()
    }

    // Optional but recommended for shadow performance
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: contentView.layer.cornerRadius
        ).cgPath
    }
}
