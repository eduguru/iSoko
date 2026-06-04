//
//  InfoListingViewCell.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import UIKit
import DesignSystemKit
import Kingfisher

public final class InfoListingViewCell: UITableViewCell {
    private let containerView = UIView()
    private let iconImageView = UIImageView()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let descriptionLabel = UILabel()

    private let textStack = UIStackView()

    // MARK: - State

    private var onTap: (() -> Void)?
    private var model: InfoListingModel?

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup Views (BUILD HIERARCHY ONCE)

    private func setupViews() {

        backgroundColor = .clear
        selectionStyle = .none

        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)

        // Icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .app(.primary)

        // Labels
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2

        // Stack
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        textStack.addArrangedSubview(descriptionLabel)

        // Add subviews ONCE (important for avoiding your crash)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textStack)

        // Tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
        containerView.isUserInteractionEnabled = true
    }

    // MARK: - Constraints (ACTIVATE ONCE)

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            // Card spacing
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),

            // Text stack
            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    // MARK: - Configure (DATA ONLY)

    public func configure(with model: InfoListingModel) {

        self.model = model
        self.onTap = model.onTap

        // Card styling
        containerView.backgroundColor = model.cardBackgroundColor
        containerView.layer.cornerRadius = model.cardRadius

        // Image
        if let urlString = model.imageURL,
           let url = URL(string: urlString) {
            iconImageView.kf.setImage(with: url, placeholder: model.icon)
        } else {
            iconImageView.image = model.icon
        }

        // Text
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        descriptionLabel.text = model.desc

        subtitleLabel.isHidden = model.subtitle?.isEmpty ?? true
        descriptionLabel.isHidden = model.desc?.isEmpty ?? true
    }

    // MARK: - Tap

    @objc private func handleTap() {
        onTap?()
    }

    // MARK: - Reuse safety

    public override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        descriptionLabel.text = nil

        onTap = nil
    }
}
