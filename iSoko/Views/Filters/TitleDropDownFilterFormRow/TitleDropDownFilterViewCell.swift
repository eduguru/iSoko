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
    
    @IBOutlet weak var buttonFilter: IconLabelActionView!
    
    private var filterTapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        labelTitle.numberOfLines = 1
        labelDesc.numberOfLines = 1

        labelTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        labelDesc.font = .systemFont(ofSize: 13)
        labelDesc.textColor = .secondaryLabel
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

        buttonFilter.text = model.filterTitle ?? ""
        buttonFilter.icon = model.filterIcon
        buttonFilter.isHidden = model.filterTitle == nil && model.filterIcon == nil

        buttonFilter.addTarget(self, action: #selector(actionFilter), for: .touchUpInside)
        
        // In configure(with:)
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionFilter))
        buttonFilter.addGestureRecognizer(tap)
        buttonFilter.isUserInteractionEnabled = true


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
