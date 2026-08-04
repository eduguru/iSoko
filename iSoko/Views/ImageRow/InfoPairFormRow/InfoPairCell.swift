//
//  InfoPairCell.swift
//  
//
//  Created by Edwin Weru on 04/08/2026.
//

import UIKit

// MARK: - Cell

public final class InfoPairCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    private var itemViews: [InfoPairItemView] = []

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    public func configure(with config: InfoPairConfig) {
        // Title
        if let title = config.title, !title.isEmpty {
            titleLabel.text = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }

        // Clear old item views
        itemViews.forEach { $0.removeFromSuperview() }
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        itemViews.removeAll()

        // Add new item views
        for item in config.items {
            let itemView = InfoPairItemView()
            itemView.configure(
                with: item,
                iconTintColor: config.iconTintColor,
                iconBackgroundColor: config.iconBackgroundColor
            )
            stackView.addArrangedSubview(itemView)
            itemViews.append(itemView)
        }
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        itemViews.forEach { $0.removeFromSuperview() }
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        itemViews.removeAll()
    }
}
