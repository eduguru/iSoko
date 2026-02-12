//
//  ExportCardCell.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

final class ExportCardCell: UICollectionViewCell {

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let gridContainer = UIStackView()
    private var imageViews: [UIImageView] = []

    private var currentItem: ExportCardItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        iconView.contentMode = .scaleAspectFit
        iconView.layer.cornerRadius = 12
        iconView.clipsToBounds = true
        iconView.backgroundColor = .systemGray5

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        let headerStack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center

        let textStack = UIStackView(arrangedSubviews: [headerStack, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        gridContainer.axis = .vertical
        gridContainer.spacing = 8

        // Create 4 image views
        for _ in 0..<4 {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 14
            iv.backgroundColor = .systemGray5
            imageViews.append(iv)
        }

        // Build 2 rows of 2 images
        for row in 0..<2 {
            let rowStack = UIStackView(arrangedSubviews: [
                imageViews[row * 2],
                imageViews[row * 2 + 1]
            ])
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .fillEqually
            gridContainer.addArrangedSubview(rowStack)
        }

        contentView.addSubview(textStack)
        contentView.addSubview(gridContainer)

        textStack.translatesAutoresizingMaskIntoConstraints = false
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),

            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            gridContainer.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 12),
            gridContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gridContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gridContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            imageViews[0].heightAnchor.constraint(equalTo: imageViews[0].widthAnchor),
            imageViews[2].heightAnchor.constraint(equalTo: imageViews[2].widthAnchor)
        ])
    }

    func configure(with item: ExportCardItem) {
        currentItem = item

        iconView.image = item.icon ?? UIImage(systemName: "globe")
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        let placeholder = UIImage.blankRectangle

        for i in 0..<4 {
            if i < item.images.count {
                imageViews[i].image = item.images[i] ?? placeholder
            } else {
                imageViews[i].image = placeholder
            }
        }
    }
}
