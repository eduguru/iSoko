//
//  ImagePreviewItemCell.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import UIKit

final class ImagePreviewItemCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let removeButton = UIButton(type: .system)

    private var onRemove: (() -> Void)?
    private var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = true

        // Tap gesture for preview
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)

        removeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeButton.tintColor = .white
        removeButton.backgroundColor = .black.withAlphaComponent(0.5)
        removeButton.layer.cornerRadius = 12
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -6),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 6),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(
        item: ImagePreviewItem,
        onRemove: @escaping () -> Void,
        onTap: (() -> Void)? = nil
    ) {
        imageView.image = item.image
        self.onRemove = onRemove
        self.onTap = onTap
    }

    @objc private func removeTapped() {
        onRemove?()
    }

    @objc private func imageTapped() {
        onTap?()
    }
}
