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

    private var actions: [HubCardConfig.Action] = []
    var onActionTap: ((String) -> Void)?

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

        // Header setup
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

        // Grid setup
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

    public func configure(with config: HubCardConfig, onActionTap: ((String) -> Void)? = nil) {
        print("💠 HubCardCell configure called")
        self.actions = config.actions
        self.onActionTap = onActionTap

        containerView.backgroundColor = config.backgroundColor
        containerView.layer.cornerRadius = config.cornerRadius
        containerView.layer.borderWidth = config.borderWidth
        containerView.layer.borderColor = config.borderColor.cgColor

        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
        subtitleLabel.isHidden = config.subtitle == nil

        iconImageView.image = config.icon
        iconContainer.backgroundColor = config.iconBackgroundColor ?? .clear
        iconContainer.layer.cornerRadius = 12

        headerStack.isHidden = config.title == nil && config.icon == nil

        setupGrid(actions: config.actions, columns: config.numberOfColumns)
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
                let view = makeActionView(action)
                rowStack.addArrangedSubview(view)
            }

            gridStack.addArrangedSubview(rowStack)
        }
    }

    private func makeActionView(_ action: HubCardConfig.Action) -> UIView {
        // Outer control handles all taps
        let control = UIControl()
        control.accessibilityIdentifier = action.id
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = .systemGray5
        control.layer.cornerRadius = 12
        control.clipsToBounds = true

        // Tap and feedback
        control.addTarget(self, action: #selector(handleActionTap(_:)), for: .touchUpInside)
        control.addTarget(self, action: #selector(handleTouchDown(_:)), for: [.touchDown, .touchDragEnter])
        control.addTarget(self, action: #selector(handleTouchUp(_:)), for: [.touchUpInside, .touchCancel, .touchDragExit])

        // Content stack
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false  // 🚀 super important: stack itself won't block touches

        // Icon
        let icon = UIImageView(image: action.icon)
        icon.tintColor = .app(.primary)
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.isUserInteractionEnabled = false // 🚀 disable interaction
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28)
        ])

        // Label
        let label = UILabel()
        label.text = action.title.uppercased()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isUserInteractionEnabled = false // 🚀 disable interaction

        // Add to stack
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        control.addSubview(stack)

        // Stack fills the control with padding
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: control.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: control.trailingAnchor, constant: -12)
        ])

        return control
    }

    @objc private func handleActionTap(_ sender: UIControl) {
        guard let id = sender.accessibilityIdentifier else { return }
        print("🔥 Action tapped with id: \(id)")
        onActionTap?(id)

//        if let action = actions.first(where: { $0.id == id }) {
//            print("✅ Triggering action closure for \(action.title)")
//            action.onTap?()
//        }
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
