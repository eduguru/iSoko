//
//  ImageIdentityHeaderCell.swift
//  
//
//  Created by Edwin Weru on 07/05/2026.
//

import UIKit

public final class ImageIdentityHeaderCell: UITableViewCell {

    // MARK: Views

    private let containerView = UIView()

    private let avatarImageView = UIImageView()

    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let chipStack = UIStackView()

    private var onTap: (() -> Void)?

    // MARK: Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        layout()
    }

    // MARK: Setup (BUILD HIERARCHY ONCE)

    private func setup() {

        backgroundColor = .clear
        selectionStyle = .none

        // container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // avatar
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        // labels
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        // text stack
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .center
        textStack.translatesAutoresizingMaskIntoConstraints = false

        // chips stack
        chipStack.axis = .horizontal
        chipStack.spacing = 8
        chipStack.alignment = .center
        chipStack.translatesAutoresizingMaskIntoConstraints = false

        // build hierarchy ONCE (IMPORTANT)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(chipStack)

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tap)
    }

    // MARK: Layout (CENTERED HEADER STYLE)

    private func layout() {

        NSLayoutConstraint.activate([

            // container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // avatar (TOP CENTER)
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),

            // text (CENTERED BELOW AVATAR)
            textStack.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            textStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // chips
            chipStack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 10),
            chipStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            chipStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: Configure (DATA ONLY — SAFE)

    public func configure(with config: ImageIdentityHeaderConfig) {

        onTap = config.onTap

        // avatar
        avatarImageView.image = config.image
        avatarImageView.layer.cornerRadius = config.imageSize.width / 2

        // text
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil

        // reset chips safely
        chipStack.arrangedSubviews.forEach {
            chipStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        if let leading = config.leadingChip {
            chipStack.addArrangedSubview(leading)
        }

        if let trailing = config.trailingChip {
            chipStack.addArrangedSubview(trailing)
        }
    }

    // MARK: Tap

    @objc private func handleTap() {
        onTap?()
    }

    // MARK: Reuse safety

    public override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
}
