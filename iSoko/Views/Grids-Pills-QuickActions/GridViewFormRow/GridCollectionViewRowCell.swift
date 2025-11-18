//
//  GridCollectionViewRowCell.swift
//  iSoko
//
//  Created by Edwin Weru on 11/08/2025.
//

import UIKit
import DesignSystemKit

final class GridCollectionViewRowCell: UICollectionViewCell {

    private var items: [GridItemModel] = []
    private var numberOfColumns: Int = 2
    private var collectionView: UICollectionView!

    private let interItemSpacing: CGFloat = 8
    private let lineSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = sectionInsets

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
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

    func configure(with items: [GridItemModel], columns: Int) {
        self.items = items
        self.numberOfColumns = max(1, columns)

        // ✅ Fix: Ensure layout is settled before measuring
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()

        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

extension GridCollectionViewRowCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        let width = collectionView.bounds.width
        guard width > 0 else {
            return CGSize(width: 100, height: 200)
        }

        let totalHorizontalSpacing = sectionInsets.left
            + sectionInsets.right
            + (CGFloat(numberOfColumns - 1) * interItemSpacing)

        let availableWidth = width - totalHorizontalSpacing
        let itemWidth = floor(availableWidth / CGFloat(numberOfColumns))

        // Debug print to verify layout
        print("📐 GridCollectionViewRowCell - width: \(width), columns: \(numberOfColumns), itemWidth: \(itemWidth)")

        return CGSize(width: itemWidth, height: 200)
    }
}
