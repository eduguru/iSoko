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
    
    var gotoConfirm: (() -> Void)?
    var goToAddSupplier: (() -> Void)? = { }
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }

    var gotoSelectLocation: (CommonUtilityOption, _ completion: @escaping (LocationModel?) -> Void) -> Void = { _, _ in }

    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }

    
    var goToShowSuccessScreen: (() -> Void)?

    var showCountryPicker: ((@escaping (Country) -> Void) -> Void) -> Void = { _ in }
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: - State
    private var state = State()

    override init() {
        super.init()
        state.date = Date()
        state.dateString = Helpers.format(state.date!)
        sections = makeSections()
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    dateRow,
                    productNameInputRow,
                    supplierDropdownRow,
                    unitCostInputRow,
                    measurementUnitRow,
                    quantityInputRow,
                    lowStockLevelInputRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows
    private lazy var productNameInputRow = makeInputRow(
        tag: CellTag.productName.rawValue,
        title: "Product Name",
        placeholder: "Product Name"
    )
    
    private lazy var quantityInputRow = makeInputRow(
        tag: CellTag.quantity.rawValue,
        title: "Quantity",
        placeholder: "Quantity"
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
                        self.state.lowStockLevel = newText
                    case CellTag.unitCost.rawValue:
                        self.state.unitCost = newText
                    case CellTag.quantity.rawValue:
                        self.state.quantity = newText
                    case CellTag.productName.rawValue:
                        self.state.productName = newText
                    case CellTag.supplierName.rawValue:
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
            placeholder: "common.label.select_option".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in
                self?.handleSupplierSelection()
            },
            onActionTap: { [weak self] in
                self?.goToAddSupplier?()
            },
            actionImage: UIImage(systemName: "person.badge.plus"),
            showsActionButton: true
        )
    )
    
    private lazy var dateRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "common.label.date".localized,
            placeholder: state.dateString.isEmpty ? "common.label.date".localized : state.dateString,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                guard let self else { return }

                self.goToDateSelection(.year()) { date in
                    guard let date else { return }

                    self.state.date = date
                    self.state.dateString = Helpers.format(date)
                    self.handleDateSelection()
                }
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
    
    // MARK: - handle selections
    private func handleSupplierSelection() {
        goToCommonSelectionOptions(.suppliers(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.supplier = value

            self.supplierDropdownRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.supplierDropdownRow.tag)
        }
    }
    
    private func handleDateSelection() {
        var config = dateRow.config
        config.placeholder = state.dateString
        dateRow.config = config

        reloadRow(withTag: CellTag.date.rawValue)
    }
    
    private func handleMeasurementSelection() {
        goToCommonSelectionOptions(.measurementUnits(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }
            
            self.state.selectedMeasurement = value
            
            let row = self.measurementUnitRow
            row.config.placeholder = value?.name ?? ""
            
            self.reloadRow(withTag: row.tag)
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
        // Make sure required fields exist
        guard
            let supplierId = state.supplier?.id,
            let measurementUnitId = state.selectedMeasurement?.id,
            let price = Double(state.unitCost),       // convert to number if needed
            let quantity = Int(state.quantity)        // convert to number
        else {
            showError("Please fill all required fields correctly")
            return
        }
        
        // Prepare the parameters
        let record: [String: Any] = [
            "name": state.productName,
            "price": price,
            "quantity": quantity,
            "supplierId": supplierId,
            "measurementUnitId": measurementUnitId,
            "common.label.description".localized: state.description.isEmpty ? "n/a" : state.description,
            "minimumOrderQuantity": quantity,
            "stockAlertThreshold": Int(state.lowStockLevel) ?? 0
        ]
        
        // Submit
        let success = await submitStockRecord(parameters: record)
        
        if success {
            goToShowSuccessScreen?()
        }
    }

    private func submitStockRecord(parameters: [String: Any]) async -> Bool {
        showLoader()
        defer { hideLoader() }
        
        do {
            let response = try await bookKeepingService.addProduct(parameters: parameters, accessToken: state.oauthToken)
           
            if response.id == nil {
                return false
            }
            
            return true
        } catch let NetworkError.server(response) {
            print("Add Stock ERROR:", response.alertMessage)
            
            await MainActor.run {
                state.errorMessage = response.message
                state.fieldErrors = response.errors
            }

            showError(response.alertMessage)
            return false
        } catch {
            await MainActor.run {
                state.errorMessage = "Something went wrong. Please try again."
            }
            
            print("Add Stock ERROR:", error)
            showError(error.localizedDescription)
            return false
        }
    }

    // MARK: - State
    private struct State {
        var supplier: CommonIdNameModel?
        var selectedMeasurement: CommonIdNameModel?

        var date: Date?
        var dateString: String = ""

        var productName: String = ""
        var quantity: String = ""
        var unitCost: String = ""
        var lowStockLevel: String = ""
        var supplierName: String = ""
        var description: String = ""

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""

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
        case measurementUnit
    }
    
}
