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
    var selectFoundedYear: ((_ completion: @escaping (Int?) -> Void) -> Void)?
    var gotoSelectLocation: ((_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)?
    
    var gotoConfirm: (() -> Void)?
    var goToShowSuccessScreen: (() -> Void)?
    
    var showCountryPicker: ((@escaping (Country) -> Void) -> Void) -> Void = { _ in }
    
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: - State
    private var state: State
    
    // MARK: - Init
    init(stock: StockResponse) {
        self.state = State(stock: stock)
        super.init()
        
        state.date = Date()
        state.dateString = Helpers.format(state.date!)
        
        sections = makeSections()
        prefill()
    }
    
    // MARK: - Prefill (ONLY REAL CHANGE)
    private func prefill() {
        
        productNameInputRow.model.text = state.productName
        unitCostInputRow.model.text = state.unitCost
        lowStockLevelInputRow.model.text = state.lowStockLevel
        
        if let supplier = state.supplier {
            supplierDropdownRow.config.placeholder = supplier.firstName ?? ""
        }
        
        if let dateString = state.dateString as String? {
            dataRow.config.placeholder = dateString
        }
    }
    
    // MARK: - Sections 
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
    
    private lazy var supplierDropdownRow = DropdownFormRow(
        tag: CellTag.supplierName.rawValue,
        config: DropdownFormConfig(
            title: "Supplier",
            placeholder: "Select Supplier",
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
            placeholder: "Date",
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
            title: "Update Stock",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )
    
    private func makeInputRow(tag: Int, title: String, placeholder: String) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: .default
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
                        
                    case CellTag.productName.rawValue:
                        self.state.productName = newText
                        
                    default:
                        break
                    }
                }
            )
        )
    }
    
    private func makeFilterFormRow() -> FormRow {
        FiltersFormRow(
            tag: 1,
            config: FiltersCellConfig(
                title: nil,
                rows: [
                    [
                        FilterFieldConfig(
                            placeholder: "Quantity",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: { print("Quantity tapped") }
                        ),
                        FilterFieldConfig(
                            placeholder: "Unit of Measure",
                            selectedValue: nil,
                            iconSystemName: "tag",
                            onTap: { print("UOM tapped") }
                        )
                    ]
                ],
                message: nil
            )
        )
    }
    
    // MARK: - Selection Handlers 

    private func handleSupplierSelection() {
        gotoSelectLocation? { [weak self] value in
            guard let self, let value else { return }

            self.state.supplier = TraderResponse(from: value)
            self.supplierDropdownRow.config.placeholder = value.name
            self.reloadRow(withTag: self.supplierDropdownRow.tag)
        }
    }
    
    private func handleDateYearSelection() {
        selectFoundedYear? { [weak self] value in
            guard let self, let value else { return }

            self.state.foundedYear = value
            self.state.dateString = "\(value)"
            self.dataRow.config.placeholder = "\(value)"
            self.reloadRow(withTag: self.dataRow.tag)
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
        let success = await performNetworkRequest()
        if success {
            goToShowSuccessScreen?()
        }
    }
    
    private func performNetworkRequest() async -> Bool {
        guard let supplier = state.supplier else {
            print("❌ Missing supplier")
            return false
        }

        showLoader()

        let record: [String: Any] = [
            "id": state.stock.id ?? 0,
            "name": state.productName,
            "price": state.unitCost,
            "quantity": state.unitCost,
            "supplierId": supplier.id ?? 0,
            "measurementUnitId": supplier.id ?? 0,
            "description": "n/a",
            "minimumOrderQuantity": state.unitCost,
            "stockAlertThreshold": state.lowStockLevel
        ]

        do {
//            _ = try await bookKeepingService.updateProduct(
//                parameters: record,
//                accessToken: state.oauthToken
//            )

            hideLoader()
            return true

        } catch {
            hideLoader()
            print("❌ Error:", error)
            return false
        }
    }
    
    // MARK: - State
    private struct State {
        let stock: StockResponse
        
        var supplier: TraderResponse?
        
        var productName: String
        var unitCost: String
        var lowStockLevel: String
        
        var date: Date?
        var dateString: String = ""
        
        var foundedYear: Int?
        
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        
        init(stock: StockResponse) {
            self.stock = stock
            
            self.productName = stock.name ?? ""
            self.unitCost = stock.price.map { "\($0)" } ?? ""
            self.lowStockLevel = stock.minimumOrderQuantity.map { "\($0)" } ?? ""
            
            self.supplier = stock.trader
        }
    }
    
    // MARK: - Tags
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
