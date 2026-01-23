//
//  TransactionCell.swift
//  
//
//  Created by Edwin Weru on 22/01/2026.
//

import UIKit

public final class TransactionCell: UITableViewCell {

    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let amountLabel = UILabel()

    private let topRowStack = UIStackView()
    private let textStack = UIStackView()

    private var onTap: (() -> Void)?

    private var internalPadding: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
    private var spacing: CGFloat = 12

    private var iconConstraints: [NSLayoutConstraint] = []

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupOuterConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupOuterConstraints()
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainerView)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconContainerView.addSubview(iconImageView)

        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 1

        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0

        amountLabel.font = .preferredFont(forTextStyle: .body)
        amountLabel.textAlignment = .right
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        topRowStack.axis = .horizontal
        topRowStack.spacing = 8
        topRowStack.addArrangedSubview(titleLabel)
        topRowStack.addArrangedSubview(UIView()) // spacer
        topRowStack.addArrangedSubview(amountLabel)

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(topRowStack)
        textStack.addArrangedSubview(descriptionLabel)

        containerView.addSubview(textStack)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
    }

    private func setupOuterConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    public func configure(with config: TransactionCellConfig) {
        onTap = config.onTap
        spacing = config.spacing

        internalPadding = config.isCardStyleEnabled
            ? config.contentInsets
            : UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        titleLabel.text = config.title
        descriptionLabel.text = config.description
        descriptionLabel.isHidden = config.description == nil

        amountLabel.text = config.amount
        amountLabel.textColor = config.amountColor

        iconImageView.image = config.image
        applyImageStyle(config.imageStyle, size: config.imageSize)

        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(iconContainerView)
        containerView.addSubview(textStack)

        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: internalPadding.left),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: config.imageSize.width),
            iconContainerView.heightAnchor.constraint(equalToConstant: config.imageSize.height),

            textStack.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: spacing),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -internalPadding.right),
            textStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: internalPadding.top),
            textStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -internalPadding.bottom)
        ])

        if config.isCardStyleEnabled {
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.layer.borderWidth = config.cardBorderWidth
            containerView.layer.borderColor = config.cardBorderColor.cgColor
            containerView.backgroundColor = config.cardBackgroundColor
        } else {
            containerView.backgroundColor = .clear
        }
    }

    private func applyImageStyle(_ style: TransactionImageStyle, size: CGSize) {
        NSLayoutConstraint.deactivate(iconConstraints)
        iconConstraints.removeAll()

        iconContainerView.backgroundColor = style.backgroundColor

        let radius: CGFloat
        switch style.shape {
        case .square:
            radius = 0
        case .circle:
            radius = size.height / 2
        case .rounded(let value):
            radius = value
        }

        iconContainerView.layer.cornerRadius = radius
        iconContainerView.layer.masksToBounds = true

        iconConstraints = [
            iconImageView.topAnchor.constraint(equalTo: iconContainerView.topAnchor, constant: style.inset),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: -style.inset),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: style.inset),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: -style.inset)
        ]

        NSLayoutConstraint.activate(iconConstraints)
    }

    @objc private func handleTap() {
        onTap?()
    }
}
