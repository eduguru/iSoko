//
//  PillsTableViewCell.swift
//
//
//  Created by Edwin Weru on 02/12/2025.
//

import UIKit
import UtilsKit

class PillsTableViewCell: UITableViewCell {

    private var items: [PillItem] = []
    private var collectionView: UICollectionView!

    private let interItemSpacing: CGFloat = 12
    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    private var layoutMode: PillsLayoutMode = .scrollable
    private var selectionMode: PillsSelectionMode = .multiple
    private var onSelectionChanged: PillsSelectionHandler?

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
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = interItemSpacing
        layout.sectionInset = sectionInsets

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(PillCollectionViewCell.self, forCellWithReuseIdentifier: "PillCollectionViewCell")

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with items: [PillItem]) {
        // fallback to V1 behavior
        configure(
            with: items,
            layoutMode: .scrollable,
            selectionMode: .multiple,
            onSelectionChanged: nil
        )
    }

    func configure(
        with items: [PillItem],
        layoutMode: PillsLayoutMode,
        selectionMode: PillsSelectionMode,
        onSelectionChanged: PillsSelectionHandler?
    ) {
        self.items = items
        self.layoutMode = layoutMode
        self.selectionMode = selectionMode
        self.onSelectionChanged = onSelectionChanged

        configureLayout()
        collectionView.reloadData()
    }

    private func configureLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        switch layoutMode {
        case .scrollable:
            layout.scrollDirection = .horizontal

        case .segmentedStretch:
            layout.scrollDirection = .vertical
        }

        layout.invalidateLayout()
    }
    
    static func estimatedHeight(for items: [PillItem]) -> CGFloat {
        let maxItemHeight = items.map { item -> CGFloat in
            let labelHeight = item.title.height(forWidth: 160, font: item.font)
            return labelHeight + 16
        }.max() ?? 40

        return maxItemHeight + 16 // top + bottom insets
    }
}


extension PillsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PillCollectionViewCell",
            for: indexPath
        ) as? PillCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]

        cell.configure(with: item) { [weak self] in
            self?.toggleSelection(at: indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = items[indexPath.item]

        switch layoutMode {

        case .scrollable:
            let labelWidth = (item.title as NSString)
                .size(withAttributes: [.font: item.font]).width

            let width = labelWidth + item.horizontalPadding * 2 + 24
            return CGSize(width: width, height: 40)

        case .segmentedStretch:
            let totalSpacing =
                sectionInsets.left +
                sectionInsets.right +
                (CGFloat(items.count - 1) * interItemSpacing)

            let width = (collectionView.bounds.width - totalSpacing) / CGFloat(items.count)
            return CGSize(width: width, height: 40)
        }
    }

    private func toggleSelection(at indexPath: IndexPath) {

        switch selectionMode {

        case .single:
            for i in items.indices {
                items[i].isSelected = (i == indexPath.item)
            }

        case .multiple:
            items[indexPath.item].isSelected.toggle()
        }

        collectionView.reloadData()
        onSelectionChanged?(items)
    }
}


//class PillsTableViewCell: UITableViewCell {
//    private var items: [PillItem] = []
//    private var collectionView: UICollectionView!
//    
//    private let interItemSpacing: CGFloat = 12
//    private let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//    
//    // Approx product card size (adaptive if needed)
//    private var itemWidth: CGFloat {
//        return 160
//    }
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCollectionView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupCollectionView()
//    }
//    
//    private func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = interItemSpacing
//        layout.sectionInset = sectionInsets
//        
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.backgroundColor = .clear
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        
//        collectionView.register(PillCollectionViewCell.self, forCellWithReuseIdentifier: "PillCollectionViewCell")
//        
//        contentView.addSubview(collectionView)
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//        ])
//    }
//    
//    func configure(with items: [PillItem]) {
//        self.items = items
//        collectionView.reloadData()
//        collectionView.collectionViewLayout.invalidateLayout()  // Ensure layout is recalculated
//    }
//    
//    static func estimatedHeight(for items: [PillItem]) -> CGFloat {
//        let maxItemHeight = items.map { item -> CGFloat in
//            let labelHeight = item.title.height(forWidth: 160, font: item.font)
//            return labelHeight + 16 // Add padding
//        }.max() ?? 40
//        return maxItemHeight + 8 + 8 // Padding and insets
//    }
//}
//
//// MARK: - UICollectionViewDataSource & DelegateFlowLayout
//extension PillsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PillCollectionViewCell", for: indexPath) as? PillCollectionViewCell else {
//            assertionFailure("❌ Could not dequeue PillCollectionViewCell")
//            return UICollectionViewCell()
//        }
//        
//        let pillItem = items[indexPath.item]
//        cell.configure(with: pillItem) { [weak self] in
//            self?.toggleSelection(at: indexPath)
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let item = items[indexPath.item]
//        
//        // Correct text width calculation
//        let labelWidth = (item.title as NSString)
//            .size(withAttributes: [.font: item.font]).width
//        
//        let width = labelWidth + item.horizontalPadding * 2 + 24 // include vertical padding for the label
//        let height: CGFloat = 40 // fixed pill height
//        
//        return CGSize(width: width, height: height)
//    }
//    
//    
//    private func toggleSelection(at indexPath: IndexPath) {
//        var item = items[indexPath.item]
//        item.isSelected.toggle()
//        items[indexPath.item] = item
//        collectionView.reloadItems(at: [indexPath])
//    }
//}
