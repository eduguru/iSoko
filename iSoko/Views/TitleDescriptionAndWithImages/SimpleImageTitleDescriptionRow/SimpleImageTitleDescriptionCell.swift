//
//  SimpleImageTitleDescriptionCell.swift
//  iSoko
//
//  Created by Edwin Weru on 14/08/2025.
//

import UIKit
import DesignSystemKit

public final class SimpleImageTitleDescriptionCell: UITableViewCell {
    private let leftImageView = UIImageView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    public var onTap: (() -> Void)?

    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear

        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.tintColor = .tertiaryLabel
        arrowImageView.setContentHuggingPriority(.required, for: .horizontal)

        titleLabel.font = styleGuide.font(for: .headline)
        descriptionLabel.font = styleGuide.font(for: .subheadline)
        descriptionLabel.textColor = .secondaryLabel

        titleLabel.numberOfLines = 1
        descriptionLabel.numberOfLines = 0

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        let horizontalStack = UIStackView(arrangedSubviews: [leftImageView, stackView, arrowImageView])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 12
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            leftImageView.widthAnchor.constraint(equalToConstant: 40),
            leftImageView.heightAnchor.constraint(equalToConstant: 40),

            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
    }

    public func configure(
        image: UIImage?,
        isRounded: Bool,
        title: String,
        description: String?,
        showsArrow: Bool
    ) {
        leftImageView.image = image
        leftImageView.layer.cornerRadius = isRounded ? 20 : 0

        titleLabel.text = title
        descriptionLabel.text = description
        descriptionLabel.isHidden = (description?.isEmpty ?? true)
        arrowImageView.isHidden = !showsArrow
    }

    @objc private func cellTapped() {
        onTap?()
    }
}
