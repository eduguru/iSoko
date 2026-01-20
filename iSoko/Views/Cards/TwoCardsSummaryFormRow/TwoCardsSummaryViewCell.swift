//
//  TwoCardsSummaryViewCell.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit

class TwoCardsSummaryViewCell: UITableViewCell {

    @IBOutlet weak var stackViewTitle: UIStackView!
    @IBOutlet weak var stackViewLeft: UIStackView!
    @IBOutlet weak var stackViewRight: UIStackView!
    
    @IBOutlet weak var stackViewCards: UIStackView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var labelRight: UILabel!
    
    private var leftTapAction: (() -> Void)?
    private var rightTapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        labelTitle.numberOfLines = 0
        labelDesc.numberOfLines = 0
        labelLeft.numberOfLines = 0
        labelRight.numberOfLines = 0

        viewLeft.layer.cornerRadius = 12
        viewRight.layer.cornerRadius = 12
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftTapped))
        viewLeft.addGestureRecognizer(leftTap)
        viewLeft.isUserInteractionEnabled = true

        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightTapped))
        viewRight.addGestureRecognizer(rightTap)
        viewRight.isUserInteractionEnabled = true

    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: TwoCardsSummaryModel) {

        // Title section
        labelTitle.text = model.title
        labelTitle.isHidden = model.title == nil

        labelDesc.text = model.description
        labelDesc.isHidden = model.description == nil

        stackViewTitle.isHidden = model.title == nil && model.description == nil

        // Left card
        configureCard(
            model: model.leftCard,
            container: viewLeft,
            imageView: imgLeft,
            label: labelLeft,
            stackView: stackViewLeft
        )
        leftTapAction = model.leftCard?.onTap

        // Right card
        configureCard(
            model: model.rightCard,
            container: viewRight,
            imageView: imgRight,
            label: labelRight,
            stackView: stackViewRight
        )
        rightTapAction = model.rightCard?.onTap

        stackViewCards.isHidden = model.leftCard == nil && model.rightCard == nil
    }

    @objc private func leftTapped() {
        leftTapAction?()
    }

    @objc private func rightTapped() {
        rightTapAction?()
    }
    
    private func animatePress(on view: UIView) {
        UIView.animate(withDuration: 0.1) {
            view.alpha = 0.85
        }
    }

    private func animateRelease(on view: UIView) {
        UIView.animate(withDuration: 0.1) {
            view.alpha = 1.0
        }
    }

}

private extension TwoCardsSummaryViewCell {

    func configureCard(
        model: SummaryCardModel?,
        container: UIView,
        imageView: UIImageView,
        label: UILabel,
        stackView: UIStackView
    ) {
        guard let model = model else {
            stackView.isHidden = true
            return
        }

        stackView.isHidden = model.isHidden ?? false

        // Image
        imageView.image = model.image
        imageView.isHidden = model.image == nil

        // Label
        label.text = model.title
        label.isHidden = model.title == nil

        // Background
        if let bgColor = model.backgroundColor {
            container.backgroundColor = bgColor
        }

        // Corner radius
        if let radius = model.cornerRadius {
            container.layer.cornerRadius = radius
        }
    }
}


//let model = TwoCardsSummaryModel(
//    title: "Summary",
//    description: "Overview of your current status",
//    leftCard: SummaryCardModel(
//        image: UIImage(systemName: "checkmark.circle"),
//        title: "Completed",
//        backgroundColor: .systemGreen.withAlphaComponent(0.1)
//    ),
//    rightCard: SummaryCardModel(
//        image: UIImage(systemName: "clock"),
//        title: "Pending",
//        backgroundColor: .systemOrange.withAlphaComponent(0.1)
//    )
//)

//let leftCard = SummaryCardModel(
//    image: UIImage(systemName: "doc.text"),
//    title: "Documents",
//    onTap: { [weak self] in
//        self?.openDocuments()
//    }
//)
//
//let rightCard = SummaryCardModel(
//    image: UIImage(systemName: "gear"),
//    title: "Settings",
//    onTap: { [weak self] in
//        self?.openSettings()
//    }
//)
