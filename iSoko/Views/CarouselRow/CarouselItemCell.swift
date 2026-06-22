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

    // MARK: - Constants

    private let horizontalPadding: CGFloat = 12
    private let cornerRadius: CGFloat = 16

    // MARK: - Views

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let label = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(
            roundedRect: containerView.frame,
            cornerRadius: cornerRadius
        ).cgPath
    }

    // MARK: - Setup

    private func setupUI() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        setupContainer()
        setupImageView()
        setupLabel()
        setupHierarchy()
        setupConstraints()
    }

    private func setupContainer() {

        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.backgroundColor = .secondarySystemBackground

        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.cornerCurve = .continuous
        containerView.clipsToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
    }

    private func setupImageView() {

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    private func setupLabel() {

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )

        label.textAlignment = .center
        label.textColor = .white

        label.backgroundColor =
            UIColor.black.withAlphaComponent(0.35)

        label.layer.cornerRadius = 8
        label.layer.cornerCurve = .continuous
        label.clipsToBounds = true
    }

    private func setupHierarchy() {

        contentView.addSubview(containerView)

        containerView.addSubview(imageView)
        containerView.addSubview(label)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            // Container

            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),

            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),

            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: horizontalPadding
            ),

            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -horizontalPadding
            ),

            // Image

            imageView.topAnchor.constraint(
                equalTo: containerView.topAnchor
            ),

            imageView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor
            ),

            imageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor
            ),

            imageView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor
            ),

            // Label

            label.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 10
            ),

            label.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -10
            ),

            label.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -10
            ),

            label.heightAnchor.constraint(
                equalToConstant: 30
            )
        ])
    }

    // MARK: - Reuse

    override func prepareForReuse() {

        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()

        imageView.image = nil

        label.text = nil
        label.isHidden = false

        accessibilityLabel = nil
    }

    // MARK: - Configuration

    func configure(
        with item: CarouselItem,
        hideText: Bool = false
    ) {

        label.text = item.text
        label.textColor = item.textColor

        label.isHidden =
            hideText || item.text == nil

        isAccessibilityElement = true
        accessibilityLabel = item.text

        let targetSize = bounds.size.width > 0
            ? bounds.size
            : CGSize(width: 320, height: 180)

        let processor = DownsamplingImageProcessor(
            size: targetSize
        )

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
            )

        } else if let image = item.image {

            imageView.image = image
        }
    }
}
