//
//  ImagePreviewTableViewCell.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import UIKit

final class ImagePreviewTableViewCell: UITableViewCell {

    private var items: [ImagePreviewItem] = []
    private var onRemove: ((Int) -> Void)?
    private var onTap: ((Int) -> Void)?

    private var collectionView: UICollectionView!

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
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImagePreviewItemCell.self, forCellWithReuseIdentifier: "ImagePreviewItemCell")

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(
        items: [ImagePreviewItem],
        onRemove: ((Int) -> Void)? = nil,
        onTap: ((Int) -> Void)? = nil
    ) {
        self.items = items
        self.onRemove = onRemove
        self.onTap = onTap
        collectionView.reloadData()
    }
}

extension ImagePreviewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImagePreviewItemCell",
            for: indexPath
        ) as? ImagePreviewItemCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]

        cell.configure(
            item: item,
            onRemove: { [weak self] in
                self?.onRemove?(indexPath.item)
            },
            onTap: { [weak self] in
                self?.onTap?(indexPath.item)
            }
        )

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
