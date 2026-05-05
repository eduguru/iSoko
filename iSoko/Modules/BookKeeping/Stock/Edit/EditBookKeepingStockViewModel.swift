//
//  EditBookKeepingStockViewModel.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class EditBookKeepingStockViewModel: FormViewModel {

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

    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    // MARK: - State
    private var state: State

    // MARK: - Init
    init(stock: StockResponse) {
        self.state = State(stock: stock)
        super.init()
        sections = makeSections()
    }

    // MARK: - Sections
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
        placeholder: "Product Name",
        initialText: state.productName
    )
    
    private lazy var quantityInputRow = makeInputRow(
        tag: CellTag.quantity.rawValue,
        title: "Quantity",
        placeholder: "Quantity",
        initialText: "\(state.quantity)"
    )
    
    private lazy var unitCostInputRow = makeInputRow(
        tag: CellTag.unitCost.rawValue,
        title: "Unit Cost",
        placeholder: "Enter Unit Cost",
        initialText: "\(state.unitCost)"
    )
    
    private lazy var lowStockLevelInputRow = makeInputRow(
        tag: CellTag.lowStockLevel.rawValue,
        title: "Low Stock Level",
        placeholder: "Enter Low Stock Level",
        initialText: "\(state.lowStockLevel)"
    )
    
    private func makeInputRow(tag: Int, title: String, placeholder: String, initialText: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: initialText,
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: .numberPad
                ),
                validation: ValidationConfiguration(isRequired: true),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }
                    switch tag {
                    case CellTag.unitCost.rawValue:
                        self.state.unitCost = Double(newText) ?? 0
                    case CellTag.quantity.rawValue:
                        self.state.quantity = Double(newText) ?? 0
                    case CellTag.lowStockLevel.rawValue:
                        self.state.lowStockLevel = Double(newText) ?? 0
                    case CellTag.productName.rawValue:
                        self.state.productName = newText
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
            placeholder: state.supplier?.name ?? "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in self?.handleSupplierSelection() },
            onActionTap: { [weak self] in self?.goToAddSupplier?() },
            actionImage: UIImage(systemName: "person.badge.plus"),
            showsActionButton: true
        )
    )
    
    private lazy var dateRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Date",
            placeholder: state.dateString.isEmpty ? "Date" : state.dateString,
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
            placeholder: state.measurementUnit?.name ?? "Select unit",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in self?.handleMeasurementSelection() }
        )
    )
    
    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Update Stock",
            style: .primary,
            size: .medium
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )

    // MARK: - Handle Selections
    private func handleSupplierSelection() {
        goToCommonSelectionOptions(.suppliers(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }
            self.state.supplier = value
            self.supplierDropdownRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.supplierDropdownRow.tag)
        }
    }
    
    private func handleMeasurementSelection() {
        goToCommonSelectionOptions(.measurementUnits(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }
            self.state.measurementUnit = value
            self.measurementUnitRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.measurementUnitRow.tag)
        }
    }

    private func handleDateSelection() {
        dateRow.config.placeholder = state.dateString
        reloadRow(withTag: CellTag.date.rawValue)
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

    // MARK: - Submit
    private func submit() async {
        let params: [String: Any] = [
            "id": state.stockId,
            "name": state.productName,
            "price": state.unitCost,
            "quantity": state.quantity,
            "supplierId": state.supplier?.id ?? 0,
            "measurementUnitId": state.measurementUnit?.id ?? 0,
            "lowStockLevel": state.lowStockLevel,
            "date": state.date?.toISO8601String() ?? ""
        ]

        let success = await updateStock(parameters: params)
        if success {
            goToShowSuccessScreen?()
        }
    }

    private func updateStock(parameters: [String: Any]) async -> Bool {
        do {
//            let _ = try await bookKeepingService.updateProduct(
//                id: state.stockId,
//                parameters: parameters,
//                accessToken: state.oauthToken
//            )
            
            return true
        } catch {
            print("❌ Error updating stock: ", error)
            return false
        }
    }

    // MARK: - State
    private struct State {
        var stockId: Int
        var productName: String
        var quantity: Double
        var unitCost: Double
        var lowStockLevel: Double
        var supplier: CommonIdNameModel?
        var measurementUnit: CommonIdNameModel?
        var date: Date?
        var dateString: String = ""
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        
        init(stock: StockResponse) {
            self.stockId = stock.id ?? -1
            self.productName = stock.name ?? ""
            self.quantity = Double(stock.minimumOrderQuantity ?? 0)
            self.unitCost = stock.price ?? 0
            self.lowStockLevel = Double(stock.minimumOrderQuantity ?? 0)
            self.supplier = CommonIdNameModel(id: stockId, name: productName)
            self.measurementUnit = CommonIdNameModel(from: stock.measurementUnit)
            self.date = Date()
            self.dateString = Helpers.format(Date())
        }
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
        case lowStockLevel = 11
        case measurementUnit = 9
        case continueButton = 12
    }
}
