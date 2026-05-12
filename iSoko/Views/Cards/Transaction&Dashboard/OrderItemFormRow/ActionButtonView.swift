//
//  ActionButtonView.swift
//  
//
//  Created by Edwin Weru on 12/05/2026.
//

import UIKit

// MARK: - Action Button View

final class ActionButtonView: UIControl {

    private let titleLabelView = UILabel()

    private var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {

        layer.cornerRadius = 10
        layer.masksToBounds = true

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 52)
        ])

        titleLabelView.font = .systemFont(ofSize: 15, weight: .semibold)

        titleLabelView.textAlignment = .center

        titleLabelView.adjustsFontSizeToFitWidth = true
        titleLabelView.minimumScaleFactor = 0.8
        titleLabelView.numberOfLines = 1

        titleLabelView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabelView)

        NSLayoutConstraint.activate([
            titleLabelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabelView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addTarget(
            self,
            action: #selector(handleTap),
            for: .touchUpInside
        )
    }

    func configure(with config: ActionButtonConfig) {

        titleLabelView.text = config.title
        titleLabelView.textColor = config.textColor

        onTap = config.onTap

        switch config.style {

        case .filled:

            backgroundColor = config.backgroundColor
            layer.borderWidth = 0

        case .outlined:

            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = config.borderColor.cgColor

        case .subtle:

            backgroundColor = config.backgroundColor
            layer.borderWidth = 0
        }
    }

    @objc
    private func handleTap() {
        onTap?()
    }
}
