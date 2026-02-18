//
//  FilterFieldView.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

final class FilterFieldView: UIControl {

    private let iconImageView = UIImageView()
    private let label = UILabel()
    private let chevron = UIImageView()
    private let clearButton = UIButton(type: .system)

    private let stack = UIStackView()
    private let spacer = UIView()

    private var onTap: (() -> Void)?
    private var onClear: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 10

        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .secondaryLabel
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.isHidden = true

        // Label
        label.font = .preferredFont(forTextStyle: .body)

        // Chevron
        chevron.image = UIImage(systemName: "chevron.down")
        chevron.tintColor = .secondaryLabel
        chevron.setContentHuggingPriority(.required, for: .horizontal)

        // Clear button
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .secondaryLabel
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clearButton.setContentHuggingPriority(.required, for: .horizontal)

        // Stack
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(clearButton)
        stack.addArrangedSubview(chevron)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])

        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    func configure(with config: FilterFieldConfig) {

        if let value = config.selectedValue {
            label.text = value
            label.textColor = .label
        } else {
            label.text = config.placeholder
            label.textColor = .secondaryLabel
        }

        if let iconName = config.iconSystemName {
            iconImageView.image = UIImage(systemName: iconName)
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }

        clearButton.isHidden = !config.showsClearButton || config.selectedValue == nil

        onTap = config.onTap
        onClear = config.onClear
    }

    @objc private func tapped() {
        onTap?()
    }

    @objc private func clearTapped() {
        onClear?()
    }
}
