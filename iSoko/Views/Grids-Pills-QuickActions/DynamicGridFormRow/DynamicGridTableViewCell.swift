//
//  DynamicGridTableViewCell.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import UIKit

final class DynamicGridTableViewCell<Item, Cell: UICollectionViewCell>: UITableViewCell,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - State
    private var items: [Item] = []
    private var columns: Int?
    private var minimumItemWidth: CGFloat?
    private var itemHeight: ((Item, CGFloat) -> CGFloat)?
    private var configureCell: ((Cell, Item, IndexPath) -> Void)?
    private var onSelect: ((Item, IndexPath) -> Void)?
    private var cellReuseIdentifier: String = ""

    // MARK: - UI
    private var collectionView: UICollectionView!
    private var collectionHeightConstraint: NSLayoutConstraint!

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    // MARK: - Setup
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        layout.sectionInsetReference = .fromSafeArea

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

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

    // MARK: - Layout adjustment for perfect fit
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let spacing = layout.minimumInteritemSpacing
        let availableWidth = collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right

        // Determine column count
        let columnCount: Int
        if let c = columns, c > 0 {
            columnCount = c
        } else if let minW = minimumItemWidth, minW > 0 {
            columnCount = max(1, Int((availableWidth + spacing) / (minW + spacing)))
        } else {
            columnCount = 2
        }

        // Calculate item width
        let totalSpacing = spacing * CGFloat(columnCount - 1)
        let itemWidth = (availableWidth - totalSpacing) / CGFloat(columnCount)

        // Center content by adjusting sectionInset
        let totalItemsWidth = CGFloat(columnCount) * itemWidth + totalSpacing
        let horizontalInset = max(0, (collectionView.bounds.width - totalItemsWidth) / 2)
        layout.sectionInset = UIEdgeInsets(top: layout.sectionInset.top,
                                           left: horizontalInset,
                                           bottom: layout.sectionInset.bottom,
                                           right: horizontalInset)
        layout.invalidateLayout()

        // Update height to fit all items
        DispatchQueue.main.async {
            self.collectionHeightConstraint.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.contentView.layoutIfNeeded()
        }
    }

    // MARK: - Configure
    func configure(
        items: [Item],
        cellType: Cell.Type,
        reuseIdentifier: String,
        columns: Int?,
        minimumItemWidth: CGFloat?,
        itemHeight: ((Item, CGFloat) -> CGFloat)? = nil,
        configureCell: @escaping (Cell, Item, IndexPath) -> Void,
        onSelect: ((Item, IndexPath) -> Void)? = nil
    ) {
        self.items = items
        self.cellReuseIdentifier = reuseIdentifier
        self.columns = columns
        self.minimumItemWidth = minimumItemWidth
        self.itemHeight = itemHeight
        self.configureCell = configureCell
        self.onSelect = onSelect

        collectionView.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? Cell else { return UICollectionViewCell() }

        configureCell?(cell, items[indexPath.item], indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect?(items[indexPath.item], indexPath)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let spacing = layout.minimumInteritemSpacing
        let insets = layout.sectionInset
        let availableWidth = collectionView.bounds.width - insets.left - insets.right

        let columnCount: Int
        if let c = columns, c > 0 {
            columnCount = c
        } else if let minW = minimumItemWidth, minW > 0 {
            columnCount = max(1, Int((availableWidth + spacing) / (minW + spacing)))
        } else {
            columnCount = 2
        }

        let totalSpacing = spacing * CGFloat(columnCount - 1)
        let itemWidth = (availableWidth - totalSpacing) / CGFloat(columnCount)

        let item = items[indexPath.item]
        let height = itemHeight?(item, itemWidth) ?? 280
        
        return CGSize(width: floor(itemWidth), height: height)
    }
}
