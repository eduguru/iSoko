//
//  InlineActionButton.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

final class InlineActionButton: UIView {

    private let iconView = UIImageView()
    private let label = UILabel()
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
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)

        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemBlue

        stack.axis = .horizontal
        stack.spacing = 4
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

        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(tap)
        ))
    }

    func configure(with config: InlineActionConfig) {
        label.text = config.title
        iconView.image = config.icon
        iconView.isHidden = config.icon == nil
        onTap = config.onTap
    }

    @objc private func tap() {
        onTap?()
    }
}
