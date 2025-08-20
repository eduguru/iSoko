//
//  TitleDescriptionFormCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit
import DesignSystemKit

public final class TitleDescriptionFormCell: UITableViewCell {
    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var stackView: UIStackView!
    
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
        
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        descriptionLabel.textColor = .secondaryLabel
        
        stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    public func configure(with model: TitleDescriptionModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description

        titleLabel.numberOfLines = model.maxTitleLines == 0 ? 0 : model.maxTitleLines
        descriptionLabel.numberOfLines = model.maxDescriptionLines == 0 ? 0 : model.maxDescriptionLines

        titleLabel.lineBreakMode = model.titleEllipsis.lineBreakMode
        descriptionLabel.lineBreakMode = model.descriptionEllipsis.lineBreakMode

        titleLabel.textAlignment = model.textAlignment
        descriptionLabel.textAlignment = model.textAlignment

        // Adjust stack layout
        switch model.layoutStyle {
        case .stackedVertical:
            stackView.axis = .vertical
            stackView.spacing = 6
        case .stackedHorizontal:
            stackView.axis = .horizontal
            stackView.spacing = 12
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        applyStyling(to: titleLabel, style: model.titleFontStyle)
        applyStyling(to: descriptionLabel, style: model.descriptionFontStyle)
    }

    
    public func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
