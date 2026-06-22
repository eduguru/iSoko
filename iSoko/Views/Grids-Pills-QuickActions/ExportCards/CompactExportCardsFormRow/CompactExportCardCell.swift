//
//  CompactExportCardCell.swift
//  
//
//  Created by Edwin Weru on 16/06/2026.
//

import UIKit

final class CompactExportCardCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private var imageViews: [UIImageView] = []

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

        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondaryLabel

        let imagesStack = UIStackView()
        imagesStack.axis = .horizontal
        imagesStack.spacing = 6
        imagesStack.distribution = .fillEqually

        for _ in 0..<3 {
            let imageView = UIImageView()

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.backgroundColor = .systemGray5

            imageViews.append(imageView)
            imagesStack.addArrangedSubview(imageView)
        }

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ])

        textStack.axis = .vertical
        textStack.spacing = 2

        let main = UIStackView(arrangedSubviews: [
            textStack,
            imagesStack
        ])

        main.axis = .vertical
        main.spacing = 8

        contentView.addSubview(main)
        main.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            main.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            main.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            main.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            imagesStack.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    func configure(with item: ExportCardItem) {
        let placeholder = UIImage.blankRectangle

        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        for i in 0..<3 {
            let imageView = imageViews[i]

            imageView.kf.cancelDownloadTask()
            imageView.image = placeholder

            if i < item.imageUrls.count,
               let url = URL(string: item.imageUrls[i]) {

                imageView.kf.setImage(
                    with: url,
                    placeholder: placeholder,
                    options: [
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ]
                )

            } else if i < item.images.count {
                imageView.image = item.images[i]
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageViews.forEach {
            $0.kf.cancelDownloadTask()
            $0.image = UIImage.blankRectangle
        }
    }
}
