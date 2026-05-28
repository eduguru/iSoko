//
//  EditableImageIdentityHeaderCell.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import UIKit

public final class EditableImageIdentityHeaderCell: UITableViewCell {

    // MARK: Views

    private let containerView = UIView()
    private let avatarContainer = UIView()

    private let avatarImageView = UIImageView()

    private let editButton = UIButton(type: .system)

    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let chipStack = UIStackView()

    // MARK: Callbacks

    private var onProfileImageTap: (() -> Void)?
    private var onEditImageTap: (() -> Void)?

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
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Avatar container (important for overlay button)
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(avatarContainer)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        avatarContainer.addSubview(avatarImageView)

        // Edit button (overlay)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal) // "pencil.circle.fill"
        editButton.tintColor = .white
        editButton.backgroundColor = .app(.primary)
        editButton.layer.cornerRadius = 13
        editButton.clipsToBounds = true

        editButton.addTarget(self, action: #selector(handleEditTap), for: .touchUpInside)
        avatarContainer.addSubview(editButton)

        // Labels
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .center
        textStack.translatesAutoresizingMaskIntoConstraints = false

        chipStack.axis = .horizontal
        chipStack.spacing = 8
        chipStack.alignment = .center
        chipStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(textStack)
        containerView.addSubview(chipStack)

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        // Tap avatar
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileTap))
        avatarContainer.addGestureRecognizer(tap)
    }

    // MARK: Layout

    private func setupLayout() {

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Avatar container
            avatarContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            avatarContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarContainer.widthAnchor.constraint(equalToConstant: 80),
            avatarContainer.heightAnchor.constraint(equalToConstant: 80),

            // Avatar image
            avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),

            // Edit button overlay
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
            editButton.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),

            // Text
            textStack.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 12),
            textStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            chipStack.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 10),
            chipStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            chipStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: Configure

    public func configure(with config: EditableImageIdentityHeaderConfig) {

        onProfileImageTap = config.onProfileImageTap
        onEditImageTap = config.onEditImageTap

        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle

        subtitleLabel.isHidden = config.subtitle?.isEmpty ?? true
        
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
        
        
        avatarImageView.layer.cornerRadius = config.imageSize.width / 2
        avatarImageView.layer.masksToBounds = true

        resetChips()

        if let leading = config.leadingChip {
            chipStack.addArrangedSubview(leading)
        }

        if let trailing = config.trailingChip {
            chipStack.addArrangedSubview(trailing)
        }
    }

    // MARK: Actions

    @objc private func handleProfileTap() {
        onProfileImageTap?()
    }

    @objc private func handleEditTap() {
        onEditImageTap?()
    }

    // MARK: Helpers

    private func resetChips() {
        chipStack.arrangedSubviews.forEach {
            chipStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        onProfileImageTap = nil
        onEditImageTap = nil
        resetChips()
    }
}
