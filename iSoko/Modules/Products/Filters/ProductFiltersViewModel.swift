//
//  ProductFiltersViewModel.swift
//  
//
//  Created by Edwin Weru on 04/09/2026.
//

import DesignSystemKit
import UIKit

@MainActor
final class ProductFiltersViewModel: FormViewModel {

    // MARK: - Output
    var onFiltersConfirmed: ((ProductFilters) -> Void)?
    var onDismiss: (() -> Void)?

    // MARK: - Navigation
    var goToFilterPicker: ((_ option: FilterPickerOption, _ completion: @escaping (CommonIdNameModel?) -> Void) -> Void) = { _, _ in }
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }

    // MARK: - State
    private var state: State

    init(currentFilters: ProductFilters) {
        self.state = State(filters: currentFilters)
        super.init()
        sections = makeSections()
        prefill()
    }

    // MARK: - Prefill
    private func prefill() {
        if let name = state.filters.categoryName {
            categoryRow.config.placeholder = name
        }
        if let name = state.filters.associationName {
            associationRow.config.placeholder = name
        }
        if let name = state.filters.locationName {
            locationRow.config.placeholder = name
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.price.rawValue,
                title: "common.label.price_range".localized,
                cells: [minPriceRow, maxPriceRow]
            ),
            FormSection(
                id: SectionTag.dropdowns.rawValue,
                title: "common.action.filter_by".localized,
                cells: [categoryRow, associationRow, locationRow]
            ),
            FormSection(
                id: SectionTag.actions.rawValue,
                cells: [
                    SpacerFormRow(tag: 20),
                    applyButtonRow,
                    clearButtonRow
                ]
            )
        ]
    }

    // MARK: - Price Rows
    private lazy var minPriceRow = makeInputRow(
        tag: CellTag.minPrice.rawValue,
        title: "common.label.min_price".localized,
        placeholder: "0",
        initialText: state.filters.minPrice.map { "\($0)" } ?? ""
    )

    private lazy var maxPriceRow = makeInputRow(
        tag: CellTag.maxPrice.rawValue,
        title: "common.label.max_price".localized,
        placeholder: "common.label.any".localized,
        initialText: state.filters.maxPrice.map { "\($0)" } ?? ""
    )

    private func makeInputRow(tag: Int, title: String, placeholder: String, initialText: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: initialText,
                config: TextFieldConfig(placeholder: placeholder, keyboardType: .decimalPad),
                validation: ValidationConfiguration(isRequired: false),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }
                    switch tag {
                    case CellTag.minPrice.rawValue:
                        self.state.filters.minPrice = Double(newText)
                    case CellTag.maxPrice.rawValue:
                        self.state.filters.maxPrice = Double(newText)
                    default:
                        break
                    }
                }
            )
        )
    }

    // MARK: - Dropdown Rows
    private lazy var categoryRow = DropdownFormRow(
        tag: CellTag.category.rawValue,
        config: DropdownFormConfig(
            title: "common.label.category".localized,
            placeholder: "common.label.all_categories".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleCategorySelection()
            }
        )
    )

    private lazy var associationRow = DropdownFormRow(
        tag: CellTag.association.rawValue,
        config: DropdownFormConfig(
            title: "common.label.association".localized,
            placeholder: "common.label.all_associations".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleAssociationSelection()
            }
        )
    )

    private lazy var locationRow = DropdownFormRow(
        tag: CellTag.location.rawValue,
        config: DropdownFormConfig(
            title: "common.label.location".localized,
            placeholder: "common.label.all_locations".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleLocationSelection()
            }
        )
    )

    // MARK: - Selection Handlers
    private func handleCategorySelection() {
        print("🔍 handleCategorySelection fired")
        print("🔍 goToFilterPicker is set: \(true)") // always prints
        
        goToFilterPicker(.category) { [weak self] value in
            print("🔍 category picker returned: \(value?.name ?? "nil")")
            guard let self else { return }
            self.state.filters.categoryId = value?.id
            self.state.filters.categoryName = value?.name
            self.categoryRow.config.placeholder = value?.name ?? "All Categories"
            self.reloadRow(withTag: CellTag.category.rawValue)
        }
    }

    private func handleAssociationSelection() {
        goToFilterPicker(.association) { [weak self] value in
            guard let self else { return }
            self.state.filters.associationId = value?.id
            self.state.filters.associationName = value?.name
            self.associationRow.config.placeholder = value?.name ?? "All Associations"
            self.reloadRow(withTag: CellTag.association.rawValue)
        }
    }

    private func handleLocationSelection() {
        goToFilterPicker(.location) { [weak self] value in
            guard let self else { return }
            self.state.filters.locationId = value?.id
            self.state.filters.locationName = value?.name
            self.locationRow.config.placeholder = value?.name ?? "All Locations"
            self.reloadRow(withTag: CellTag.location.rawValue)
        }
    }

    // MARK: - Reload Row
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Action Rows
    private lazy var applyButtonRow = ButtonFormRow(
        tag: CellTag.apply.rawValue,
        model: ButtonFormModel(
            title: "common.action.apply_filters".localized,
            style: .primary,
            size: .medium
        ) { [weak self] in
            guard let self else { return }
            self.onFiltersConfirmed?(self.state.filters)
            self.onDismiss?()
        }
    )

    private lazy var clearButtonRow = ButtonFormRow(
        tag: CellTag.clear.rawValue,
        model: ButtonFormModel(
            title: "common.action.clear_filters".localized,
            style: .outlined,
            size: .medium
        ) { [weak self] in
            guard let self else { return }
            self.state.filters = ProductFilters()
            self.categoryRow.config.placeholder = "common.label.all_categories".localized
            self.associationRow.config.placeholder = "common.label.all_associations".localized
            self.locationRow.config.placeholder = "common.label.all_locations".localized
            self.onFiltersConfirmed?(self.state.filters)
            self.onDismiss?()
        }
    )

    // MARK: - State
    private struct State {
        var filters: ProductFilters
        init(filters: ProductFilters) {
            self.filters = filters
        }
    }

    // MARK: - Tags
    private enum SectionTag: Int {
        case price = 0
        case dropdowns = 1
        case actions = 2
    }

    private enum CellTag: Int {
        case minPrice = 1
        case maxPrice = 2
        case category = 3
        case association = 4
        case location = 5
        case apply = 10
        case clear = 11
    }
}
