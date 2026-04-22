//
//  AddBookKeepingSalesViewModel.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class AddBookKeepingSalesViewModel: FormViewModel {
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void)
    -> Void = { _, _, _ in }
    
    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }
    var goToAddCustomer: (() -> Void)? = { }
    
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?

    var gotoSelectLocation: ((_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)?
    var gotoConfirm: (() -> Void)?

    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    @MainActor private let countryHelper = CountryHelper()
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService

    // MARK: -
    private var state = State()

    // MARK: -
    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Section Builder
    private func makeSections() -> [FormSection] {
        sections.append(makeSegmentSection())
        sections.append(makeSalesSection())
        sections.append(makeProductSection())
        sections.append(makeDescriptionSection())
        sections.append(makeSummarySection())
        sections.append(makeSubmitSection())
        
        return sections
    }
    
    // MARK: - Fetch
    override func fetchData() {
        Task {
            let success = await performNetworkRequest()

            if !success {
                print("Failed to fetch suppliers")
            }

            await MainActor.run {
                // self.updateRecentActivitiesSection()
            }
        }
    }
    
    // MARK: - Network
    
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        do {
            let response = try await bookKeepingService.getSalesType(
                page: 1,
                count: 10,
                accessToken: state.oauthToken
            )

            // store real data

            return true
        } catch {
            print("❌ Error: ", error)
            return false
        }
    }
    
    private func makeSegmentSection() -> FormSection {
        FormSection(
            id: SectionTag.segmentControl.rawValue,
            cells: [
                pillsOptions
            ]
        )
    }
    
    private func makeSalesSection() -> FormSection {
        FormSection(
            id: SectionTag.salesDetails.rawValue,
            title: "Sales Details",
            cells: [
                dateRow,
                customerRow,
                paymentOptionsRow
            ]
        )
    }
    
    private func makeProductSection() -> FormSection {
        FormSection(
            id: SectionTag.productDetails.rawValue,
            title: "Products",
            cells: makeCartItemsRow()
        )
    }
    
    private func makeDescriptionSection() -> FormSection {
        FormSection(
            id: SectionTag.description.rawValue,
            title: "Description/Notes",
            cells: [
                SpacerFormRow(tag: 6),
                descriptionRow,
            ]
        )
    }
    
    private func makeSummarySection() -> FormSection {
        FormSection(
            id: SectionTag.summary.rawValue,
            title: "Summary",
            cells: summaryRows
        )
    }
    
    private func makeSubmitSection() -> FormSection {
        FormSection(
            id: SectionTag.summary.rawValue,
            cells: [
                SpacerFormRow(tag: 20),
                continueButtonRow
            ]
        )
    }

    // MARK: - Rows
    private lazy var pillsOptions = makePillsOptionsFormRow()
    private lazy var summaryRows = makeSummaryRows()
    
    
    

    private lazy var customerNameInputRow = makeInputRow(
        tag: CellTag.customerName.rawValue,
        title: "Customer Name",
        placeholder: "Enter Customer Name"
    )
    
    private lazy var customerRow = DropdownFormRow(
        tag: CellTag.customerName.rawValue,
        config: DropdownFormConfig(
            title: "Customer Name",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in
                self?.handleCustomerSelection()
            },
            onActionTap: { [weak self] in
                self?.goToAddCustomer?()
            },
            actionImage: UIImage(systemName: "person.badge.plus"),
            showsActionButton: true
        )
    )
    
    private lazy var dateRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Date",
            placeholder: "Date",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                guard let self else { return }

                let config = DatePickerConfig.year()

                self.goToDateSelection(config) { selectedDate in
                    guard let date = selectedDate else { return }

                    self.state.date = date
                    self.state.dateString = Self.format(date)

                    self.handleDateSelection()
                }
            }
        )
    )
    
    private lazy var paymentOptionsRow = DropdownFormRow(
        tag: CellTag.paymentMethod.rawValue,
        config: DropdownFormConfig(
            title: "Payment Method",
            placeholder: "Method",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handlePaymentsSelection()
            }
        )
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
                    case CellTag.customerName.rawValue:
                        self.state.supplierName = newText
                    default:
                        break
                    }
                }
            )
        )
    }
    
    private lazy var addItemButtonRow = ButtonFormRow(
        tag: CellTag.addItemButton.rawValue,
        model: ButtonFormModel(
            title: "Add Another Item",
            style: .outlined,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task {
                await self?.submit()
            }
        }
    )
    
    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
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
    
    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(
                prefixText: "",
                accessoryImage: nil,
                isScrollable: true,
                fixedHeight: 120
            ),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "",
            useCardStyle: false,
            cardStyle: .borderAndShadow,
            cardCornerRadius: 12,
            cardBorderColor: .app(.primary),
            cardShadowColor: .gray,
            onTextChanged: { newText in
                print("Description changed to: \(newText)")
            },
            onValidationError: { error in
                if let error = error {
                    print("Validation error: \(error)")
                }
            }
        )
    )
    
    private func makePillsOptionsFormRow() -> FormRow {
        PillsFormRowV2(
            tag: 98,
            items: [
                PillItem(id: "1", title: "Cash"),
                PillItem(id: "2", title: "Credit")
            ],
            layoutMode: .segmentedStretch,
            selectionMode: .single
        ) { items in
            print(items.first(where: { $0.isSelected }))
        }
    }
    
    private func makeCartItemsRow() -> [FormRow] {

        let banana = CartItemViewModel(
            id: 1,
            title: "Organic Bananas",
            subtitle: "Original Price: Ksh. 20/kg",
            pricePerUnit: 20,
            quantity: 3
        )

        let milk = CartItemViewModel(
            id: 2,
            title: "Fresh Milk",
            subtitle: "Original Price: Ksh. 60/L",
            pricePerUnit: 60,
            quantity: 2
        )

        return [
            CartItemFormRow(tag: 1, viewModel: banana),
            CartItemFormRow(tag: 2, viewModel: milk),
            SpacerFormRow(tag: -000),
            addItemButtonRow
        ]
    }
    
    private func makeSummaryRows() -> [FormRow] {
        return [
            KeyValueFormRow(
                tag: 1,
                model: KeyValueRowModel(
                    leftText: "Subtotal",
                    rightText: "$120",
                    usesMonospacedDigits: true
                )
            ),
            
            KeyValueFormRow(
                tag: 2,
                model: KeyValueRowModel(
                    leftText: "Tax",
                    rightText: "$12",
                    usesMonospacedDigits: true
                )
            ),
            
            KeyValueFormRow(
                tag: 3,
                model: KeyValueRowModel(
                    leftText: "Total",
                    rightText: "$132",
                    showsTopDivider: true,
                    isEmphasized: true,
                    usesMonospacedDigits: true
                )
            )
        ]
    }

    // MARK: - handle selections
    
    private func handleCustomerSelection() {
        goToCommonSelectionOptions(.customers(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.customer = value
            let dropDownRow: DropdownFormRow = customerRow

            dropDownRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: dropDownRow.tag)
        }
    }
    
    private func handlePaymentsSelection() {
        goToCommonSelectionOptions(.paymentOptions(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.paymentMethod = value
            let dropDownRow: DropdownFormRow = paymentOptionsRow

            dropDownRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: dropDownRow.tag)
        }
    }
    
    private func handleDateSelection() {
        var config = dateRow.config
        config.placeholder = state.dateString
        dateRow.config = config

        reloadRow(withTag: CellTag.date.rawValue)
    }
    
    private static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
    
    private func reloadBodySection(animated: Bool = true) {
        
    }

    // MARK: - Submit
    private func submit() async {

    }

    // MARK: - State
    private struct State {
        var selectedSegmentIndex: Int = 0
        var categories: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?
        var customer: CommonIdNameModel?

        var date: Date?
        var dateString: String = ""
        
        var amount: String = ""
        var supplierName: String = ""
        var description: String = ""

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    private enum SectionTag: Int {
        case segmentControl = 0
        case salesDetails = 1
        case productDetails = 2
        case description = 3
        case summary = 4
        case submit = 5
    }

    private enum CellTag: Int {
        case segment = 4
        case date = 5
        case customerName = 8
        case paymentMethod = 6
        case addItem = 7
        case description = 11
        case summary = 12
        case addItemButton = 9
        case continueButton = 10
        
    }
}


// https://api.dev.isoko.africa/v1/users/7/products?size=50&page=1&bookkeepingStock=true
