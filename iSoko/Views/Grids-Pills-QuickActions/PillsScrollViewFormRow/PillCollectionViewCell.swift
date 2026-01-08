//
//  PillCollectionViewCell.swift
//  
//
//  Created by Edwin Weru on 02/12/2025.
//

import UIKit
import UtilsKit

class PillCollectionViewCell: UICollectionViewCell {

    private let pillLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
    }()

    private var tapAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(container)
        container.addSubview(pillLabel)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            pillLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            pillLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            pillLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            pillLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
    }

    func configure(with item: PillItem, tapAction: @escaping () -> Void) {
        self.tapAction = tapAction

        pillLabel.text = item.title
        pillLabel.font = item.font
        pillLabel.textColor = item.isSelected ? item.selectedTextColor : item.textColor

        container.layer.cornerRadius = item.cornerRadius
        container.backgroundColor = item.isSelected ? item.selectedBackgroundColor : item.backgroundColor
        container.layer.borderWidth = item.isSelected ? 1 : 0
        container.layer.borderColor = (item.isSelected ? item.selectedBorderColor : item.borderColor).cgColor

        // Add tap action
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func didTap() {
        tapAction?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pillLabel.text = nil
        contentView.gestureRecognizers?.forEach { contentView.removeGestureRecognizer($0) }
    }

    // --- This enables autosizing for dynamic collection view cells ---
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width,
                                height: UIView.layoutFittingCompressedSize.height)

        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )

        layoutAttributes.size = size
        return layoutAttributes
    }
}

import UIKit
import DesignSystemKit

public struct PillItemV2 {
    public let id: String
    public let title: String
    public var isSelected: Bool = false
    
    public let prefixIcon: UIImage?
    public let suffixIcon: UIImage?
    public let showsCloseButton: Bool
    
    public let backgroundColor: UIColor
    public let selectedBackgroundColor: UIColor
    public let textColor: UIColor
    public let selectedTextColor: UIColor
    public let borderColor: UIColor
    public let selectedBorderColor: UIColor
    public let font: UIFont
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat
    
    public init(
        id: String,
        title: String,
        isSelected: Bool = false,
        prefixIcon: UIImage? = nil,
        suffixIcon: UIImage? = nil,
        showsCloseButton: Bool = false,
        backgroundColor: UIColor = .systemGray5,
        selectedBackgroundColor: UIColor = .systemBlue,
        textColor: UIColor = .label,
        selectedTextColor: UIColor = .white,
        borderColor: UIColor = .clear,
        selectedBorderColor: UIColor = .systemBlue,
        font: UIFont = .systemFont(ofSize: 14),
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 12
    ) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
        self.prefixIcon = prefixIcon
        self.suffixIcon = suffixIcon
        self.showsCloseButton = showsCloseButton
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.borderColor = borderColor
        self.selectedBorderColor = selectedBorderColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
    }
}

class PillsTableViewCellV2: UITableViewCell {

    public var collectionView: UICollectionView!
    private var items: [PillItemV2] = []
    private let interItemSpacing: CGFloat = 12
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
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = interItemSpacing
        layout.sectionInset = sectionInsets

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(PillCollectionViewCellV2.self, forCellWithReuseIdentifier: "PillCollectionViewCellV2")

        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with items: [PillItemV2]) {
        self.items = items
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    static func estimatedHeight(for items: [PillItemV2]) -> CGFloat {
        let maxItemHeight = items.map { item -> CGFloat in
            let labelHeight = item.title.height(forWidth: 160, font: item.font)
            return labelHeight + 16
        }.max() ?? 40
        return maxItemHeight + 8 + 8
    }
}

// MARK: - UICollectionViewDataSource & DelegateFlowLayout
extension PillsTableViewCellV2: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PillCollectionViewCellV2", for: indexPath) as? PillCollectionViewCellV2 else {
            return UICollectionViewCell()
        }
        let pillItem = items[indexPath.item]
        cell.configure(with: pillItem) { [weak self] in
            self?.handleTap(at: indexPath)
        } removeAction: { [weak self] in
            self?.handleRemove(at: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        let labelWidth = item.title.width(withConstrainedHeight: 32, font: item.font)
        let width = labelWidth + item.horizontalPadding * 2 + 24 // extra for icons/close
        let height = item.title.height(forWidth: width, font: item.font) + 16
        return CGSize(width: width, height: height)
    }

    private func handleTap(at indexPath: IndexPath) {
        var item = items[indexPath.item]
        // Helper pill
        if item.id == "helper" {
            let allSelected = items.dropFirst().allSatisfy { $0.isSelected }
            if allSelected {
                for i in 1..<items.count { items[i].isSelected = false }
            } else {
                for i in 1..<items.count { items[i].isSelected = true }
            }
            collectionView.reloadData()
            return
        }

        item.isSelected.toggle()
        items[indexPath.item] = item
        collectionView.reloadItems(at: [indexPath])
    }

    private func handleRemove(at indexPath: IndexPath) {
        items.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}

// MARK: - PillCollectionViewCellV2
class PillCollectionViewCellV2: UICollectionViewCell {

    private let container = UIView()
    private let pillLabel = UILabel()
    private let prefixImageView = UIImageView()
    private let suffixImageView = UIImageView()
    private let closeButton = UIButton(type: .system)

    private var tapAction: (() -> Void)?
    private var removeAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 16

        container.addSubview(prefixImageView)
        container.addSubview(pillLabel)
        container.addSubview(suffixImageView)
        container.addSubview(closeButton)

        pillLabel.translatesAutoresizingMaskIntoConstraints = false
        pillLabel.numberOfLines = 1
        pillLabel.setContentHuggingPriority(.required, for: .horizontal)
        pillLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        prefixImageView.translatesAutoresizingMaskIntoConstraints = false
        suffixImageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        closeButton.setTitle("✕", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            prefixImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            prefixImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            prefixImageView.widthAnchor.constraint(equalToConstant: 16),
            prefixImageView.heightAnchor.constraint(equalToConstant: 16),

            pillLabel.leadingAnchor.constraint(equalTo: prefixImageView.trailingAnchor, constant: 4),
            pillLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),

            closeButton.leadingAnchor.constraint(equalTo: pillLabel.trailingAnchor, constant: 4),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            closeButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 20),

            suffixImageView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -4),
            suffixImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            suffixImageView.widthAnchor.constraint(equalToConstant: 16),
            suffixImageView.heightAnchor.constraint(equalToConstant: 16)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        contentView.addGestureRecognizer(tap)
    }

    func configure(with item: PillItemV2, tapAction: @escaping () -> Void, removeAction: @escaping () -> Void) {
        self.tapAction = tapAction
        self.removeAction = removeAction

        pillLabel.text = item.title
        pillLabel.font = item.font
        pillLabel.textColor = item.isSelected ? item.selectedTextColor : item.textColor

        container.backgroundColor = item.isSelected ? item.selectedBackgroundColor : item.backgroundColor
        container.layer.borderWidth = item.isSelected ? 1 : 0
        container.layer.borderColor = (item.isSelected ? item.selectedBorderColor : item.borderColor).cgColor

        prefixImageView.image = item.prefixIcon
        suffixImageView.image = item.suffixIcon
        closeButton.isHidden = !item.showsCloseButton
    }

    @objc private func didTap() {
        tapAction?()
    }

    @objc private func didTapClose() {
        removeAction?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pillLabel.text = nil
        prefixImageView.image = nil
        suffixImageView.image = nil
        closeButton.isHidden = true
        contentView.gestureRecognizers?.forEach { contentView.removeGestureRecognizer($0) }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width,
                                height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
        layoutAttributes.size = size
        return layoutAttributes
    }
}

public final class PillsFormRowV2: FormRow {
    public let tag: Int
    public var items: [PillItemV2]
    
    // Options
    public var singleSelect: Bool = false
    public var showSelectAllClear: Bool = false
    
    // Callbacks
    public var onSelectionChanged: ((PillItemV2) -> Void)?
    public var onItemRemoved: ((PillItemV2) -> Void)?
    
    public init(tag: Int, items: [PillItemV2], singleSelect: Bool = false, showSelectAllClear: Bool = false) {
        self.tag = tag
        self.items = items
        self.singleSelect = singleSelect
        self.showSelectAllClear = showSelectAllClear
    }
    
    public var rowType: FormRowType { .tableView }
    public var cellTag: String { "PillsFormRowV2\(tag)" }
    
    public let reuseIdentifier = String(describing: PillsTableViewCellV2.self)
    public var cellClass: AnyClass? { PillsTableViewCellV2.self }
    
    public func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? PillsTableViewCellV2 else { return cell }
        
        var displayItems = items
        
        // If selectAll/clear helper is enabled, add special “Select All / Clear” pill
        if showSelectAllClear {
            let allSelected = items.allSatisfy { $0.isSelected }
            let helperTitle = allSelected ? "Clear" : "Select All"
            let helperPill = PillItemV2(
                id: "helper",
                title: helperTitle,
                backgroundColor: .systemGray4,
                selectedBackgroundColor: .systemGray4,
                textColor: .label,
                selectedTextColor: .label
            )
            displayItems.insert(helperPill, at: 0)
        }
        
        cell.configure(with: displayItems)
        
        // Cell selection handling
        cell.collectionView.delegate = nil
        cell.collectionView.dataSource = nil
        cell.collectionView.dataSource = cell
        cell.collectionView.delegate = cell
        
        return cell
    }
    
    public func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return PillsTableViewCellV2.estimatedHeight(for: items)
    }
    
    // MARK: - Helpers
    public func toggleSelection(for itemId: String) {
        if singleSelect {
            items = items.map { PillItemV2(
                id: $0.id,
                title: $0.title,
                isSelected: $0.id == itemId,
                prefixIcon: $0.prefixIcon,
                suffixIcon: $0.suffixIcon,
                showsCloseButton: $0.showsCloseButton,
                backgroundColor: $0.backgroundColor,
                selectedBackgroundColor: $0.selectedBackgroundColor,
                textColor: $0.textColor,
                selectedTextColor: $0.selectedTextColor,
                borderColor: $0.borderColor,
                selectedBorderColor: $0.selectedBorderColor,
                font: $0.font,
                cornerRadius: $0.cornerRadius,
                horizontalPadding: $0.horizontalPadding
            ) }
        } else {
            for i in 0..<items.count {
                if items[i].id == itemId {
                    items[i].isSelected.toggle()
                    onSelectionChanged?(items[i])
                    break
                }
            }
        }
    }
    
    public func selectAll() {
        items = items.map { pill in
            var updated = pill
            updated.isSelected = true
            return updated
        }
    }
    
    public func clearAll() {
        items = items.map { pill in
            var updated = pill
            updated.isSelected = false
            return updated
        }
    }
    
    public func removeItem(id: String) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            let removed = items.remove(at: index)
            onItemRemoved?(removed)
        }
    }
}
