//
//  FeaturedDealsGridTableViewCell.swift
//  
//
//  Created by Edwin Weru on 13/02/2026.
//

import UIKit

final class FeaturedDealsGridTableViewCell: UITableViewCell {

    private var items: [FeaturedDealItem] = []
    private var columns: Int?
    private var minimumItemWidth: CGFloat?

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
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        layout.sectionInsetReference = .fromSafeArea

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            FeaturedDealItemCell.self,
            forCellWithReuseIdentifier: "FeaturedDealItemCell"
        )

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

    func configure(with items: [FeaturedDealItem],
                   columns: Int?,
                   minimumItemWidth: CGFloat?) {

        self.items = items
        self.columns = columns
        self.minimumItemWidth = minimumItemWidth

        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        collectionHeightConstraint.constant =
            collectionView.collectionViewLayout.collectionViewContentSize.height
    }
}

extension FeaturedDealsGridTableViewCell:
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FeaturedDealItemCell",
            for: indexPath
        ) as? FeaturedDealItemCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        items[indexPath.item].onTap?()
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
            - insets.left
            - insets.right

        // -------------------------------
        // 👇 Determine columns correctly
        // -------------------------------
        let columnCount: Int
        if let c = columns, c > 0 {
            columnCount = c
        } else if let minW = minimumItemWidth, minW > 0 {
            columnCount = max(2, Int((availableWidth - spacing) / (minW + spacing))) // Adjusted to subtract spacing
        } else {
            columnCount = 2
        }

        let totalSpacing = spacing * CGFloat(columnCount - 1)
        let itemWidth = (availableWidth - totalSpacing) / CGFloat(columnCount)

        // Debugging: Print values to confirm calculations
        print("Available Width: \(availableWidth), Spacing: \(spacing), Total Spacing: \(totalSpacing), Item Width: \(itemWidth), Column Count: \(columnCount)")

        return CGSize(width: floor(itemWidth), height: 280)
    }

}
