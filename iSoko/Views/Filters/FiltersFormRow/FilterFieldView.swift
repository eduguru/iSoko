//
//  FilterFieldView.swift
//  
//
//  Created by Edwin Weru on 26/01/2026.
//

import UIKit

final class FilterFieldView: UIView {

    private let label = UILabel()
    private let chevron = UIImageView()
    private let clearButton = UIButton(type: .system)

    private let stack = UIStackView()
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

        label.font = .preferredFont(forTextStyle: .body)

        chevron.image = UIImage(systemName: "chevron.down")
        chevron.tintColor = .secondaryLabel

        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .secondaryLabel
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(clearButton)
        stack.addArrangedSubview(chevron)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])

        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapped))
        )
    }

    func configure(with config: FilterFieldConfig) {
        if let value = config.selectedValue {
            label.text = value
            label.textColor = .label
        } else {
            label.text = config.placeholder
            label.textColor = .secondaryLabel
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
