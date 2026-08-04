//
//  InfoPairItemView.swift
//  
//
//  Created by Edwin Weru on 04/08/2026.
//

import UIKit

// MARK: - Row Item View

public final class InfoPairItemView: UIView {

    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let labelStack = UIStackView()
    private let topLabel = UILabel()
    private let valueLabel = UILabel()
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
        // Icon container
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.layer.cornerRadius = 8
        iconContainer.clipsToBounds = true
        addSubview(iconContainer)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainer.topAnchor.constraint(equalTo: topAnchor, constant: 2),

            iconImageView.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: -8),
            iconImageView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 8),
            iconImageView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: -8)
        ])

        // Labels
        topLabel.font = .systemFont(ofSize: 14, weight: .medium)
        topLabel.textColor = .secondaryLabel
        topLabel.numberOfLines = 0

        valueLabel.font = .systemFont(ofSize: 14, weight: .regular)
        valueLabel.numberOfLines = 0

        labelStack.axis = .vertical
        labelStack.spacing = 2
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.addArrangedSubview(topLabel)
        labelStack.addArrangedSubview(valueLabel)
        addSubview(labelStack)

        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            labelStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStack.topAnchor.constraint(equalTo: topAnchor),
            labelStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    func configure(with item: InfoPairItem, iconTintColor: UIColor, iconBackgroundColor: UIColor) {
        self.onTap = item.onTap

        iconContainer.backgroundColor = iconBackgroundColor
        iconImageView.image = item.icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = iconTintColor

        topLabel.text = item.label

        if let value = item.value, !value.isEmpty {
            valueLabel.isHidden = false
            valueLabel.text = value
            valueLabel.textColor = item.valueColor

            if item.isLink {
                valueLabel.textColor = .systemBlue
                let attributed = NSAttributedString(
                    string: value,
                    attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
                )
                valueLabel.attributedText = attributed
            } else {
                valueLabel.attributedText = nil
                valueLabel.text = value
                valueLabel.textColor = item.valueColor
            }
        } else {
            valueLabel.isHidden = true
        }
    }

    @objc private func handleTap() {
        onTap?()
    }
}
