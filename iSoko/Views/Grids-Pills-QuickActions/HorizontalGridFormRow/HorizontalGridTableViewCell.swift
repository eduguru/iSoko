//
//  HorizontalGridTableViewCell.swift
//  
//
//  Created by Edwin Weru on 23/10/2025.
//

import UIKit

final class HorizontalGridTableViewCell: UITableViewCell {

    private var items: [GridItemModel] = []
    private var collectionView: UICollectionView!

    private let interItemSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    // Approx product card size (adaptive if needed)
    private var itemWidth: CGFloat {
        return 160
    }

    private let itemHeight: CGFloat = 240

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
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = interItemSpacing
        layout.sectionInset = sectionInsets

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: "GridViewCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "GridViewCollectionViewCell")

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with items: [GridItemModel]) {
        self.items = items
        collectionView.reloadData()
    }

    static func estimatedHeight() -> CGFloat {
        return 240 + 8 + 8 // item height + vertical insets
    }
}

// MARK: - UICollectionViewDataSource & DelegateFlowLayout
extension HorizontalGridTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "GridViewCollectionViewCell", for: indexPath
        ) as? GridViewCollectionViewCell else {
            assertionFailure("❌ Could not dequeue GridViewCollectionViewCell")
            return UICollectionViewCell()
        }

        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adaptive sizing: if screen is smaller, shrink width
        let availableWidth = collectionView.bounds.width - sectionInsets.left - sectionInsets.right
        let width = min(itemWidth, availableWidth * 0.7)
        return CGSize(width: width, height: itemHeight)
    }
}
