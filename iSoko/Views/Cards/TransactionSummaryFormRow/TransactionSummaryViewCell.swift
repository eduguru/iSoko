//
//  TransactionSummaryViewCell.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

class TransactionSummaryViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCallout: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    private var tapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tap)
        containerView.isUserInteractionEnabled = true

        labelTitle.numberOfLines = 0
        labelCallout.numberOfLines = 0
        labelDesc.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: TransactionSummaryModel) {

        containerView.isHidden = model.isHidden ?? false

        // Content
        imgView.image = model.image
        imgView.isHidden = model.image == nil

        labelTitle.text = model.title
        labelTitle.isHidden = model.title == nil

        labelCallout.text = model.callout
        labelCallout.isHidden = model.callout == nil

        labelDesc.text = model.description
        labelDesc.isHidden = model.description == nil

        // Styling
        if let bgColor = model.backgroundColor {
            containerView.backgroundColor = bgColor
        }

        if let radius = model.cornerRadius {
            containerView.layer.cornerRadius = radius
            containerView.clipsToBounds = true
        }

        // Tap
        tapAction = model.onTap
        containerView.isUserInteractionEnabled = tapAction != nil
    }

    @objc private func containerTapped() {
        tapAction?()
    }
    
}

//let model = TransactionSummaryModel(
//    image: UIImage(systemName: "arrow.up.right"),
//    title: "Sent Money",
//    callout: "-$120.00",
//    description: "To John • Today",
//    backgroundColor: .secondarySystemBackground,
//    cornerRadius: 14,
//    onTap: { [weak self] in
//        self?.openTransactionDetails()
//    }
//)
