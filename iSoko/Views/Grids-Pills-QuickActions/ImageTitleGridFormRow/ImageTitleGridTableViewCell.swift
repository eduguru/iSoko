//
//  ImageTitleGridTableViewCell.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import UIKit

final class ImageTitleGridTableViewCell: UITableViewCell {
    
    let cellNibName = "ImageTitleGridCollectionViewCell"
    let cellWithReuseIdentifier = "ImageTitleGridCollectionViewCell"

    private var items: [ImageTitleGridItemModel] = []
    private var numberOfColumns: Int = 2
    private var collectionView: UICollectionView!

    private let interItemSpacing: CGFloat = 8
    private let lineSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

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
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = sectionInsets

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false // ✅ prevent scrolling conflict
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellWithReuseIdentifier)

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with items: [ImageTitleGridItemModel], columns: Int) {
        self.items = items
        self.numberOfColumns = max(columns, 1)

        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    // MARK: - Public Static Height Calculator

    static func estimatedHeight(
        width: CGFloat,
        items: [GridItemModel],
        columns: Int,
        itemHeight: CGFloat = 200,
        sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
        interItemSpacing: CGFloat = 8,
        lineSpacing: CGFloat = 12
    ) -> CGFloat {
        guard columns > 0 else { return 0 }

        let rows = ceil(CGFloat(items.count) / CGFloat(columns))
        let verticalSpacing = CGFloat(max(0, rows - 1)) * lineSpacing
        let totalVerticalInset = sectionInsets.top + sectionInsets.bottom

        return rows * itemHeight + verticalSpacing + totalVerticalInset
    }
}


extension ImageTitleGridTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellWithReuseIdentifier, for: indexPath) as? ImageTitleGridCollectionViewCell else {
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
        print("📐 GridTableViewCell - width: \(width), columns: \(numberOfColumns), itemWidth: \(itemWidth)")

        return CGSize(width: itemWidth, height: 200)
    }
}
