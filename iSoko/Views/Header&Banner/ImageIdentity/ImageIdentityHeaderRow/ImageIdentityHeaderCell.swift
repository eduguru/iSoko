//
//  ImageIdentityHeaderCell.swift
//  
//
//  Created by Edwin Weru on 07/05/2026.
//

import UIKit
import Kingfisher

public final class ImageIdentityHeaderCell: UITableViewCell {

    // MARK: Views

    private let containerView = UIView()

    private let avatarImageView = UIImageView()

    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let chipStack = UIStackView()

    // MARK: Constraints

    private var avatarWidthConstraint: NSLayoutConstraint?
    private var avatarHeightConstraint: NSLayoutConstraint?

    // MARK: State

    private var onTap: (() -> Void)?

    // MARK: Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }

    // MARK: Setup

    private func setup() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        // Container

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        // Avatar

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .secondarySystemBackground

        // Labels

        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        // Text Stack

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .center
        textStack.translatesAutoresizingMaskIntoConstraints = false

        // Chip Stack

        chipStack.axis = .horizontal
        chipStack.spacing = 8
        chipStack.alignment = .center
        chipStack.translatesAutoresizingMaskIntoConstraints = false

        // Hierarchy

        containerView.addSubview(avatarImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(chipStack)

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        // Tap

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )

        containerView.addGestureRecognizer(tap)
    }

    // MARK: Layout

    private func setupLayout() {

        avatarWidthConstraint = avatarImageView.widthAnchor.constraint(equalToConstant: 72)
        avatarHeightConstraint = avatarImageView.heightAnchor.constraint(equalToConstant: 72)

        NSLayoutConstraint.activate([

            // Container

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Avatar

            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            avatarWidthConstraint!,
            avatarHeightConstraint!,

            // Text

            textStack.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 12
            ),

            textStack.leadingAnchor.constraint(
                greaterThanOrEqualTo: containerView.leadingAnchor,
                constant: 16
            ),

            textStack.trailingAnchor.constraint(
                lessThanOrEqualTo: containerView.trailingAnchor,
                constant: -16
            ),

            textStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            // Chips

            chipStack.topAnchor.constraint(
                equalTo: textStack.bottomAnchor,
                constant: 10
            ),

            chipStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            chipStack.leadingAnchor.constraint(
                greaterThanOrEqualTo: containerView.leadingAnchor,
                constant: 16
            ),

            chipStack.trailingAnchor.constraint(
                lessThanOrEqualTo: containerView.trailingAnchor,
                constant: -16
            ),

            chipStack.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -20
            )
        ])
    }

    // MARK: Configure

    public func configure(with config: ImageIdentityHeaderConfig) {

        onTap = config.onTap

        isUserInteractionEnabled = config.isEnabled
        containerView.isUserInteractionEnabled = config.isEnabled

        // MARK: Card Style

        if config.isCardStyleEnabled {
            containerView.backgroundColor = config.cardBackgroundColor
            containerView.layer.cornerRadius = config.cardCornerRadius
            containerView.layer.masksToBounds = true
        } else {
            containerView.backgroundColor = .clear
            containerView.layer.cornerRadius = 0
        }

        // MARK: Avatar

        avatarWidthConstraint?.constant = config.imageSize.width
        avatarHeightConstraint?.constant = config.imageSize.height

        avatarImageView.backgroundColor = config.avatarBackgroundColor
        avatarImageView.contentMode = config.avatarContentMode

        let cornerRadius = config.avatarCornerRadius
            ?? (config.imageSize.width / 2)

        avatarImageView.layer.cornerRadius = cornerRadius

        // IMPORTANT:
        // If URL exists:
        // - local image acts as placeholder + fallback
        // If URL is nil:
        // - local image is used directly

        if let imageURL = config.imageURL {

            avatarImageView.kf.setImage(
                with: imageURL,
                placeholder: config.image,
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            ) { [weak self] result in

                guard let self else { return }

                switch result {

                case .success:
                    break

                case .failure:
                    // fallback image
                    self.avatarImageView.image = config.image
                }
            }

        } else {

            avatarImageView.image = config.image
        }

        // MARK: Text

        titleLabel.text = config.title

        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle?.isEmpty ?? true

        // MARK: Chips

        resetChipStack()

        if let leadingChip = config.leadingChip {
            chipStack.addArrangedSubview(leadingChip)
        }

        if let trailingChip = config.trailingChip {
            chipStack.addArrangedSubview(trailingChip)
        }

        chipStack.isHidden = chipStack.arrangedSubviews.isEmpty
    }

    // MARK: Helpers

    private func resetChipStack() {

        chipStack.arrangedSubviews.forEach {
            chipStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    // MARK: Tap

    @objc
    private func handleTap() {
        onTap?()
    }

    // MARK: Reuse

    public override func prepareForReuse() {
        super.prepareForReuse()

        onTap = nil

        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil

        titleLabel.text = nil
        subtitleLabel.text = nil

        resetChipStack()
    }
}
