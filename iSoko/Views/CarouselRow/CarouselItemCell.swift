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

    // MARK: - Views

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let label = UILabel()

    // MARK: - Constraints

    private var imageLeadingConstraint: NSLayoutConstraint!
    private var imageTrailingConstraint: NSLayoutConstraint!

    // MARK: - Constants

    private let horizontalPadding: CGFloat = 16
    private let cornerRadius: CGFloat = 14

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // MARK: Container View

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.cornerCurve = .continuous
        containerView.layer.masksToBounds = true
        containerView.clipsToBounds = true

        // MARK: Image View

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.layer.cornerCurve = .continuous

        // MARK: Label

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true

        // MARK: Hierarchy

        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        contentView.addSubview(label)

        // MARK: Constraints

        NSLayoutConstraint.activate([

            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            // Image
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            // Label
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 28)
        ])

        // Horizontal image padding

        imageLeadingConstraint = imageView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: horizontalPadding
        )

        imageTrailingConstraint = imageView.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -horizontalPadding
        )

        NSLayoutConstraint.activate([
            imageLeadingConstraint,
            imageTrailingConstraint
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()
        imageView.image = nil

        label.text = nil

        // Reset defaults
        imageView.contentMode = .scaleAspectFit

        imageLeadingConstraint.constant = horizontalPadding
        imageTrailingConstraint.constant = -horizontalPadding
    }

    // MARK: - Configure

    func configure(with item: CarouselItem, hideText: Bool = false) {

        // MARK: Label

        label.text = item.text
        label.textColor = item.textColor
        label.isHidden = hideText || item.text == nil

        // MARK: Downsampling

        let targetSize = CGSize(
            width: UIScreen.main.bounds.width,
            height: max(bounds.height, 180)
        )

        let processor = DownsamplingImageProcessor(size: targetSize)

        // MARK: Remote Image

        if let imageURL = item.imageURL,
           let url = URL(string: imageURL) {

            imageView.kf.indicatorType = .activity

            imageView.kf.setImage(
                with: url,
                placeholder: item.image,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage,
                    .transition(.fade(0.25)),
                    .backgroundDecode
                ]
            ) { [weak self] result in

                guard let self else { return }

                switch result {

                case .success(let value):

                    self.updateLayout(for: value.image)

                case .failure:

                    self.imageView.contentMode = .scaleAspectFit
                }
            }

        } else if let image = item.image {

            // MARK: Local Image

            updateLayout(for: image)
            imageView.image = image
        }
    }

    // MARK: - Adaptive Layout

    private func updateLayout(for image: UIImage) {

        let ratio = image.size.width / image.size.height

        switch ratio {

        // MARK: Ultra-wide banners
        // Example: 1710x362 (~4.7)

        case 3.0...:

            imageView.contentMode = .scaleAspectFit

            imageLeadingConstraint.constant = 4
            imageTrailingConstraint.constant = -4

        // MARK: Wide banners
        // Example: 2117x742 (~2.8)

        case 2.0..<3.0:

            imageView.contentMode = .scaleAspectFit

            imageLeadingConstraint.constant = 8
            imageTrailingConstraint.constant = -8

        // MARK: Standard landscape

        case 1.2..<2.0:

            imageView.contentMode = .scaleAspectFill

            imageLeadingConstraint.constant = horizontalPadding
            imageTrailingConstraint.constant = -horizontalPadding

        // MARK: Square / Portrait

        default:

            imageView.contentMode = .scaleAspectFill

            imageLeadingConstraint.constant = horizontalPadding
            imageTrailingConstraint.constant = -horizontalPadding
        }

        layoutIfNeeded()
    }
}
