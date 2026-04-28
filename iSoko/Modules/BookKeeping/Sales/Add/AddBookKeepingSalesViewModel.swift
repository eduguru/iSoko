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

    // MARK: - State

    private var state = State()

    // MARK: - Init

    override init() {
        super.init()
        sections = makeSections()
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

    // MARK: - Product Section Reload (🔥 KEY PART)

    private func reloadProductSection(animated: Bool = true) {
        guard let index = sections.firstIndex(where: {
            $0.id == SectionTag.productDetails.rawValue
        }) else { return }

        sections[index].cells = makeCartItemsRow()

        reloadSection(index)
    }

    // MARK: - Rows

    private lazy var pillsOptions = makePillsOptionsFormRow()
    private lazy var summaryRows = makeSummaryRows()
    
    
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
            placeholder: "Date",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                guard let self else { return }

                self.goToDateSelection(.year()) { date in
                    guard let date else { return }

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
            onTap: { [weak self] in self?.handlePaymentsSelection() }
        )
    )

    private lazy var addItemButtonRow = ButtonFormRow(
        tag: CellTag.addItemButton.rawValue,
        model: ButtonFormModel(
            title: "Add Another Item",
            style: .outlined
        ) { [weak self] in
            self?.handleProductSelection()
        }
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )

    private lazy var descriptionRow = LongInputDescriptionFormRow(
        tag: CellTag.description.rawValue,
        model: LongInputDescriptionModel(
            text: "",
            config: TextViewConfig(fixedHeight: 120),
            validation: ValidationConfiguration(isRequired: true),
            titleText: ""
        )
    )

    // MARK: - Dynamic Cart Rows
    private func makeCartItemsRow() -> [FormRow] {

        var rows: [FormRow] = []

        for (index, product) in state.selectedProducts.enumerated() {

            let vm = CartItemViewModel(
                id: product.id ?? index,
                title: product.name ?? "Unknown",
                subtitle: "Price: Ksh. \(Int(product.price ?? 0))",
                pricePerUnit: Decimal(product.price ?? 0),
                quantity: 1,

                onUpdate: { [weak self] _ in
                    // update totals / summary if needed
                    // self?.recalculateTotals()
                },

                onDelete: { [weak self] item in
                    guard let self else { return }

                    self.state.selectedProducts.removeAll {
                        ($0.id ?? -1) == item.id
                    }

                    self.reloadProductSection()
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

    private func makeSummaryRows() -> [FormRow] {
        [
            KeyValueFormRow(tag: 1, model: .init(leftText: "Subtotal", rightText: "$0")),
            KeyValueFormRow(tag: 2, model: .init(leftText: "Tax", rightText: "$0")),
            KeyValueFormRow(tag: 3, model: .init(leftText: "Total", rightText: "$0", isEmphasized: true))
        ]
    }

    // MARK: - Actions

    private func handleProductSelection() {
        goToProductSelection(.products(page: 0, count: 100)) { [weak self] selected in
            guard let self, let value = selected else { return }

            self.state.selectedProducts.append(value)

            // 🔥 THIS IS THE FIX
            self.reloadProductSection()
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

    // MARK: - Helpers

    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    private static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // MARK: - Submit

    private func submit() async {
        goToShowSuccessScreen?()
    }

    // MARK: - State

    private struct State {
        var selectedProducts: [StockResponse] = []
        var customer: CommonIdNameModel?
        var paymentMethod: CommonIdNameModel?
        var date: Date?
        var dateString: String = ""
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
        case addItemButton = 9
        case continueButton = 10
        case description = 11
    }
}
