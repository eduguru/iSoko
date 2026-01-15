//
//  RichDescriptionFormCell.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import UIKit
import DesignSystemKit

public final class RichDescriptionFormCell: UITableViewCell {

    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0 // unlimited

        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    public func configure(with model: RichDescriptionModel) {

        if let title = model.title {
            titleLabel.isHidden = false
            titleLabel.text = title
            titleLabel.numberOfLines = model.maxTitleLines
            applyStyling(to: titleLabel, style: model.titleFontStyle)
        } else {
            titleLabel.isHidden = true
        }

        descriptionLabel.attributedText = model.htmlDescription
            .htmlToAttributedString(
                font: styleGuide.font(for: model.descriptionFontStyle),
                textColor: .label,
                alignment: model.textAlignment
            )

        descriptionLabel.textAlignment = model.textAlignment
    }

    private func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
