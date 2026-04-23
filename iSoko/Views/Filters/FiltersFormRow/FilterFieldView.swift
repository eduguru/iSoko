//
//  FilterFieldView.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

// MARK: - Filter Field View
final class FilterFieldView: UIControl {

    private let label = UILabel()
    private let trailingIcon = UIImageView()
    private let clearButton = UIButton(type: .system)

    private let stack = UIStackView()
    private let spacer = UIView()

    private var onTap: (() -> Void)?
    private var onClear: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {

        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.withAlphaComponent(0.5).cgColor

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.02
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2

        // 🔥 CRITICAL: FULL TOUCH CONTROL
        isUserInteractionEnabled = true
        isExclusiveTouch = true

        // 🔥 CRITICAL: prevent ANY subview from stealing touches
        [label, trailingIcon, clearButton, stack, spacer].forEach {
            $0.isUserInteractionEnabled = false
        }

        // Label
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel

        // Icon
        trailingIcon.tintColor = .secondaryLabel
        trailingIcon.setContentHuggingPriority(.required, for: .horizontal)

        // Clear button (we still disable interaction but manually handle tap via config)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .secondaryLabel
        clearButton.setContentHuggingPriority(.required, for: .horizontal)

        // Stack
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(clearButton)
        stack.addArrangedSubview(trailingIcon)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        // 🔥 PRIMARY TAP HANDLER
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    // 🔥 CRITICAL FIX: ALWAYS FORCE FULL HIT AREA
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.contains(point)
    }

    // MARK: - Configure
    func configure(with config: FilterFieldConfig) {

        if let value = config.selectedValue {
            label.text = value
            label.textColor = .label
        } else {
            label.text = config.placeholder
            label.textColor = .secondaryLabel
        }

        clearButton.isHidden = !config.showsClearButton || config.selectedValue == nil

        let iconName = config.iconSystemName ?? (config.onTap != nil ? "chevron.down" : nil)

        if let iconName {
            trailingIcon.image = UIImage(systemName: iconName)
            trailingIcon.isHidden = false
        } else {
            trailingIcon.isHidden = true
        }

        onTap = config.onTap
        onClear = config.onClear
    }

    // MARK: - Actions
    @objc private func tapped() {
        onTap?()
    }

    @objc private func clearTapped() {
        onClear?()
    }

    // MARK: - Feedback
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = self.isHighlighted
                    ? UIColor.systemGray5
                    : UIColor.systemBackground
            }
        }
    }
}
