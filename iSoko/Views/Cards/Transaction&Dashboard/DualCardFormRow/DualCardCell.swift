//
//  DualCardCell.swift
//  
//
//  Created by Edwin Weru on 23/01/2026.
//

import UIKit

public final class DualCardCell: UITableViewCell {

    private let containerStack = UIStackView()
    private let leftCard = DualCardView()
    private let rightCard = DualCardView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none

        containerStack.axis = .horizontal
        containerStack.distribution = .fillEqually
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerStack)
        containerStack.addArrangedSubview(leftCard)
        containerStack.addArrangedSubview(rightCard)

        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    public func configure(with config: DualCardCellConfig) {
        containerStack.spacing = config.spacing
        leftCard.configure(with: config.left)
        rightCard.configure(with: config.right)
    }
}
