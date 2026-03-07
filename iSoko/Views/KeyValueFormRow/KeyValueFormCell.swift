//
//  KeyValueFormCell.swift
//  
//
//  Created by Edwin Weru on 05/03/2026.
//

import UIKit
import DesignSystemKit

public final class KeyValueFormCell: UITableViewCell {

    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide

    private let cardView = UIView()
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()

    private let stackView = UIStackView()

    private let topDivider = UIView()
    private let bottomDivider = UIView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Card view (background only)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .secondarySystemBackground
        cardView.layer.cornerRadius = 12

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])

        // Labels
        leftLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightLabel.setContentHuggingPriority(.required, for: .horizontal)
        rightLabel.textAlignment = .right

        // Stack
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(rightLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        // Dividers
        topDivider.backgroundColor = .separator
        bottomDivider.backgroundColor = .separator

        topDivider.translatesAutoresizingMaskIntoConstraints = false
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(topDivider)
        contentView.addSubview(bottomDivider)

        NSLayoutConstraint.activate([
            topDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topDivider.topAnchor.constraint(equalTo: contentView.topAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 0.5),

            bottomDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    public func configure(with model: KeyValueRowModel) {

        leftLabel.text = model.leftText
        rightLabel.text = model.rightText

        leftLabel.numberOfLines = model.maxLeftLines == 0 ? 0 : model.maxLeftLines
        rightLabel.numberOfLines = model.maxRightLines == 0 ? 0 : model.maxRightLines

        leftLabel.lineBreakMode = model.leftEllipsis.lineBreakMode
        rightLabel.lineBreakMode = model.rightEllipsis.lineBreakMode

        applyStyling(to: leftLabel, style: model.leftFontStyle)
        applyStyling(to: rightLabel, style: model.rightFontStyle)

        leftLabel.textColor = model.leftColor ?? .label
        rightLabel.textColor = model.rightColor ?? .label

        if model.usesMonospacedDigits {
            rightLabel.font = rightLabel.font.monospacedDigit()
        }

        cardView.isHidden = !model.showsCard

        topDivider.isHidden = !model.showsTopDivider
        bottomDivider.isHidden = !model.showsBottomDivider

        if model.isEmphasized {
            leftLabel.font = styleGuide.font(for: .headline)
            rightLabel.font = styleGuide.font(for: .headline)
        }
    }

    private func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
