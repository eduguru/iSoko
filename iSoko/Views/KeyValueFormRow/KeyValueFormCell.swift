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

    // Card constraints
    private var cardLeadingConstraint: NSLayoutConstraint!
    private var cardTrailingConstraint: NSLayoutConstraint!
    private var cardTopConstraint: NSLayoutConstraint!
    private var cardBottomConstraint: NSLayoutConstraint!

    // Stack constraints (inside card or contentView)
    private var stackLeadingConstraint: NSLayoutConstraint!
    private var stackTrailingConstraint: NSLayoutConstraint!
    private var stackTopConstraint: NSLayoutConstraint!
    private var stackBottomConstraint: NSLayoutConstraint!

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

        // Labels
        leftLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightLabel.setContentHuggingPriority(.required, for: .horizontal)
        rightLabel.textAlignment = .right

        // Stack
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(UIView()) // spacer
        stackView.addArrangedSubview(rightLabel)

        // Card
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .clear
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = true

        contentView.addSubview(cardView)
        cardView.addSubview(stackView)

        // Card constraints
        cardLeadingConstraint = cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        cardTrailingConstraint = cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        cardTopConstraint = cardView.topAnchor.constraint(equalTo: contentView.topAnchor)
        cardBottomConstraint = cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([
            cardLeadingConstraint,
            cardTrailingConstraint,
            cardTopConstraint,
            cardBottomConstraint
        ])

        // Stack constraints (we will adjust constants later)
        stackLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16)
        stackTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        stackTopConstraint = stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12)
        stackBottomConstraint = stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        NSLayoutConstraint.activate([
            stackLeadingConstraint,
            stackTrailingConstraint,
            stackTopConstraint,
            stackBottomConstraint
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

        topDivider.isHidden = !model.showsTopDivider
        bottomDivider.isHidden = !model.showsBottomDivider

        if model.isEmphasized {
            leftLabel.font = styleGuide.font(for: .headline)
            rightLabel.font = styleGuide.font(for: .headline)
        }

        if let card = model.card {

            cardView.backgroundColor = card.backgroundColor
            cardView.layer.cornerRadius = card.cornerRadius
            cardView.layer.borderColor = card.borderColor?.cgColor
            cardView.layer.borderWidth = card.borderWidth

            cardLeadingConstraint.constant = 16
            cardTrailingConstraint.constant = -16
            cardTopConstraint.constant = 6
            cardBottomConstraint.constant = -6

            stackLeadingConstraint.constant = card.contentInsets.left
            stackTrailingConstraint.constant = -card.contentInsets.right
            stackTopConstraint.constant = card.contentInsets.top
            stackBottomConstraint.constant = -card.contentInsets.bottom

        } else {
            // No card styling
            cardView.backgroundColor = .clear
            cardView.layer.cornerRadius = 0
            cardView.layer.borderWidth = 0

            cardLeadingConstraint.constant = 0
            cardTrailingConstraint.constant = 0
            cardTopConstraint.constant = 0
            cardBottomConstraint.constant = 0

            stackLeadingConstraint.constant = 16
            stackTrailingConstraint.constant = -16
            stackTopConstraint.constant = 12
            stackBottomConstraint.constant = -12
        }
    }

    private func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
