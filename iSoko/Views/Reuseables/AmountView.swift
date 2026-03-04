//
//  AmountView.swift
//  
//
//  Created by Edwin Weru on 04/03/2026.
//

import UIKit

final class AmountView: UIView {

    private let amountLabel = UILabel()

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
        backgroundColor = UIColor.systemGray5

        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.textAlignment = .center
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(amountLabel)

        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func setAmount(_ text: String) {
        amountLabel.text = text
    }
}
