//
//  ActionCardView.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

final class ActionCardView: UIView {

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let stack = UIStackView()
    private var onTap: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 10
        layer.masksToBounds = true

        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        titleLabel.font = .preferredFont(forTextStyle: .subheadline)

        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(titleLabel)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(tap)
        ))
    }

    func configure(with config: ActionCardConfig) {
        titleLabel.text = config.title
        titleLabel.textColor = config.textColor
        iconView.image = config.icon
        iconView.isHidden = config.icon == nil
        backgroundColor = config.backgroundColor
        onTap = config.onTap
    }

    @objc private func tap() {
        onTap?()
    }
}
