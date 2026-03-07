//
//  SelectableCardGridCell.swift
//  
//
//  Created by Edwin Weru on 07/03/2026.
//

import UIKit

public struct SelectableCardItem {
    let title: String
    var isSelected: Bool
}

// MARK: - SelectableCardGridCell
final class SelectableCardGridCell: UITableViewCell {

    static let reuseIdentifier = "SelectableCardGridCell"

    private var items: [SelectableCardItemConfig] = []
    private var selectedIndices: Set<Int> = []
    private var allowsMultiple = true

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
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            SelectableCardItemCell.self,
            forCellWithReuseIdentifier: SelectableCardItemCell.reuseIdentifier
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

    func configure(with config: SelectableCardGridConfig) {
        self.items = config.items
        self.selectedIndices = config.selectedIndices
        self.allowsMultiple = config.allowsMultipleSelection

        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension SelectableCardGridCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectableCardItemCell.reuseIdentifier,
            for: indexPath
        ) as? SelectableCardItemCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
        let selected = selectedIndices.contains(indexPath.item)

        cell.configure(item: item, selected: selected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previouslySelected = selectedIndices

        if allowsMultiple {
            if selectedIndices.contains(indexPath.item) {
                selectedIndices.remove(indexPath.item)
            } else {
                selectedIndices.insert(indexPath.item)
            }
        } else {
            // Single selection mode: only one selected, toggle selection on tap
            if selectedIndices.contains(indexPath.item) {
                selectedIndices.remove(indexPath.item)  // Deselect if tapped again
            } else {
                selectedIndices = [indexPath.item]       // Select new one, deselect old
            }
        }

        // Reload all cells whose selection state changed
        let changedIndices = previouslySelected.symmetricDifference(selectedIndices)
        let indexPathsToReload = changedIndices.map { IndexPath(item: $0, section: 0) }
        collectionView.reloadItems(at: indexPathsToReload)

        // Callback to ViewModel or handler
        items[indexPath.item].onTap?(indexPath.item)
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

        let columns = 2
        let totalSpacing = spacing * CGFloat(columns - 1)
        let width = (availableWidth - totalSpacing) / CGFloat(columns)

        return CGSize(width: floor(width), height: 120) // Adjust height if needed
    }
}
