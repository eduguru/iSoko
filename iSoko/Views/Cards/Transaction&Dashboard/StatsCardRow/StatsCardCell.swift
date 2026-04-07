//
//  StatsCardCell.swift
//  
//
//  Created by Edwin Weru on 26/03/2026.
//

import UIKit

public final class StatsCardCell: UITableViewCell {

    private let stackView = UIStackView()
    private var items: [StatsCardItem] = []

    var onItemTap: ((String) -> Void)?

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

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    public func configure(with config: StatsCardConfig) {
        self.items = config.items

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.spacing = config.spacing

        for item in config.items {
            let view = makeCard(item: item, config: config)
            stackView.addArrangedSubview(view)
        }
    }

    private func makeCard(item: StatsCardItem, config: StatsCardConfig) -> UIView {
        let control = UIControl()
        control.accessibilityIdentifier = item.id
        control.layer.cornerRadius = config.cornerRadius
        control.clipsToBounds = true
        control.backgroundColor = config.showsBackground ? (item.backgroundColor ?? UIColor.systemGray6) : .clear

        // Tap events
        control.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        control.addTarget(self, action: #selector(handleDown(_:)), for: [.touchDown, .touchDragEnter])
        control.addTarget(self, action: #selector(handleUp(_:)), for: [.touchUpInside, .touchCancel, .touchDragExit])

        // Stack for content
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading // ← Align all content to leading (left)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isUserInteractionEnabled = false

        // Icon container (badge)
        let iconContainer = UIView()
        iconContainer.backgroundColor = item.iconBackgroundColor ?? UIColor.systemGray5
        iconContainer.layer.cornerRadius = 10
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: item.icon)
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false

        iconContainer.addSubview(icon)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),

            icon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Labels
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.numberOfLines = 2

        let valueLabel = UILabel()
        valueLabel.text = item.value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .label

        // Add views to stack
        stack.addArrangedSubview(iconContainer)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)

        // Add stack to control
        control.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: control.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: control.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: control.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: control.bottomAnchor, constant: -12)
        ])

        return control
    }

    // MARK: - Actions

    @objc private func handleTap(_ sender: UIControl) {
        guard let id = sender.accessibilityIdentifier else { return }
        onItemTap?(id)
    }

    @objc private func handleDown(_ sender: UIControl) {
        UIView.animate(withDuration: 0.15) {
            sender.alpha = 0.7
            sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc private func handleUp(_ sender: UIControl) {
        UIView.animate(withDuration: 0.15) {
            sender.alpha = 1.0
            sender.transform = .identity
        }
    }
}
