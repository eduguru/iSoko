//
//  ProductImageGalleryCell.swift
//  
//
//  Created by Edwin Weru on 13/10/2025.
//

import UIKit

final public class ProductImageGalleryCell:
    UITableViewCell,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate {

    // MARK: - State

    private var images: [ProductImage] = []

    private var placeholderImage: UIImage?
    private var selectedIndex = 0

    private var imageHeight: CGFloat = 180

    // MARK: - Views

    private let collectionView: UICollectionView
    private let thumbnailCollectionView: UICollectionView
    private let pageControl = UIPageControl()

    private let thumbnailSize: CGFloat = 72

    private var heroHeightConstraint: NSLayoutConstraint!
    private var thumbnailHeightConstraint: NSLayoutConstraint!

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        let heroLayout = UICollectionViewFlowLayout()
        heroLayout.scrollDirection = .horizontal
        heroLayout.minimumLineSpacing = 0

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: heroLayout
        )

        let thumbLayout = UICollectionViewFlowLayout()
        thumbLayout.scrollDirection = .horizontal
        thumbLayout.minimumLineSpacing = 8

        thumbnailCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: thumbLayout
        )

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setup()
    }

    required init?(coder: NSCoder) {

        let heroLayout = UICollectionViewFlowLayout()
        heroLayout.scrollDirection = .horizontal
        heroLayout.minimumLineSpacing = 0

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: heroLayout
        )

        let thumbLayout = UICollectionViewFlowLayout()
        thumbLayout.scrollDirection = .horizontal
        thumbLayout.minimumLineSpacing = 8

        thumbnailCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: thumbLayout
        )

        super.init(coder: coder)

        setup()
    }

    // MARK: - Setup

    private func setup() {

        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(thumbnailCollectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        thumbnailCollectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self

        thumbnailCollectionView.dataSource = self
        thumbnailCollectionView.delegate = self

        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        thumbnailCollectionView.showsHorizontalScrollIndicator = false
        thumbnailCollectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 4,
            bottom: 0,
            right: 4
        )

        collectionView.register(
            ProductImageCollectionViewCell.self,
            forCellWithReuseIdentifier:
                ProductImageCollectionViewCell.reuseIdentifier
        )

        thumbnailCollectionView.register(
            ProductThumbnailCell.self,
            forCellWithReuseIdentifier:
                ProductThumbnailCell.reuseIdentifier
        )

        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .app(.primary)

        heroHeightConstraint = collectionView.heightAnchor.constraint(
            equalToConstant: imageHeight
        )

        thumbnailHeightConstraint =
            thumbnailCollectionView.heightAnchor.constraint(
                equalToConstant: 80
            )

        NSLayoutConstraint.activate([

            collectionView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),

            collectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            collectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            heroHeightConstraint,

            pageControl.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: 8
            ),

            pageControl.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),

            thumbnailCollectionView.topAnchor.constraint(
                equalTo: pageControl.bottomAnchor,
                constant: 8
            ),

            thumbnailCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),

            thumbnailCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            thumbnailHeightConstraint,

            thumbnailCollectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            )
        ])
    }

    // MARK: - Configure

    public func configure(with config: ProductImageGalleryConfig) {

        let featured = config.images.filter(\.isFeatured)
        let others = config.images.filter { !$0.isFeatured }

        images = featured + others

        imageHeight = config.imageHeight
        heroHeightConstraint.constant = imageHeight

        placeholderImage = config.placeholderImage

        selectedIndex = 0

        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0

        let hasMultipleImages = images.count > 1

        pageControl.isHidden = !hasMultipleImages
        thumbnailCollectionView.isHidden = !hasMultipleImages

        thumbnailHeightConstraint.constant =
            hasMultipleImages ? 80 : 0

        collectionView.reloadData()
        thumbnailCollectionView.reloadData()

        collectionView.setContentOffset(
            .zero,
            animated: false
        )

        layoutIfNeeded()
    }

    // MARK: - UICollectionViewDataSource

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        images.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if collectionView == self.collectionView {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    ProductImageCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as! ProductImageCollectionViewCell

            cell.configure(
                with: images[indexPath.item],
                placeholder: placeholderImage
            )

            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:
                ProductThumbnailCell.reuseIdentifier,
            for: indexPath
        ) as! ProductThumbnailCell

        cell.configure(
            with: images[indexPath.item],
            placeholder: placeholderImage,
            selected: indexPath.item == selectedIndex
        )

        return cell
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        guard collectionView == thumbnailCollectionView else {
            return
        }

        updateSelectedIndex(indexPath.item)

        self.collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if collectionView == self.collectionView {

            return CGSize(
                width: collectionView.bounds.width,
                height: imageHeight
            )
        }

        return CGSize(
            width: thumbnailSize,
            height: thumbnailSize
        )
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidEndDecelerating(
        _ scrollView: UIScrollView
    ) {

        guard scrollView == collectionView else {
            return
        }

        syncCurrentPage()
    }

    public func scrollViewDidEndScrollingAnimation(
        _ scrollView: UIScrollView
    ) {

        guard scrollView == collectionView else {
            return
        }

        syncCurrentPage()
    }

    // MARK: - Helpers

    private func syncCurrentPage() {

        guard collectionView.bounds.width > 0 else {
            return
        }

        let page = Int(
            round(
                collectionView.contentOffset.x /
                collectionView.bounds.width
            )
        )

        updateSelectedIndex(page)
    }

    private func updateSelectedIndex(
        _ newIndex: Int
    ) {

        guard
            newIndex >= 0,
            newIndex < images.count,
            newIndex != selectedIndex
        else {
            return
        }

        let previous = selectedIndex
        selectedIndex = newIndex

        pageControl.currentPage = newIndex

        var paths = [
            IndexPath(item: newIndex, section: 0)
        ]

        if previous >= 0,
           previous < images.count {

            paths.append(
                IndexPath(item: previous, section: 0)
            )
        }

        thumbnailCollectionView.reloadItems(
            at: paths
        )

        thumbnailCollectionView.scrollToItem(
            at: IndexPath(
                item: newIndex,
                section: 0
            ),
            at: .centeredHorizontally,
            animated: true
        )
    }
}
