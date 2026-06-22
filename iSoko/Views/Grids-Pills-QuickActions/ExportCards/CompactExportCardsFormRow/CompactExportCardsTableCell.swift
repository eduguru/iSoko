//
//  CompactExportCardsTableCell.swift
//  
//
//  Created by Edwin Weru on 16/06/2026.
//

import UIKit

final class CompactExportCardsTableCell: UITableViewCell {

    private var items: [ExportCardItem] = []
    private var collectionView: UICollectionView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBaseAppearance()
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBaseAppearance()
        setupCollectionView()
    }

    private func setupBaseAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .clear
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16
        )

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            CompactExportCardCell.self,
            forCellWithReuseIdentifier: "CompactExportCardCell"
        )

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with items: [ExportCardItem]) {
        self.items = items
        collectionView.reloadData()
    }
}


extension CompactExportCardsTableCell:
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {


    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }


    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {


        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CompactExportCardCell",
            for: indexPath
        ) as! CompactExportCardCell


        cell.configure(with: items[indexPath.item])

        return cell
    }


    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        items[indexPath.item].onTap?()
    }


    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        CGSize(
            width: 220,
            height: 130
        )
    }
}
