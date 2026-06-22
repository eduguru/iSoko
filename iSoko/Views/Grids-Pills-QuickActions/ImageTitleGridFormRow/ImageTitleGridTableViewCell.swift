//
//  ImageTitleGridTableViewCell.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import UIKit

final class ImageTitleGridTableViewCell: UITableViewCell {

    private var items: [ImageTitleGridItemModel] = []
    private var numberOfColumns: Int = 3
    private var collectionView: UICollectionView!

    private let interItemSpacing: CGFloat = 8
    private let lineSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

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
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = sectionInsets

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            ImageTitleGridCardCell.self,
            forCellWithReuseIdentifier: ImageTitleGridCardCell.reuseIdentifier
        )

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
}

extension ImageTitleGridTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageTitleGridCardCell.reuseIdentifier,
            for: indexPath
        ) as? ImageTitleGridCardCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width

        guard width > 0 else {
            return CGSize(width: 100, height: 150)
        }

        let totalHorizontalSpacing =
            sectionInsets.left +
            sectionInsets.right +
            CGFloat(numberOfColumns - 1) * interItemSpacing

        let availableWidth = width - totalHorizontalSpacing
        let itemWidth = floor(availableWidth / CGFloat(numberOfColumns))

        return CGSize(width: itemWidth, height: 150)
    }
}
