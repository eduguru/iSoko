//
//  SelectableDualCardView.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit

// MARK: - SelectableDualCardView
final class SelectableDualCardView: UIView {

    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let checkmarkView = UIImageView()

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

        // Container with rounded corners, border & background
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        addSubview(containerView)

        // Icon
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit
        containerView.addSubview(iconView)

        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        // Subtitle
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        containerView.addSubview(subtitleLabel)

        // Checkmark (top-right)
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = UIColor.systemGreen
        checkmarkView.isHidden = true
        containerView.addSubview(checkmarkView)

        // Layout constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),

            checkmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            checkmarkView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            checkmarkView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    func configure(title: String,
                   subtitle: String?,
                   icon: UIImage?,
                   iconTintColor: UIColor?,
                   selected: Bool) {

        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil

        iconView.image = icon?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = iconTintColor ?? .label
        iconView.isHidden = icon == nil

        if selected {
            containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            containerView.layer.borderColor = UIColor.systemGreen.cgColor
            checkmarkView.isHidden = false
        } else {
            containerView.backgroundColor = .white
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            checkmarkView.isHidden = true
        }
    }
}
