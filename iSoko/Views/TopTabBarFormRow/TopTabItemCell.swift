//
//  TopTabItemCell.swift
//  
//
//  Created by Edwin Weru on 03/10/2025.
//

import UIKit

class TopTabItemCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let underlineView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .systemBlue
        underlineView.isHidden = true

        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .systemBlue : .label
        underlineView.isHidden = !isSelected
    }
}
