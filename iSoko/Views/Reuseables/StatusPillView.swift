//
//  StatusPillView.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

final class StatusPillView: UIView {

    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 14
        layer.masksToBounds = true

        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    func configure(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        label.text = text
        label.textColor = textColor
        self.backgroundColor = backgroundColor
        isHidden = text == nil
    }
}
