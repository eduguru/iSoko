//
//  StoreHeaderCardCell.swift
//  
//
//  Created by Edwin Weru on 21/05/2026.
//

import UIKit

// MARK: - Cell

public final class StoreHeaderCardCell: UITableViewCell {

    // MARK: - Views

    private let containerView = UIView()

    private let avatarImageView = UIImageView()

    private let verifiedContainer = UIView()
    private let verifiedImageView = UIImageView()
    private let verifiedLabel = UILabel()

    private let nameLabel = UILabel()

    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()

    private let dividerView = UIView()

    private let statsStackView = UIStackView()

    // Dynamic constraint
    private var locationTopConstraint: NSLayoutConstraint?

    // MARK: - Init

    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup

    private func setup() {

        backgroundColor = .clear
        selectionStyle = .none

        setupContainer()
        setupAvatar()
        setupVerifiedBadge()
        setupName()
        setupLocation()
        setupDivider()
        setupStats()
    }

    // MARK: - Container

    private func setupContainer() {

        containerView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),

            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            )
        ])
    }

    // MARK: - Avatar

    private func setupAvatar() {

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 42

        containerView.addSubview(avatarImageView)

        NSLayoutConstraint.activate([

            avatarImageView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 20
            ),

            avatarImageView.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            ),

            avatarImageView.widthAnchor.constraint(equalToConstant: 84),
            avatarImageView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }

    // MARK: - Verified Badge

    private func setupVerifiedBadge() {

        verifiedContainer.translatesAutoresizingMaskIntoConstraints = false
        verifiedContainer.backgroundColor =
            UIColor.systemGreen.withAlphaComponent(0.12)

        verifiedContainer.layer.cornerRadius = 14
        verifiedContainer.layer.borderWidth = 1
        verifiedContainer.layer.borderColor =
            UIColor.systemGreen.cgColor

        containerView.addSubview(verifiedContainer)

        NSLayoutConstraint.activate([

            verifiedContainer.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 14
            ),

            verifiedContainer.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            )
        ])

        verifiedImageView.translatesAutoresizingMaskIntoConstraints = false
        verifiedImageView.contentMode = .scaleAspectFit
        verifiedImageView.tintColor = .systemGreen

        verifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        verifiedLabel.font = .systemFont(ofSize: 14, weight: .medium)
        verifiedLabel.textColor = .systemGreen

        verifiedContainer.addSubview(verifiedImageView)
        verifiedContainer.addSubview(verifiedLabel)

        NSLayoutConstraint.activate([

            verifiedImageView.leadingAnchor.constraint(
                equalTo: verifiedContainer.leadingAnchor,
                constant: 10
            ),

            verifiedImageView.centerYAnchor.constraint(
                equalTo: verifiedContainer.centerYAnchor
            ),

            verifiedImageView.widthAnchor.constraint(equalToConstant: 16),
            verifiedImageView.heightAnchor.constraint(equalToConstant: 16),

            verifiedLabel.topAnchor.constraint(
                equalTo: verifiedContainer.topAnchor,
                constant: 6
            ),

            verifiedLabel.leadingAnchor.constraint(
                equalTo: verifiedImageView.trailingAnchor,
                constant: 6
            ),

            verifiedLabel.trailingAnchor.constraint(
                equalTo: verifiedContainer.trailingAnchor,
                constant: -10
            ),

            verifiedLabel.bottomAnchor.constraint(
                equalTo: verifiedContainer.bottomAnchor,
                constant: -6
            )
        ])
    }

    // MARK: - Name

    private func setupName() {

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2

        containerView.addSubview(nameLabel)

        NSLayoutConstraint.activate([

            nameLabel.topAnchor.constraint(
                equalTo: verifiedContainer.bottomAnchor,
                constant: 18
            ),

            nameLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 24
            ),

            nameLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -24
            )
        ])
    }

    // MARK: - Location

    private func setupLocation() {

        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.image =
            UIImage(systemName: "mappin.and.ellipse")

        locationImageView.tintColor = .secondaryLabel
        locationImageView.contentMode = .scaleAspectFit

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font =
            .systemFont(ofSize: 16, weight: .medium)

        locationLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [
            locationImageView,
            locationLabel
        ])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)

        locationTopConstraint = stack.topAnchor.constraint(
            equalTo: nameLabel.bottomAnchor,
            constant: 8
        )

        locationTopConstraint?.isActive = true

        NSLayoutConstraint.activate([

            locationImageView.widthAnchor.constraint(
                equalToConstant: 16
            ),

            stack.centerXAnchor.constraint(
                equalTo: containerView.centerXAnchor
            )
        ])
    }

    // MARK: - Divider

    private func setupDivider() {

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .systemGray5

        containerView.addSubview(dividerView)

        NSLayoutConstraint.activate([

            dividerView.topAnchor.constraint(
                equalTo: locationLabel.bottomAnchor,
                constant: 20
            ),

            dividerView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 24
            ),

            dividerView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -24
            ),

            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Stats

    private func setupStats() {

        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.alignment = .fill
        statsStackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(statsStackView)

        NSLayoutConstraint.activate([

            statsStackView.topAnchor.constraint(
                equalTo: dividerView.bottomAnchor
            ),

            statsStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor
            ),

            statsStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor
            ),

            statsStackView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor
            ),

            statsStackView.heightAnchor.constraint(equalToConstant: 92)
        ])
    }

    // MARK: - Configure

    public func configure(
        with config: StoreHeaderCardConfig
    ) {

        avatarImageView.image = config.image

        // Name
        if let name = config.name,
           !name.isEmpty {

            nameLabel.text = name
            nameLabel.isHidden = false

            locationTopConstraint?.constant = 8

        } else {

            nameLabel.isHidden = true

            locationTopConstraint?.constant = 18
        }

        // Location
        locationLabel.text = config.location

        // Verified
        verifiedLabel.text = config.verifiedTitle

        if let image = config.verifiedImage {

            verifiedImageView.image = image
            verifiedImageView.isHidden = false

        } else {

            verifiedImageView.isHidden = true
        }

        verifiedContainer.isHidden =
            config.verifiedTitle == nil

        // Stats
        statsStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        for (index, stat) in config.stats.enumerated() {

            let statView = makeStatView(stat)

            statsStackView.addArrangedSubview(statView)

            if index < config.stats.count - 1 {

                let separator = UIView()

                separator.backgroundColor = .systemGray5
                separator.translatesAutoresizingMaskIntoConstraints = false

                statView.addSubview(separator)

                NSLayoutConstraint.activate([

                    separator.topAnchor.constraint(
                        equalTo: statView.topAnchor,
                        constant: 14
                    ),

                    separator.trailingAnchor.constraint(
                        equalTo: statView.trailingAnchor
                    ),

                    separator.bottomAnchor.constraint(
                        equalTo: statView.bottomAnchor,
                        constant: -14
                    ),

                    separator.widthAnchor.constraint(
                        equalToConstant: 1
                    )
                ])
            }
        }

        // Card styling
        containerView.backgroundColor = config.backgroundColor
        containerView.layer.cornerRadius = config.cornerRadius
        containerView.layer.borderWidth = config.borderWidth
        containerView.layer.borderColor =
            config.borderColor.cgColor
    }

    // MARK: - Stat View

    private func makeStatView(
        _ stat: StoreHeaderCardConfig.Stat
    ) -> UIView {

        let valueLabel = UILabel()

        valueLabel.text = stat.value
        valueLabel.font =
            .systemFont(ofSize: 28, weight: .bold)

        valueLabel.textAlignment = .center

        let titleLabel = UILabel()

        titleLabel.text = stat.title
        titleLabel.font =
            .systemFont(ofSize: 15, weight: .regular)

        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [
            valueLabel,
            titleLabel
        ])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8

        let container = UIView()

        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([

            stack.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),

            stack.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            )
        ])

        return container
    }
}
