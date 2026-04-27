//
//  AddBookKeepingStockViewModel.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class AddBookKeepingStockViewModel: FormViewModel {
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    var selectFoundedYear: ((_ completion: @escaping (Int?) -> Void) -> Void)?
    var gotoSelectLocation: ((_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)?
    
    var gotoConfirm: (() -> Void)?
    var goToShowSuccessScreen: (() -> Void)?

    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    @MainActor private let countryHelper = CountryHelper()

    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    dataRow,
                    productNameInputRow,
                    supplierDropdownRow,
                    unitCostInputRow,
                    filterFormRow,
                    lowStockLevelInputRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows
    private lazy var filterFormRow: FormRow = makeFilterFormRow()

    private lazy var productNameInputRow = makeInputRow(
        tag: CellTag.productName.rawValue,
        title: "Product Name",
        placeholder: "Product Name"
    )
    
    private lazy var unitCostInputRow = makeInputRow(
        tag: CellTag.unitCost.rawValue,
        title: "Unit Cost",
        placeholder: "Enter Unit Cost"
    )
    
    private lazy var lowStockLevelInputRow = makeInputRow(
        tag: CellTag.lowStockLevel.rawValue,
        title: "Low Stock Level",
        placeholder: "Enter Low Stock Level"
    )
    
    private func makeInputRow(tag: Int, title: String, placeholder: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: .URL
                ),
                validation: ValidationConfiguration(isRequired: false),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }

                    switch tag {
                    case CellTag.lowStockLevel.rawValue:
                        self.state.amount = newText
                    case CellTag.unitCost.rawValue:
                        self.state.supplierName = newText
                    default:
                        break
                    }
                }
            )
        )
    }
    
    private lazy var supplierDropdownRow = DropdownFormRow(
        tag: CellTag.supplierName.rawValue,
        config: DropdownFormConfig(
            title: "Supplier",
            placeholder: state.categories?.name ?? "Select Supplier",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleSupplierSelection()
            }
        )
    )
    
    private lazy var dataRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Date",
            placeholder: "\(state.foundedYear ?? 0000)",
            rightImage: UIImage(systemName: "calendar"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleDateYearSelection()
            }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Add Stock",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task {
                await self?.submit()
            }
        }
    )
    
    private func makeFilterFormRow() -> FormRow {
        let row = FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: nil,
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Quantity",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: {
                                print("Sale Type tapped")
                            }
                        ),
                        FilterFieldConfig(
                            placeholder: "Unit of Measure",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: {
                                print("Time Period tapped")
                            }
                        )
                    ]
                ],
                message: nil
            )
        )

        return row
    }

    // MARK: - handle selections
    private func handleSupplierSelection() {
        gotoSelectLocation? { [weak self] value in
            guard let self, let value else { return }

            self.state.categories = value
            self.supplierDropdownRow.config.placeholder = value.name
            self.reloadRow(withTag: self.supplierDropdownRow.tag)
        }
    }
    
    private func handleDateYearSelection() {
        selectFoundedYear? { [weak self] value in
            guard let self, let value else { return }
            state.foundedYear = value
            dataRow.config.placeholder = "\(value)"
            reloadRow(withTag: dataRow.tag)
        }
    }

    // MARK: - Reload
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Submit
    private func submit() async {
        goToShowSuccessScreen?()
    }

    // MARK: - State
    private struct State {
        var categories: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?

        var dateString: String = ""
        var amount: String = ""
        var supplierName: String = ""
        var description: String = ""
        var foundedYear: Int?

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case date = 5
        case productName = 4
        case supplierName = 8
        case unitCost = 6
        case quantity = 7
        case unitMeasure = 9
        case lowStockLevel = 11
        case continueButton = 12
    }
}


