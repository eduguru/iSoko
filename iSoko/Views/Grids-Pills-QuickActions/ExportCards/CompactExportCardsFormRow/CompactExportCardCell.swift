//
//  CompactExportCardCell.swift
//  
//
//  Created by Edwin Weru on 16/06/2026.
//

import UIKit

final class CompactExportCardCell: UICollectionViewCell {

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var imageViews: [UIImageView] = []
    private var iconHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.masksToBounds = false

        // Icon
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 8
        iconView.backgroundColor = .systemGray5
        iconView.isHidden = true
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1

        // Text stack (title + subtitle stacked vertically)
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        // Header row: icon left + text right
        let headerStack = UIStackView(arrangedSubviews: [iconView, textStack])
        headerStack.axis = .horizontal
        headerStack.spacing = 10
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        // Images stack
        let imagesStack = UIStackView()
        imagesStack.axis = .horizontal
        imagesStack.spacing = 6
        imagesStack.distribution = .fillEqually
        imagesStack.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.backgroundColor = .systemGray5
            imageViews.append(imageView)
            imagesStack.addArrangedSubview(imageView)
        }

        contentView.addSubview(headerStack)
        contentView.addSubview(imagesStack)

        iconHeightConstraint = iconView.heightAnchor.constraint(equalToConstant: 0)
        iconHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 36),

            // Header row — full width, top
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Images — below header, full width, fixed height
            imagesStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 8),
            imagesStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imagesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imagesStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imagesStack.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    func configure(with item: ExportCardItem) {
        let placeholder = UIImage.blankRectangle

        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        if let logoUrl = item.iconUrl, let url = URL(string: logoUrl) {
            iconView.isHidden = false
            iconHeightConstraint?.constant = 36
            iconView.kf.setImage(
                with: url,
                placeholder: item.icon ?? placeholder,
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else if let icon = item.icon {
            iconView.isHidden = false
            iconHeightConstraint?.constant = 36
            iconView.image = icon
        } else {
            iconView.isHidden = true
            iconHeightConstraint?.constant = 0
        }

        for i in 0..<3 {
            let imageView = imageViews[i]
            imageView.kf.cancelDownloadTask()
            imageView.image = placeholder

            if i < item.imageUrls.count, let url = URL(string: item.imageUrls[i]) {
                imageView.kf.setImage(
                    with: url,
                    placeholder: placeholder,
                    options: [.transition(.fade(0.2)), .cacheOriginalImage]
                )
            } else if i < item.images.count {
                imageView.image = item.images[i]
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.kf.cancelDownloadTask()
        iconView.image = nil
        iconView.isHidden = true
        iconHeightConstraint?.constant = 0
        imageViews.forEach {
            $0.kf.cancelDownloadTask()
            $0.image = UIImage.blankRectangle
        }
    }
}
