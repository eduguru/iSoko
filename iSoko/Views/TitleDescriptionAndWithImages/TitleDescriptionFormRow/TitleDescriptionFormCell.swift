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
    
    private let dividerView = UIView()
    private let cardView = UIView()
    
    // 👇 Constraints we will adjust dynamically
    private var cardLeadingConstraint: NSLayoutConstraint!
    private var cardTrailingConstraint: NSLayoutConstraint!
    private var cardTopConstraint: NSLayoutConstraint!
    private var cardBottomConstraint: NSLayoutConstraint!
    
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
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        // Divider
        dividerView.backgroundColor = .separator
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Stack
        stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            dividerView,
            descriptionLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Card
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(stackView)
        contentView.addSubview(cardView)
        
        // Card constraints (we will tweak constants later)
        cardLeadingConstraint = cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        cardTrailingConstraint = cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        cardTopConstraint = cardView.topAnchor.constraint(equalTo: contentView.topAnchor)
        cardBottomConstraint = cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            cardLeadingConstraint,
            cardTrailingConstraint,
            cardTopConstraint,
            cardBottomConstraint,
            
            // Stack inside card
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
    
    public func configure(with model: TitleDescriptionModel) {
        
        // Text
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        // Lines
        titleLabel.numberOfLines = model.maxTitleLines == 0 ? 0 : model.maxTitleLines
        descriptionLabel.numberOfLines = model.maxDescriptionLines == 0 ? 0 : model.maxDescriptionLines
        
        // Ellipsis
        titleLabel.lineBreakMode = model.titleEllipsis.lineBreakMode
        descriptionLabel.lineBreakMode = model.descriptionEllipsis.lineBreakMode
        
        // Alignment
        titleLabel.textAlignment = model.textAlignment
        descriptionLabel.textAlignment = model.textAlignment
        
        // Divider
        dividerView.isHidden = !model.showsDivider
        
        // Layout
        switch model.layoutStyle {
        case .stackedVertical:
            stackView.axis = .vertical
            stackView.spacing = model.showsDivider ? 8 : 6
            
        case .stackedHorizontal:
            stackView.axis = .horizontal
            stackView.spacing = 12
            
            dividerView.isHidden = true
            
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        
        // 👇 Card handling (NEW STRUCT-BASED)
        if let card = model.card {
            
            // Outer spacing (fixes full width issue)
            cardLeadingConstraint.constant = 16
            cardTrailingConstraint.constant = -16
            cardTopConstraint.constant = 8
            cardBottomConstraint.constant = -8
            
            // Appearance
            cardView.backgroundColor = card.backgroundColor
            cardView.layer.cornerRadius = card.cornerRadius
            cardView.layer.masksToBounds = true
            
            if let borderColor = card.borderColor {
                cardView.layer.borderColor = borderColor.cgColor
                cardView.layer.borderWidth = card.borderWidth
            } else {
                cardView.layer.borderWidth = 0
            }
            
            // Inner padding
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = card.contentInsets
            
        } else {
            
            // Reset to original layout
            cardLeadingConstraint.constant = 16
            cardTrailingConstraint.constant = -16
            cardTopConstraint.constant = 0
            cardBottomConstraint.constant = 0
            
            cardView.backgroundColor = .clear
            cardView.layer.cornerRadius = 0
            cardView.layer.borderWidth = 0
            
            stackView.isLayoutMarginsRelativeArrangement = false
            stackView.layoutMargins = .zero
        }
        
        // Fonts
        applyStyling(to: titleLabel, style: model.titleFontStyle)
        applyStyling(to: descriptionLabel, style: model.descriptionFontStyle)
    }
    
    private func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
