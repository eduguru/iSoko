//
//  QuantityStepperCell.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit

final class QuantityStepperCell: UITableViewCell {

    static let reuseIdentifier = String(describing: QuantityStepperCell.self)

    private let titleLabel = UILabel()
    private let stepperView = QuantityStepperView()

    var onValueChanged: ((Int) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stepperView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(stepperView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stepperView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stepperView.widthAnchor.constraint(equalToConstant: 120),
            stepperView.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: stepperView.leadingAnchor, constant: -12),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
        ])

        stepperView.onValueChanged = { [weak self] value in
            self?.onValueChanged?(value)
        }
    }

    func configure(title: String, initialValue: Int) {
        titleLabel.text = title
        stepperView.value = initialValue
    }
}
