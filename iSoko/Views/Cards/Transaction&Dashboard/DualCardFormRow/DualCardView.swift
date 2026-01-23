//
//  DualCardView.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

final class DualCardView: UIView {

    private let titleIconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let statusContainer = UIView()
    private let statusIconView = UIImageView()
    private let statusLabel = UILabel()

    private let titleStack = UIStackView()
    private let statusStack = UIStackView()
    private let contentStack = UIStackView()

    private var onTap: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        layer.masksToBounds = true

        // MARK: - Title

        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 1

        titleIconView.contentMode = .scaleAspectFit
        titleIconView.setContentHuggingPriority(.required, for: .horizontal)
        titleIconView.setContentCompressionResistancePriority(.required, for: .horizontal)

        titleStack.axis = .horizontal
        titleStack.spacing = 6
        titleStack.alignment = .center
        titleStack.addArrangedSubview(titleIconView)
        titleStack.addArrangedSubview(titleLabel)

        // MARK: - Subtitle

        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        // MARK: - Status

        statusLabel.font = .preferredFont(forTextStyle: .caption1)

        statusIconView.contentMode = .scaleAspectFit
        statusIconView.tintColor = .label
        statusIconView.setContentHuggingPriority(.required, for: .horizontal)
        statusIconView.setContentCompressionResistancePriority(.required, for: .horizontal)

        statusStack.axis = .horizontal
        statusStack.alignment = .center
        statusStack.spacing = 4
        statusStack.distribution = .fill
        statusStack.addArrangedSubview(statusIconView)
        statusStack.addArrangedSubview(statusLabel)

        statusStack.setContentHuggingPriority(.required, for: .horizontal)
        statusStack.setContentCompressionResistancePriority(.required, for: .horizontal)

        statusContainer.layer.cornerRadius = 8
        statusContainer.addSubview(statusStack)

        statusContainer.setContentHuggingPriority(.required, for: .horizontal)
        statusContainer.setContentCompressionResistancePriority(.required, for: .horizontal)

        statusStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusStack.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 3),
            statusStack.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: -3),
            statusStack.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor, constant: 6),
            statusStack.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor, constant: -6)
        ])

        // MARK: - Content Stack

        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(titleStack)
        contentStack.addArrangedSubview(subtitleLabel)
        contentStack.addArrangedSubview(statusContainer)

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    func configure(with config: DualCardItemConfig) {
        titleLabel.text = config.title
        titleIconView.image = config.titleIcon
        titleIconView.isHidden = config.titleIcon == nil

        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil

        if let status = config.status {
            statusLabel.text = status.text
            statusLabel.textColor = status.textColor
            statusContainer.backgroundColor = status.backgroundColor

            statusIconView.image = status.icon
            statusIconView.isHidden = status.icon == nil

            statusContainer.isHidden = false
        } else {
            statusContainer.isHidden = true
        }

        backgroundColor = config.backgroundColor
        layer.cornerRadius = config.cornerRadius
        layer.borderColor = config.borderColor.cgColor
        layer.borderWidth = config.borderWidth

        onTap = config.onTap
    }

    @objc private func handleTap() {
        onTap?()
    }
}
