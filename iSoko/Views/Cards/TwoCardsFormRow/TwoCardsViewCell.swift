//
//  TwoCardsViewCell.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

class TwoCardsViewCell: UITableViewCell {

    @IBOutlet weak var cardViewLeft: UIView!
    @IBOutlet weak var cardViewRight: UIView!
    
    @IBOutlet weak var statusCardLeft: StatusCardView!
    @IBOutlet weak var statusCardRight: StatusCardView!
    
    @IBOutlet weak var titleIconLeft: UIImageView!
    @IBOutlet weak var titleIconRight: UIImageView!
    
    @IBOutlet weak var titleLabelLeft: UILabel!
    @IBOutlet weak var titleLabelRight: UILabel!
    
    @IBOutlet weak var descLabelLeft: UILabel!
    @IBOutlet weak var descLabelRight: UILabel!
    
    private var leftTapAction: (() -> Void)?
    private var rightTapAction: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftCardTapped))
        cardViewLeft.addGestureRecognizer(leftTap)
        cardViewLeft.isUserInteractionEnabled = true

        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightCardTapped))
        cardViewRight.addGestureRecognizer(rightTap)
        cardViewRight.isUserInteractionEnabled = true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: TwoCardsModel) {

        configureCard(
            model: model.leftCard,
            container: cardViewLeft,
            titleIcon: titleIconLeft,
            titleLabel: titleLabelLeft,
            descLabel: descLabelLeft,
            statusCard: statusCardLeft
        )
        leftTapAction = model.leftCard?.onTap
        cardViewLeft.isUserInteractionEnabled = leftTapAction != nil

        configureCard(
            model: model.rightCard,
            container: cardViewRight,
            titleIcon: titleIconRight,
            titleLabel: titleLabelRight,
            descLabel: descLabelRight,
            statusCard: statusCardRight
        )
        rightTapAction = model.rightCard?.onTap
        cardViewRight.isUserInteractionEnabled = rightTapAction != nil
    }
    
    @objc private func leftCardTapped() {
        leftTapAction?()
    }

    @objc private func rightCardTapped() {
        rightTapAction?()
    }

    
}

private extension TwoCardsViewCell {

    func configureCard(
        model: CardModel?,
        container: UIView,
        titleIcon: UIImageView,
        titleLabel: UILabel,
        descLabel: UILabel,
        statusCard: StatusCardView
    ) {
        guard let model = model else {
            container.isHidden = true
            return
        }

        container.isHidden = model.isHidden ?? false

        // Header
        titleLabel.text = model.title
        titleLabel.isHidden = model.title == nil

        titleIcon.image = model.titleIcon
        titleIcon.isHidden = model.titleIcon == nil

        // Description
        descLabel.text = model.description
        descLabel.isHidden = model.description == nil

        // Status card
        if let statusModel = model.statusModel {
            statusCard.isHidden = false
            statusCard.configure(with: statusModel)
        } else {
            statusCard.isHidden = true
        }

        // Background
        if let bgColor = model.backgroundColor {
            container.backgroundColor = bgColor
        }
    }
}


//let leftCard = CardModel(
//    title: "Balance",
//    titleIcon: UIImage(systemName: "wallet.pass"),
//    description: "$1,240.00",
//    onTap: { [weak self] in
//        self?.openBalance()
//    }
//)
//
//let rightCard = CardModel(
//    title: "Transactions",
//    titleIcon: UIImage(systemName: "list.bullet"),
//    description: "View history",
//    onTap: { [weak self] in
//        self?.openTransactions()
//    }
//)
//
//let model = TwoCardsModel(
//    leftCard: leftCard,
//    rightCard: rightCard
//)
