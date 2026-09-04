//
//  ProductFiltersViewModel.swift
//  
//
//  Created by Edwin Weru on 04/09/2026.
//

import DesignSystemKit

public struct ProductFilters {
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var categoryId: Int? = nil

    var isEmpty: Bool {
        minPrice == nil && maxPrice == nil && categoryId == nil
    }
}

@MainActor
final class ProductFiltersViewModel: FormViewModel {

    // MARK: - Output
    var onFiltersConfirmed: ((ProductFilters) -> Void)?
    var onDismiss: (() -> Void)?

    // MARK: - State
    private var state: State

    init(currentFilters: ProductFilters) {
        self.state = State(filters: currentFilters)
        super.init()
        sections = makeSections()
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.price.rawValue,
                title: "Price Range",
                cells: [
                    minPriceRow,
                    maxPriceRow
                ]
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

    // MARK: - Rows
    private lazy var minPriceRow = makeInputRow(
        tag: CellTag.minPrice.rawValue,
        title: "Min Price",
        placeholder: "0",
        initialText: state.filters.minPrice.map { "\($0)" } ?? ""
    )

    private lazy var maxPriceRow = makeInputRow(
        tag: CellTag.maxPrice.rawValue,
        title: "Max Price",
        placeholder: "Any",
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

    private lazy var applyButtonRow = ButtonFormRow(
        tag: CellTag.apply.rawValue,
        model: ButtonFormModel(
            title: "Apply Filters",
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
            title: "Clear Filters",
            style: .outlined,
            size: .medium
        ) { [weak self] in
            guard let self else { return }
            self.state.filters = ProductFilters()
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
        case actions = 1
    }

    private enum CellTag: Int {
        case minPrice = 1
        case maxPrice = 2
        case apply = 10
        case clear = 11
    }
}
