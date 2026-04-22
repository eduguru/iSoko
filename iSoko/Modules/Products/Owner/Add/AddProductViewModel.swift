//
//  AddProductViewModel.swift
//  
//
//  Created by Edwin Weru on 07/04/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class AddProductViewModel: FormViewModel {
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void)
    -> Void = { _, _, _ in }
    
    var goToComoditySelection: (_ completion: @escaping (CommodityV1Response?) -> Void) -> Void = { _ in }
    
    var gotoConfirm: (() -> Void)?
    
    // MARK: - State
    private var state = State()
    
    override init() {
        super.init()
        sections = makeSections()
    }
    
    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    headerRow,
                    stepIndicatorRow,
                    productNameRow,
                    priceRow,
                    minOrderQtyRow,
                    descriptionRow,
                    commodityTypeRow,
                    measurementUnitRow,
                    SpacerFormRow(tag: 100),
                    continueButtonRow
                ]
            )
        ]
    }
    
    // MARK: - Header
    private lazy var headerRow = TitleDescriptionFormRow(
        tag: CellTag.header.rawValue,
        model: TitleDescriptionModel(
            title: "What are you Selling?",
            description: "Enter your product details below",
            maxTitleLines: 2,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .headline,
            descriptionFontStyle: .subheadline
        )
    )
    
    private lazy var stepIndicatorRow = StepStripFormRow(
        tag: CellTag.steps.rawValue,
        model: StepStripModel(totalSteps: 2, currentStep: 1)
    )
    
    // MARK: - Inputs
    
    private lazy var productNameRow = makeInputRow(
        tag: CellTag.productName.rawValue,
        title: "Name of the Product",
        placeholder: "Enter product name",
        keyboard: .default
    )
    
    private lazy var priceRow = makeInputRow(
        tag: CellTag.price.rawValue,
        title: "Price Per Unit",
        placeholder: "Enter price",
        keyboard: .decimalPad
    )
    
    private lazy var minOrderQtyRow = makeInputRow(
        tag: CellTag.minOrderQty.rawValue,
        title: "Minimum Order Qty",
        placeholder: "Enter minimum quantity",
        keyboard: .numberPad
    )
    
    private func makeInputRow(
        tag: Int,
        title: String,
        placeholder: String,
        keyboard: UIKeyboardType
    ) -> SimpleInputFormRow {
        
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: keyboard
                ),
                validation: ValidationConfiguration(isRequired: true),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] text in
                    guard let self else { return }
                    
                    switch tag {
                    case CellTag.productName.rawValue:
                        state.productName = text
                    case CellTag.price.rawValue:
                        state.price = text
                    case CellTag.minOrderQty.rawValue:
                        state.minOrderQty = text
                    default:
                        break
                    }
                }
            )
        )
    }
    
    // MARK: - Description
    
    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "Describe the product",
                accessoryImage: UIImage(systemName: "pencil"),
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "Describe the product",
            useCardStyle: true,
            onTextChanged: { [weak self] text in
                self?.state.description = text
            }
        )
    )
    
    // MARK: - Dropdowns
    
    private lazy var commodityTypeRow = DropdownFormRow(
        tag: CellTag.commodityType.rawValue,
        config: DropdownFormConfig(
            title: "Type of Commodity",
            placeholder: "Select commodity type",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleCommoditySelection()
            }
        )
    )
    
    private lazy var measurementUnitRow = DropdownFormRow(
        tag: CellTag.measurementUnit.rawValue,
        config: DropdownFormConfig(
            title: "Measurement Unit",
            placeholder: "Select unit",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleMeasurementSelection()
            }
        )
    )
    
    // MARK: - Button
    
    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.gotoConfirm?()
        }
    )
    
    // MARK: - Handlers
    
    private func handleCommoditySelection() {
        goToComoditySelection() { [weak self] value in
            guard let self, let value else { return }
            
            // state.selectedCommodity = value
            let dropDownRow: DropdownFormRow = self.commodityTypeRow

            dropDownRow.config.placeholder = value.name ?? ""
            self.reloadRow(withTag: dropDownRow.tag)
        }
    }
    
    private func handleMeasurementSelection() {
        goToCommonSelectionOptions(.measurementUnits(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.selectedMeasurement = value
            let dropDownRow: DropdownFormRow = self.measurementUnitRow

            dropDownRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: dropDownRow.tag)
        }
    }
    
    // MARK: - Helpers
    
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
    // MARK: - State
    
    private struct State {
        var productName: String?
        var price: String?
        var minOrderQty: String?
        var description: String?
        
        var selectedCommodity: CommonIdNameModel?
        var selectedMeasurement: CommonIdNameModel?
    }
    
    // MARK: - Tags
    
    private enum SectionTag: Int {
        case main = 0
    }
    
    private enum CellTag: Int {
        case header = 1
        case steps
        case productName
        case price
        case minOrderQty
        case description
        case commodityType
        case measurementUnit
        case continueButton
    }
}
