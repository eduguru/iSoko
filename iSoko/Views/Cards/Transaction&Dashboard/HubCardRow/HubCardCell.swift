//
//  HubCardCell.swift
//  
//
//  Created by Edwin Weru on 18/03/2026.
//

import UIKit

// MARK: - HubCardCell

public final class HubCardCell: UITableViewCell {

    private let containerView = UIView()
    private let headerStack = UIStackView()
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let gridStack = UIStackView()

    // ✅ Cell owns actions for safe closure execution
    private var actions: [HubCardConfig.Action] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        // Header Stack
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center

        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 48),
            iconContainer.heightAnchor.constraint(equalToConstant: 48),
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        headerStack.addArrangedSubview(iconContainer)
        headerStack.addArrangedSubview(textStack)

        // Grid Stack
        gridStack.axis = .vertical
        gridStack.spacing = 12

        let mainStack = UIStackView(arrangedSubviews: [headerStack, gridStack])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    public func configure(with config: HubCardConfig) {
        self.actions = config.actions

        // Card styling
        containerView.backgroundColor = config.backgroundColor
        containerView.layer.cornerRadius = config.cornerRadius
        containerView.layer.borderWidth = config.borderWidth
        containerView.layer.borderColor = config.borderColor.cgColor

        // Header
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil
        iconImageView.image = config.icon
        iconContainer.backgroundColor = config.iconBackgroundColor ?? .clear
        iconContainer.layer.cornerRadius = 12
        headerStack.isHidden = config.title == nil && config.icon == nil

        // Grid
        setupGrid(actions: self.actions, columns: config.numberOfColumns)
    }

    private func setupGrid(actions: [HubCardConfig.Action], columns: Int) {
        gridStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !actions.isEmpty else {
            gridStack.isHidden = true
            return
        }

        gridStack.isHidden = false

        let rows = stride(from: 0, to: actions.count, by: columns).map {
            Array(actions[$0..<min($0 + columns, actions.count)])
        }

        for rowItems in rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually

            for action in rowItems {
                rowStack.addArrangedSubview(makeActionView(action))
            }

            gridStack.addArrangedSubview(rowStack)
        }
    }

    private func makeActionView(_ action: HubCardConfig.Action) -> UIView {
        let control = UIControl()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: action.icon)
        icon.tintColor = .systemBlue
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28)
        ])

        let label = UILabel()
        label.text = action.title.uppercased()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center

        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        control.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: control.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -8)
        ])

        // ✅ Tap handling via cell-owned actions array
        control.addAction(UIAction { [weak self] _ in
            guard let index = self?.actions.firstIndex(where: { $0.id == action.id }) else { return }
            self?.actions[index].onTap?()
        }, for: .touchUpInside)

        // Styling
        control.layer.cornerRadius = 12
        control.backgroundColor = UIColor.systemGray5

        // Highlight feedback
        control.addTarget(self, action: #selector(handleTouchDown(_:)), for: [.touchDown, .touchDragEnter])
        control.addTarget(self, action: #selector(handleTouchUp(_:)), for: [.touchUpInside, .touchCancel, .touchDragExit])

        return control
    }

    @objc private func handleTouchDown(_ sender: UIControl) {
        UIView.animate(withDuration: 0.15) {
            sender.alpha = 0.6
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    @objc private func handleTouchUp(_ sender: UIControl) {
        UIView.animate(withDuration: 0.15) {
            sender.alpha = 1.0
            sender.transform = .identity
        }
    }
}
