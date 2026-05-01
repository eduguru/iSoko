//
//  CarouselItemCell.swift
//  iSoko
//
//  Created by Edwin Weru on 06/08/2025.
//

import UIKit
import Kingfisher

final class CarouselItemCell: UICollectionViewCell {
    static let reuseIdentifier = "CarouselItemCell"

    private let imageView = UIImageView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6 // Ensure a consistent corner radius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set contentMode based on the requirement
        imageView.contentMode = .scaleAspectFill // Will fill the image, but might crop it if aspect ratio is off

        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(label)

        // Adding constraints for imageView and label
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(with item: CarouselItem, contentMode: UIView.ContentMode, hideText: Bool = false) {
        imageView.contentMode = contentMode
        
        label.text = item.text
        label.textColor = item.textColor
        label.isHidden = hideText || (item.text == nil)

        if let imageURL = item.imageURL, let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url, placeholder: item.image, options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]) { result in
                switch result {
                case .success(let value):
                    let image = value.image
                    let imageAspectRatio = image.size.width / image.size.height
                    let viewAspectRatio = self.imageView.frame.size.width / self.imageView.frame.size.height

                    if imageAspectRatio > viewAspectRatio {
                        // Image is wider than view, adjust accordingly
                        self.imageView.contentMode = .scaleAspectFill
                    } else {
                        // Image is taller or fits well
                        self.imageView.contentMode = .scaleAspectFit
                    }
                case .failure(_):
                    break
                }
            }
        } else {
            imageView.image = item.image
        }
    }
}
