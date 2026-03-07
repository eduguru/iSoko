//
//  SelectableCardItemCell.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit

final class SelectableCardItemCell: UICollectionViewCell {

    static let reuseIdentifier = "SelectableCardItemCell"

    private let cardView = SelectableDualCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func configure(item: SelectableCardItemConfig, selected: Bool) {
        // Pass color per icon or category (you'll need to add color info in your model)
        let iconTintColor = getTintColor(for: item.title)

        cardView.configure(title: item.title,
                           subtitle: item.subtitle,
                           icon: item.icon,
                           iconTintColor: iconTintColor,
                           selected: selected,
                           alignment: Alignment.left
        )
    }

    private func getTintColor(for title: String) -> UIColor {
        switch title.lowercased() {
        case "sales": return UIColor.systemGreen
        case "expenses": return UIColor.systemRed
        case "stock": return UIColor.systemBlue
        case "profit & loss": return UIColor.systemPurple
        case "customers": return UIColor.systemOrange
        case "suppliers": return UIColor.systemRed.withAlphaComponent(0.7)
        default: return UIColor.label
        }
    }
}
