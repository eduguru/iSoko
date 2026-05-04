//
//  EditBookKeepingSalesViewModel.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

@MainActor
final class EditBookKeepingSalesViewModel: FormViewModel {

    // MARK: - Navigation
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }

    var gotoSelectLocation: (CommonUtilityOption, _ completion: @escaping (LocationModel?) -> Void) -> Void = { _, _ in }

    var goToDateSelection: (DatePickerConfig, @escaping (Date?) -> Void) -> Void = { _, _ in }

    var goToAddCustomer: (() -> Void)?
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?

    var goToProductSelection: (
        CommonUtilityOption,
        _ completion: @escaping (StockResponse?) -> Void
    ) -> Void = { _, _ in }

    var gotoConfirm: (() -> Void)?
    var goToShowSuccessScreen: (() -> Void)?

    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    @MainActor private let countryHelper = CountryHelper()

    // MARK: - State
    private var state: State

    // MARK: - Init
    init(sale: SalesResponse) {
        self.state = State(sale: sale)
        super.init()
        
        // Initialize the state with the data from the existing sale
        state.date = sale.saleDate ?? Date()
        state.dateString = Helpers.format(state.date!)
        
        Task { @MainActor in
            sections = makeSections()
        }
    }
    
    private func refreshCartUI() {
        reloadProductSection()
        reloadSummarySection()
    }
    
    private func reloadSummarySection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.summary.rawValue
        }) else { return }

        sections[index].cells = makeSummaryRows()
        reloadSection(index)
    }

    // MARK: - Prefill Data
    private func prefill() {
        // Prefill dropdowns with current sale data
        customerRow.config.placeholder = state.customer?.name ?? ""
        paymentOptionsRow.config.placeholder = state.paymentMethod?.name ?? ""
        
        // Set the sale type based on the existing sale
        if let typeId = state.sale.type?.id {
            state.saleTypeId = typeId
        }

        // Prefill the description
        descriptionRow.model.text = state.description
        
        // Prefill cart items (you might need additional logic here if needed)
        reloadProductSection()
    }

    // MARK: - Fetch Data
    override func fetchData() {
        Task { @MainActor in
            await fetchSalesTypes()
        }
    }

    private func fetchSalesTypes() async {
        showLoader()

        do {
            let response = try await bookKeepingService.getSalesType(
                page: 0,
                count: 10,
                accessToken: state.oauthToken
            )

            state.saleTypes = response.data
            hideLoader()
            
            reloadSegmentSection()

        } catch {
            hideLoader()
            print("❌ Failed to fetch sales types:", error)
        }
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            makeSegmentSection(),
            makeSalesSection(),
            makeProductSection(),
            makeDescriptionSection(),
            makeSummarySection(),
            makeSubmitSection()
        ]
    }

    private func makeSegmentSection() -> FormSection {
        FormSection(
            id: SectionTag.segmentControl.rawValue,
            cells: [pillsOptions]
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
                descriptionRow
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
            id: SectionTag.submit.rawValue,
            cells: [
                SpacerFormRow(tag: 20),
                continueButtonRow
            ]
        )
    }

    // MARK: - Section Reload
    private func reloadProductSection(animated: Bool = true) {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.productDetails.rawValue
        }) else { return }

        sections[index].cells = makeCartItemsRow()
        reloadSection(index)
    }
    
    private func reloadSegmentSection() {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.segmentControl.rawValue
        }) else { return }

        sections[index].cells = [makePillsOptionsFormRow()]
        reloadSection(index)
    }

    // MARK: - Rows
    private lazy var pillsOptions = makePillsOptionsFormRow()
    private lazy var summaryRows = makeSummaryRows()
    
    private func makePillsOptionsFormRow() -> FormRow {

        let items: [PillItem] = state.saleTypes.map {
            PillItem(
                id: String($0.id),
                title: $0.name
            )
        }

        return PillsFormRowV2(
            tag: 98,
            items: items,
            layoutMode: .segmentedStretch,
            selectionMode: .single
        ) { [weak self] items in
            guard let self else { return }

            if let selected = items.first(where: { $0.isSelected }),
               let id = Int(selected.id) {

                self.state.saleTypeId = id
            }
        }
    }
    
    private func makeSummaryRows() -> [FormRow] {

        let subtotal = state.amount
        let tax = 0.0
        let total = subtotal + tax
        let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")

        return [
            KeyValueFormRow(tag: 1, model: .init(leftText: "Subtotal", rightText: Helpers.formatCurrency(subtotal, currency: currency))),
            KeyValueFormRow(tag: 2, model: .init(leftText: "Tax", rightText: Helpers.formatCurrency(tax, currency: currency))),
            KeyValueFormRow(tag: 3, model: .init(leftText: "Total", rightText: Helpers.formatCurrency(total, currency: currency), isEmphasized: true))
        ]
    }

    private lazy var customerRow = DropdownFormRow(
        tag: CellTag.customerName.rawValue,
        config: DropdownFormConfig(
            title: "Customer Name",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in self?.handleCustomerSelection() },
            onActionTap: { [weak self] in self?.goToAddCustomer?() },
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

    private lazy var paymentOptionsRow = DropdownFormRow(
        tag: CellTag.paymentMethod.rawValue,
        config: DropdownFormConfig(
            title: "Payment Method",
            placeholder: "Method",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in self?.handlePaymentsSelection() }
        )
    )

    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: state.description,
            config: TextViewConfig(fixedHeight: 120),
            validation: ValidationConfiguration(isRequired: true),
            titleText: "",
            onTextChanged: { [weak self] text in
                self?.state.description = text
            }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Update Sale",
            style: .primary
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )
    
    private func makeCartItemsRow() -> [FormRow] {

        var rows: [FormRow] = []

        for (index, product) in state.selectedProducts.enumerated() {

            let currency = countryHelper.currencyString(for: AppStorage.selectedRegionCode ?? "")
            let productId = product.id ?? index

            let vm = CartItemViewModel(
                id: productId,
                title: product.name ?? "Unknown",
                subtitle: "Price: \(currency). \(Int(product.price ?? 0))",
                pricePerUnit: Decimal(product.price ?? 0),
                quantity: Int(state.quantities[productId] ?? 1), // UI expects Int

                onUpdate: { [weak self] updated in
                    guard let self else { return }

                    let qty = updated.quantity ?? 1
                    self.state.quantities[productId] = Double(qty)

                    self.refreshCartUI()
                },

                onDelete: { [weak self] item in
                    guard let self else { return }

                    self.state.selectedProducts.removeAll {
                        ($0.id ?? -1) == item.id
                    }

                    self.state.quantities[item.id] = nil

                    self.refreshCartUI()
                }
            )

            rows.append(
                CartItemFormRow(tag: 1000 + index, viewModel: vm)
            )
        }

        rows.append(SpacerFormRow(tag: -100))
        rows.append(addItemButtonRow)

        return rows
    }
    
    private lazy var addItemButtonRow = ButtonFormRow(
        tag: CellTag.addItemButton.rawValue,
        model: ButtonFormModel(
            title: "Add Another Item",
            style: .outlined
        ) { [weak self] in
            self?.handleProductSelection()
        }
    )

    // MARK: - Actions
    private func handleProductSelection() {
        goToProductSelection(.products(page: 0, count: 100)) { [weak self] selected in
            guard let self, let value = selected else { return }

            self.state.selectedProducts.append(value)

            self.refreshCartUI()
        }
    }
    
    private func handleCustomerSelection() {
        goToCommonSelectionOptions(.customers(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.customer = value
            self.customerRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.customerRow.tag)
        }
    }

    private func handlePaymentsSelection() {
        goToCommonSelectionOptions(.paymentOptions(page: 0, count: 10), nil) { [weak self] value in
            guard let self else { return }

            self.state.paymentMethod = value
            self.paymentOptionsRow.config.placeholder = value?.name ?? ""
            self.reloadRow(withTag: self.paymentOptionsRow.tag)
        }
    }

    private func handleDateSelection() {
        dateRow.config.placeholder = state.dateString
        reloadRow(withTag: CellTag.date.rawValue)
    }

    // MARK: - Submit
    private func submit() async {
        let success = await performNetworkRequest()

        if success {
            gotoConfirm?()
            goToShowSuccessScreen?()
        }
    }

    private func performNetworkRequest() async -> Bool {
        showLoader()

        let payload = buildPayload()

        do {
            // Call the update sales API here
//            _ = try await bookKeepingService.updateSales(
//                id: state.sale.id,
//                parameters: payload,
//                accessToken: state.oauthToken
//            )

            hideLoader()
            return true

        } catch {
            hideLoader()
            print("❌ UPDATE SALES ERROR:", error)
            return false
        }
    }

    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
    // MARK: - Payload Construction
    private func buildPayload() -> [String: Any] {
        let items = state.selectedProducts.map {
            [
                "productId": $0.id ?? 0,
                "quantity": state.quantities[$0.id ?? -1] ?? 1
            ]
        }

        return [
            "saleTypeId": state.saleTypeId,
            "customerId": state.customer?.id ?? 0,
            "paymentMethodId": state.paymentMethod?.id ?? 0,
            "description": state.description,
            "items": items,
            "amount": state.amount,
            "date": state.date?.toISO8601String() ?? ""
        ]
    }

    // MARK: - State
    private struct State {
        var sale: SalesResponse
        var selectedProducts: [StockResponse] = []
        var quantities: [Int: Double] = [:]
        var saleTypes: [CommonIdNameModel] = []
        var customer: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?
        
        var date: Date?
        var dateString: String = ""
        var description: String = ""
        var saleTypeId: Int = -1
        
        var amount: Double {
            selectedProducts.reduce(0) { total, product in
                let qty = quantities[product.id ?? -1] ?? 1
                return total + ((product.price ?? 0) * qty)
            }
        }
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    // MARK: - Tags
    private enum SectionTag: Int {
        case segmentControl = 0
        case salesDetails = 1
        case productDetails = 2
        case description = 3
        case summary = 4
        case submit = 5
    }

    private enum CellTag: Int {
        case date = 5
        case customerName = 8
        case paymentMethod = 6
        case continueButton = 10
        case description = 11
        case addItemButton
    }
}
