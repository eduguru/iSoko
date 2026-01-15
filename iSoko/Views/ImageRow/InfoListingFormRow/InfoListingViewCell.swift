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
        
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    // Method to configure the cell with the model
    public func configure(with model: InfoListingModel) {
        self.model = model
        
        containerView.backgroundColor = model.cardBackgroundColor
        containerView.layer.cornerRadius = model.cardRadius
        
        imgView.image = model.icon ?? UIImage.addDocument
        imageView?.tintColor = .app(.primary)
//
        labelTitle.text = model.title ?? "no ttle"
        labelSubTitle.text = model.subtitle ?? "noda"
        labelDesc.text = model.desc ?? "nada"
        
        labelTitle.numberOfLines = 0
        labelSubTitle.numberOfLines = 0
        labelDesc.numberOfLines = 0
        
        applyStyling(to: labelTitle, style: FontStyle.body)
        applyStyling(to: labelSubTitle, style: FontStyle.headline)
        applyStyling(to: labelDesc, style: FontStyle.callout)
    }
    
    public func applyStyling(to label: UILabel, style: FontStyle) {
        label.font = styleGuide.font(for: style)
    }
}
