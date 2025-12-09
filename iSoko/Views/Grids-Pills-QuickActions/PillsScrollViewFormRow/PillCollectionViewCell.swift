//
//  PillCollectionViewCell.swift
//  
//
//  Created by Edwin Weru on 02/12/2025.
//

import UIKit
import UtilsKit

class PillCollectionViewCell: UICollectionViewCell {

    private let pillLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
    }()

    private var tapAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(container)
        container.addSubview(pillLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            pillLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            pillLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            pillLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            pillLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
    }

    func configure(with item: PillItem, tapAction: @escaping () -> Void) {
        self.tapAction = tapAction

        pillLabel.text = item.title
        pillLabel.font = item.font
        pillLabel.textColor = item.isSelected ? item.selectedTextColor : item.textColor

        container.layer.cornerRadius = item.cornerRadius
        container.backgroundColor = item.isSelected ? item.selectedBackgroundColor : item.backgroundColor
        container.layer.borderWidth = item.isSelected ? 1 : 0
        container.layer.borderColor = (item.isSelected ? item.selectedBorderColor : item.borderColor).cgColor

        // Add tap action
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func didTap() {
        tapAction?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pillLabel.text = nil
        contentView.gestureRecognizers?.forEach { contentView.removeGestureRecognizer($0) }
    }

    // --- This enables autosizing for dynamic collection view cells ---
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width,
                                height: UIView.layoutFittingCompressedSize.height)

        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )

        layoutAttributes.size = size
        return layoutAttributes
    }
}
