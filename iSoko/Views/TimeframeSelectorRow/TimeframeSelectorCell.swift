//
//  TimeframeSelectorCell.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit

final class TimeframeOptionCell: UICollectionViewCell {

    static let reuseIdentifier = "TimeframeOptionCell"

    private let titleLabel = UILabel()
    private let checkmarkView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        image.tintColor = .systemGreen
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        return image
    }()

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true

        containerView.addSubview(titleLabel)
        containerView.addSubview(checkmarkView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            checkmarkView.widthAnchor.constraint(equalToConstant: 18),
            checkmarkView.heightAnchor.constraint(equalToConstant: 18),
            checkmarkView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            checkmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6)
        ])
    }

    func configure(title: String, selected: Bool) {
        titleLabel.text = title
        checkmarkView.isHidden = !selected

        if selected {
            containerView.layer.borderColor = UIColor.systemGreen.cgColor
            containerView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
        } else {
            containerView.layer.borderColor = UIColor.systemGray4.cgColor
            containerView.backgroundColor = .white
        }
    }
}

final class TimeframeSelectorCell: UITableViewCell {

    static let reuseIdentifier = "TimeframeSelectorCell"

    private var config: TimeframeSelectorConfig?
    private var selectedIndices: Set<Int> = []

    // Callback for selection changes
    public var onSelectionChanged: ((Set<Int>) -> Void)?

    private var collectionView: UICollectionView!
    private var collectionHeightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false

        collectionView.register(TimeframeOptionCell.self,
                                forCellWithReuseIdentifier: TimeframeOptionCell.reuseIdentifier)

        contentView.addSubview(collectionView)

        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionHeightConstraint
        ])
    }

    func configure(with config: TimeframeSelectorConfig) {
        self.config = config
        self.selectedIndices = config.selectedIndex.map { [$0] } ?? []

        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionView
extension TimeframeSelectorCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        config?.options.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeframeOptionCell.reuseIdentifier,
            for: indexPath
        ) as? TimeframeOptionCell else {
            fatalError("Failed to dequeue TimeframeOptionCell")
        }

        let option = config!.options[indexPath.item]
        let selected = selectedIndices.contains(indexPath.item)
        cell.configure(title: option.title, selected: selected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let config = config else { return }

        if config.allowsMultipleSelection {
            if selectedIndices.contains(indexPath.item) {
                selectedIndices.remove(indexPath.item)
            } else {
                selectedIndices.insert(indexPath.item)
            }
        } else {
            if selectedIndices.contains(indexPath.item) {
                selectedIndices.removeAll()
            } else {
                selectedIndices = [indexPath.item]
            }
        }

        collectionView.reloadData()

        // Call the per-option tap
        let option = config.options[indexPath.item]
        option.onTap?()

        // Notify parent/viewmodel
        onSelectionChanged?(selectedIndices)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let insets = layout.sectionInset
        let spacing = layout.minimumInteritemSpacing

        let availableWidth = collectionView.bounds.width
            - collectionView.adjustedContentInset.left
            - collectionView.adjustedContentInset.right
            - insets.left - insets.right

        let columns = 3
        let totalSpacing = spacing * CGFloat(columns - 1)
        let width = (availableWidth - totalSpacing) / CGFloat(columns)

        return CGSize(width: floor(width), height: 50)
    }
}
