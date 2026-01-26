//
//  IconValueRowView.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

final class IconValueRowView: UIView {

    private let iconView = UIImageView()
    private let label = UILabel()
    private let stack = UIStackView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .secondaryLabel
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        label.numberOfLines = 0

        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(label)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(
        icon: UIImage?,
        text: NSAttributedString?
    ) {
        iconView.image = icon
        iconView.isHidden = icon == nil
        label.attributedText = text
        isHidden = text == nil
    }
}
