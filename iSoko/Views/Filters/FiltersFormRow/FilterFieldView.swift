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

        // ✅ Base styling
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.withAlphaComponent(0.5).cgColor

        // Optional subtle elevation (comment out if you want flat UI)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.02
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2

        // Label
        label.font = .preferredFont(forTextStyle: .body)

        // Trailing icon
        trailingIcon.tintColor = .secondaryLabel
        trailingIcon.setContentHuggingPriority(.required, for: .horizontal)

        // Clear button
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .secondaryLabel
        clearButton.setContentHuggingPriority(.required, for: .horizontal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

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

        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    // MARK: - Configure
    func configure(with config: FilterFieldConfig) {

        // Text
        if let value = config.selectedValue {
            label.text = value
            label.textColor = .label
        } else {
            label.text = config.placeholder
            label.textColor = .secondaryLabel
        }

        // Clear button
        clearButton.isHidden = !config.showsClearButton || config.selectedValue == nil

        // ✅ Smart trailing icon logic
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

    // MARK: - Interaction

    @objc private func tapped() {
        onTap?()
    }

    @objc private func clearTapped() {
        onClear?()
    }

    // MARK: - Press Feedback

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15) {
                self.backgroundColor = self.isHighlighted
                ? UIColor.systemGray5
                : UIColor.systemBackground
            }
        }
    }

    // MARK: - Focus State (Optional external control)

    func setActive(_ active: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = active
            ? UIColor.systemBlue.cgColor
            : UIColor.separator.withAlphaComponent(0.5).cgColor
        }
    }
}
