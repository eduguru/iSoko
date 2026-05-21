//
//  StoreProfileCardCell.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit

public final class StoreProfileCardCell: UITableViewCell {

    private let containerView = UIView()
    private let headerLabel = UILabel()

    // Top section
    private let avatarImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let verifiedImageView = UIImageView()
    private let trailingButton = UIButton(type: .system)

    private let titleStack = UIStackView()
    private let topRowStack = UIStackView()

    // Badges
    private let badgesStack = UIStackView()

    // Divider
    private let dividerView = UIView()

    // Bottom actions
    private let actionsStack = UIStackView()

    private var actionHandlers: [() -> Void] = []

    // MARK: Init

    public override init(style: UITableViewCell.CellStyle,
                         reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true

        setupHeader()
        setupTopSection()
        setupBadgesSection()
        setupDivider()
        setupActionsSection()
    }

    // MARK: - HEADER (NEW)

    private func setupHeader() {

        headerLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        headerLabel.textColor = .secondaryLabel
        headerLabel.numberOfLines = 1
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Top Section

    private func setupTopSection() {

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 28
        avatarImageView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 56).isActive = true

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 1

        // NEW: description under title
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2

        verifiedImageView.contentMode = .scaleAspectFit
        verifiedImageView.translatesAutoresizingMaskIntoConstraints = false
        verifiedImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        // Title stack (UPDATED)
        titleStack.axis = .vertical
        titleStack.spacing = 2
        titleStack.alignment = .leading

        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(descriptionLabel)
        titleStack.addArrangedSubview(verifiedImageView)

        let spacer = UIView()

        topRowStack.axis = .horizontal
        topRowStack.spacing = 12
        topRowStack.alignment = .center
        topRowStack.translatesAutoresizingMaskIntoConstraints = false

        topRowStack.addArrangedSubview(avatarImageView)
        topRowStack.addArrangedSubview(titleStack)
        topRowStack.addArrangedSubview(spacer)
        topRowStack.addArrangedSubview(trailingButton)

        containerView.addSubview(topRowStack)

        NSLayoutConstraint.activate([
            topRowStack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            topRowStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            topRowStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])

        // Button
        trailingButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        trailingButton.layer.cornerRadius = 14
        trailingButton.layer.borderWidth = 1
        trailingButton.layer.borderColor = UIColor.systemGreen.cgColor
        trailingButton.setTitleColor(.systemGreen, for: .normal)
        trailingButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
    }

    // MARK: - Badges

    private func setupBadgesSection() {

        badgesStack.axis = .horizontal
        badgesStack.spacing = 8
        badgesStack.alignment = .leading
        badgesStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(badgesStack)

        NSLayoutConstraint.activate([
            badgesStack.topAnchor.constraint(equalTo: topRowStack.bottomAnchor, constant: 12),
            badgesStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            badgesStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Divider

    private func setupDivider() {

        dividerView.backgroundColor = .systemGray5
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: badgesStack.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Actions

    private func setupActionsSection() {

        actionsStack.axis = .horizontal
        actionsStack.distribution = .fillEqually
        actionsStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(actionsStack)

        NSLayoutConstraint.activate([
            actionsStack.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 12),
            actionsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            actionsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            actionsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configure

    public func configure(with config: StoreProfileCardConfig) {

        if let header = config.headerTitle, !header.isEmpty {
            headerLabel.text = header
            headerLabel.isHidden = false
        } else {
            headerLabel.isHidden = true
        }

        avatarImageView.image = config.image
        titleLabel.text = config.title

        if let desc = config.description, !desc.isEmpty {
            descriptionLabel.text = desc
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }

        // Verified
        if let verifiedImage = config.verifiedImage {
            verifiedImageView.image = verifiedImage
            verifiedImageView.isHidden = false
        } else {
            verifiedImageView.isHidden = true
        }

        // Button
        trailingButton.setTitle(config.trailingButtonTitle, for: .normal)
        trailingButton.isHidden = config.trailingButtonTitle == nil
        trailingButton.removeTarget(nil, action: nil, for: .allEvents)

        if config.trailingButtonTitle != nil {
            trailingButton.addAction(UIAction { _ in
                config.onTrailingButtonTap?()
            }, for: .touchUpInside)
        }

        // Badges
        badgesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for badge in config.badges {
            let view = BadgeView()
            view.configure(
                text: badge.0,
                textColor: badge.1,
                backgroundColor: badge.2
            )
            badgesStack.addArrangedSubview(view)
        }

        badgesStack.isHidden = config.badges.isEmpty

        // Actions
        actionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        actionHandlers.removeAll()

        for action in config.actions {
            let view = makeActionView(action: action)
            actionsStack.addArrangedSubview(view)
        }

        let hasActions = !config.actions.isEmpty
        actionsStack.isHidden = !hasActions
        dividerView.isHidden = !hasActions

        // Card styling
        containerView.backgroundColor = config.backgroundColor
        containerView.layer.borderColor = config.borderColor.cgColor
        containerView.layer.borderWidth = config.borderWidth
        containerView.layer.cornerRadius = config.cornerRadius
    }

    // MARK: Action View

    private func makeActionView(action: StoreProfileCardConfig.Action) -> UIView {

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6

        let imageView = UIImageView(image: action.image)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        let label = UILabel()
        label.text = action.title
        label.font = .systemFont(ofSize: 14, weight: .medium)

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleActionTap(_:)))
        stack.addGestureRecognizer(tap)

        actionHandlers.append(action.handler ?? {})
        stack.tag = actionHandlers.count - 1

        return stack
    }

    @objc private func handleActionTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        actionHandlers[view.tag]()
    }
}
