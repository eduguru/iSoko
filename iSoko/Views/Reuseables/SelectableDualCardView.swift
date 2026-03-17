//
//  SelectableDualCardView.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit

// MARK: - SelectableDualCardView
final class SelectableDualCardView: UIView {

    // Add this
    public var alignment: Alignment = .center {
        didSet {
            updateAlignment()
        }
    }

    // Existing views...
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let checkmarkView = UIImageView()

    // Constraints that change depending on alignment
    private var iconCenterXConstraint: NSLayoutConstraint?
    private var iconLeadingConstraint: NSLayoutConstraint?
    private var iconTrailingConstraint: NSLayoutConstraint?

    private var titleCenterXConstraint: NSLayoutConstraint?
    private var titleLeadingConstraint: NSLayoutConstraint?
    private var titleTrailingConstraint: NSLayoutConstraint?

    private var subtitleCenterXConstraint: NSLayoutConstraint?
    private var subtitleLeadingConstraint: NSLayoutConstraint?
    private var subtitleTrailingConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        addSubview(containerView)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        containerView.addSubview(iconView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label

        // We'll change alignment dynamically, start centered
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        subtitleLabel.textAlignment = .center
        containerView.addSubview(subtitleLabel)

        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = UIColor.systemGreen
        checkmarkView.isHidden = true
        containerView.addSubview(checkmarkView)

        // Setup constraints for icon, title, subtitle with all possible constraints:
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),

            checkmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            checkmarkView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20),
        ])

        // Horizontal constraints stored for toggling:
        iconCenterXConstraint = iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        iconLeadingConstraint = iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        iconTrailingConstraint = iconView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)

        titleCenterXConstraint = titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12)
        titleTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)

        subtitleCenterXConstraint = subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        subtitleLeadingConstraint = subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12)
        subtitleTrailingConstraint = subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)

        updateAlignment()
    }

    private func updateAlignment() {
        // Deactivate all first
        iconCenterXConstraint?.isActive = false
        iconLeadingConstraint?.isActive = false
        iconTrailingConstraint?.isActive = false

        titleCenterXConstraint?.isActive = false
        titleLeadingConstraint?.isActive = false
        titleTrailingConstraint?.isActive = false

        subtitleCenterXConstraint?.isActive = false
        subtitleLeadingConstraint?.isActive = false
        subtitleTrailingConstraint?.isActive = false

        // Reset text alignments and activate appropriate constraints
        switch alignment {
        case .center:
            iconCenterXConstraint?.isActive = true
            titleCenterXConstraint?.isActive = true
            subtitleCenterXConstraint?.isActive = true

            titleLabel.textAlignment = .center
            subtitleLabel.textAlignment = .center

        case .left:
            iconLeadingConstraint?.isActive = true
            titleLeadingConstraint?.isActive = true
            subtitleLeadingConstraint?.isActive = true

            titleLabel.textAlignment = .left
            subtitleLabel.textAlignment = .left

        case .right:
            iconTrailingConstraint?.isActive = true
            titleTrailingConstraint?.isActive = true
            subtitleTrailingConstraint?.isActive = true

            titleLabel.textAlignment = .right
            subtitleLabel.textAlignment = .right
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func configure(
        title: String,
        subtitle: String?,
        icon: UIImage?,
        iconTintColor: UIColor? = nil,
        selected: Bool,
        alignment: Alignment = .center,
        showsSelection: Bool = true,
        selectionColor: UIColor = .systemGreen,
        selectionImage: UIImage? = UIImage(systemName: "checkmark.circle.fill")
    ) {

        self.alignment = alignment

        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil

        iconView.image = icon?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = iconTintColor ?? .label
        iconView.isHidden = icon == nil

        checkmarkView.image = selectionImage
        checkmarkView.tintColor = selectionColor

        guard showsSelection else {
            // Action-only cards (no selection state)
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            checkmarkView.isHidden = true
            return
        }

        if selected {
            containerView.backgroundColor = selectionColor.withAlphaComponent(0.15)
            containerView.layer.borderColor = selectionColor.cgColor
            checkmarkView.isHidden = false
        } else {
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            checkmarkView.isHidden = true
        }
    }
}
