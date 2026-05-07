//
//  PaddedChipView.swift
//  
//
//  Created by Edwin Weru on 07/05/2026.
//

import UIKit

final class PaddedChipView: UIView {

    private let label = UILabel()

    init(text: String, icon: UIImage? = nil, tint: UIColor = .systemGreen) {
        super.init(frame: .zero)
        setup(text: text, icon: icon, tint: tint)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup(text: String, icon: UIImage?, tint: UIColor) {

        backgroundColor = tint.withAlphaComponent(0.15)
        layer.cornerRadius = 12
        clipsToBounds = true

        label.text = text
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = tint

        let stack = UIStackView(arrangedSubviews: [label])
        stack.axis = .horizontal
        stack.spacing = 6

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 26),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
