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
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.masksToBounds = false

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titleLabel.lineBreakMode = .byTruncatingTail

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 60)
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 60)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            widthConstraint,
            heightConstraint,

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with item: QuickActionItem) {
        
        print("🧩 Configuring cell for:", item.title)
        print("🔗 URL:", item.imageUrl ?? "nil")

        imageView.image = item.image

        // Format the string to lowercase first, then capitalize each word to handle harsh ALL CAPS data safely
        let presentableTitle = item.title.lowercased().capitalized

        guard let urlString = item.imageUrl,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            
            print("Invalid or empty URL → using placeholder")
            titleLabel.text = presentableTitle
            titleLabel.font = item.titleFont
            titleLabel.textColor = item.titleColor
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

        titleLabel.text = presentableTitle
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
