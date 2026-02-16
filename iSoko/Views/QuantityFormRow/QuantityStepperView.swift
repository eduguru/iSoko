//
//  QuantityStepperView.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit

final class QuantityStepperView: UIView {

    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let valueLabel = UILabel()
    private let container = UIStackView()

    var value: Int = 1 {
        didSet {
            value = max(1, value)
            valueLabel.text = "\(value)"
            onValueChanged?(value)
        }
    }

    var onValueChanged: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {

        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = UIColor.systemGray6

        minusButton.setTitle("–", for: .normal)
        minusButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)

        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)

        valueLabel.font = .systemFont(ofSize: 18, weight: .medium)
        valueLabel.textAlignment = .center
        valueLabel.text = "1"

        minusButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increment), for: .touchUpInside)

        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .fillEqually
        container.translatesAutoresizingMaskIntoConstraints = false

        container.addArrangedSubview(minusButton)
        container.addArrangedSubview(valueLabel)
        container.addArrangedSubview(plusButton)

        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),

            heightAnchor.constraint(equalToConstant: 44),
            widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    @objc private func decrement() {
        value -= 1
    }

    @objc private func increment() {
        value += 1
    }
}
