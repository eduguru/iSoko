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
    private let stack = UIStackView()

    private var _value: Int = 1
    private var minimumValue: Int = 1

    var value: Int {
        get { _value }
        set {
            let newVal = max(minimumValue, newValue)
            _value = newVal
            valueLabel.text = "\(_value)"

            minusButton.isEnabled = _value > minimumValue
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
        plusButton.setTitle("+", for: .normal)

        minusButton.setTitleColor(.systemBlue, for: .normal)
        plusButton.setTitleColor(.systemBlue, for: .normal)

        minusButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        plusButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)

        valueLabel.font = .systemFont(ofSize: 16, weight: .medium)
        valueLabel.textAlignment = .center

        minusButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increment), for: .touchUpInside)

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(minusButton)
        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(plusButton)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            heightAnchor.constraint(equalToConstant: 44),
            widthAnchor.constraint(equalToConstant: 120)
        ])
    }

    @objc private func decrement() {
        value = _value - 1
        onValueChanged?(value)
    }

    @objc private func increment() {
        value = _value + 1
        onValueChanged?(value)
    }

//    func configure(initialValue: Int, minimumValue: Int = 1) {
//        self.minimumValue = minimumValue
//        self.value = initialValue
//    }
    
    func configure(initialValue: Int, minimumValue: Int = 1) {
        self.minimumValue = minimumValue
        self.value = max(minimumValue, initialValue)
    }
}
