//
//  QuickActionItemCell.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import UIKit
import Kingfisher

final class QuickActionItemCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("♻️ Reusing cell")

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    private func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 60)
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 60)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            widthConstraint,
            heightConstraint,

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    func configure(with item: QuickActionItem) {
        
        print("🧩 Configuring cell for:", item.title)
        print("🔗 URL:", item.imageUrl ?? "nil")

        // Always set placeholder first
        imageView.image = item.image

        guard let urlString = item.imageUrl,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            
            print("⚠️ Invalid or empty URL → using placeholder")
            return
        }

        print("⬇️ Starting download:", url.absoluteString)

        imageView.kf.setImage(
            with: url,
            placeholder: item.image,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let value):
                print("✅ Image loaded:", value.source.url?.absoluteString ?? "")
            case .failure(let error):
                print("❌ Image failed:", error.localizedDescription)
            }
        }

        titleLabel.text = item.title
        titleLabel.font = item.titleFont
        titleLabel.textColor = item.titleColor

        imageView.layer.cornerRadius = {
            switch item.imageShape {
            case .circle:
                return item.imageSize.width / 2
            case .rounded(let radius):
                return radius
            case .square:
                return 0
            }
        }()

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        widthConstraint.constant = item.imageSize.width
        heightConstraint.constant = item.imageSize.height
    }
}
