//
//  TitleDropDownFilterViewCell.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit
import DesignSystemKit

class TitleDropDownFilterViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var buttonFilter: IconLabelButton!
    
    private var filterTapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        labelTitle.numberOfLines = 0
        labelDesc.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        filterTapAction?()
    }
    
    func configure(with model: TitleDropDownFilterModel) {

        containerView.isHidden = model.isHidden ?? false

        // Content
        labelTitle.text = model.title
        labelTitle.isHidden = model.title == nil

        labelDesc.text = model.description
        labelDesc.isHidden = model.description == nil

        // Button
        buttonFilter.setTitle(model.filterTitle, for: .normal)
        buttonFilter.setImage(model.filterIcon, for: .normal)
        buttonFilter.isHidden = model.filterTitle == nil && model.filterIcon == nil

        // Styling
        if let bgColor = model.backgroundColor {
            containerView.backgroundColor = bgColor
        }

        if let radius = model.cornerRadius {
            containerView.layer.cornerRadius = radius
            containerView.clipsToBounds = true
        }

        // Action
        filterTapAction = model.onFilterTap
        buttonFilter.isEnabled = filterTapAction != nil
    }

}

//let model = TitleDropDownFilterModel(
//    title: "Transactions",
//    description: "Showing last 30 days",
//    filterTitle: "Filter",
//    filterIcon: UIImage(systemName: "chevron.down"),
//    onFilterTap: { [weak self] in
//        self?.showFilterSheet()
//    }
//)
