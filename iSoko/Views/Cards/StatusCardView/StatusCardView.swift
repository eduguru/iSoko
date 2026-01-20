//
//  StatusCardView.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

final class StatusCardView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // Default shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        // Default content styling
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
    }

    func configure(with model: StatusCardViewModel) {

        // Content
        titleLabel.text = model.title
        iconImageView.image = model.image

        // Background
        if let bgColor = model.backgroundColor {
            contentView.backgroundColor = bgColor
        }

        // Corner radius
        if let radius = model.cornerRadius {
            contentView.layer.cornerRadius = radius
        }

        // Border
        if let borderColor = model.borderColor {
            contentView.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = model.borderWidth {
            contentView.layer.borderWidth = borderWidth
        }

        // Shadow overrides
        if let shadowColor = model.shadowColor {
            layer.shadowColor = shadowColor.cgColor
        }
        if let shadowOpacity = model.shadowOpacity {
            layer.shadowOpacity = shadowOpacity
        }
        if let shadowRadius = model.shadowRadius {
            layer.shadowRadius = shadowRadius
        }
        if let shadowOffset = model.shadowOffset {
            layer.shadowOffset = shadowOffset
        }

        // Icon styling
        if let tintColor = model.iconTintColor {
            iconImageView.tintColor = tintColor
        }

        // Text styling
        if let textColor = model.textColor {
            titleLabel.textColor = textColor
        }
        if let font = model.font {
            titleLabel.font = font
        }
    }
}

//let model = StatusCardViewModel(
//    title: "Payment Successful",
//    image: UIImage(systemName: "checkmark.circle.fill"),
//    backgroundColor: .systemGreen.withAlphaComponent(0.1),
//    cornerRadius: 16,
//    borderColor: .systemGreen,
//    borderWidth: 1,
//    iconTintColor: .systemGreen,
//    textColor: .systemGreen
//)
//
//statusCardView.configure(with: model)
