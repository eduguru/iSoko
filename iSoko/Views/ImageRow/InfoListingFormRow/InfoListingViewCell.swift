//
//  InfoListingViewCell.swift
//  
//
//  Created by Edwin Weru on 14/01/2026.
//

import UIKit
import DesignSystemKit

class InfoListingViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    // Define the configuration model
    private var model: InfoListingModel?

    private let styleGuide: StyleGuideProtocol = DesignSystemKit.sharedStyleGuide

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        addTapGesture()
    }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        model?.onTap?()
    }

    public func configure(with model: InfoListingModel) {
        self.model = model

        containerView.backgroundColor = model.cardBackgroundColor
        containerView.layer.cornerRadius = model.cardRadius

        imgView.image = model.icon ?? UIImage.addDocument
        imgView.tintColor = .app(.primary)

        labelTitle.text = model.title
        labelSubTitle.text = model.subtitle
        labelDesc.text = model.desc

        labelTitle.numberOfLines = 0
        labelSubTitle.numberOfLines = 0
        labelDesc.numberOfLines = 0

        applyStyling(to: labelTitle, style: .body)
        applyStyling(to: labelSubTitle, style: .headline)
        applyStyling(to: labelDesc, style: .callout)
    }

    private func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
