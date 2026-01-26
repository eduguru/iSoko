//
//  BadgeView.swift
//  
//
//  Created by Edwin Weru on 25/01/2026.
//

import UIKit

final class BadgeView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])

        layer.cornerRadius = 10
    }

    func configure(text: String, textColor: UIColor, backgroundColor: UIColor) {
        label.text = text
        label.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
