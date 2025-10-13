//
//  ProductImageGalleryCell.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import UIKit

final public class ProductImageGalleryCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    private var images: [ProductImage] = []

    private let collectionView: UICollectionView
    private let pageControl = UIPageControl()
    private let imageHeight: CGFloat = 180

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)

        setup()
    }

    private func setup() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(ProductImageCollectionViewCell.self, forCellWithReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier)

        // ✅ Set pagination tint colors
        pageControl.pageIndicatorTintColor = UIColor.lightGray // Inactive dots
        pageControl.currentPageIndicatorTintColor = .app(.primary) // Active dot

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: imageHeight),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }


    public func configure(with config: ProductImageGalleryConfig) {
        // Put featured images first
        let featured = config.images.filter { $0.isFeatured }
        let others = config.images.filter { !$0.isFeatured }
        self.images = featured + others

        pageControl.numberOfPages = self.images.count
        pageControl.currentPage = 0

        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductImageCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: imageHeight)
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = Int(round(fractionalPage))
        pageControl.currentPage = max(0, min(page, images.count - 1))
    }
}
