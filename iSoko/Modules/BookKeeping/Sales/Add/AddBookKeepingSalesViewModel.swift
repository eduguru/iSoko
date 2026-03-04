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
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    var selectFoundedYear: ((_ completion: @escaping (Int?) -> Void) -> Void)?
    var gotoSelectLocation: ((_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void)?
    var gotoConfirm: (() -> Void)?

    var showCountryPicker: ((@escaping (Country) -> Void) -> Void)?
    private let countryHelper = CountryHelper()

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
    
    private func makeSegmentSection() -> FormSection {
        FormSection(
            id: SectionTag.segmentControl.rawValue,
            cells: [
                segmentedOptions
            ]
        )
    }
    
    private func makeSalesSection() -> FormSection {
        FormSection(
            id: SectionTag.salesDetails.rawValue,
            title: "Sales Details",
            cells: [
                dateRow,
                customerNameInputRow,
                paymentMethodDropdownRow
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
            cells: [
                SpacerFormRow(tag: 20)
            ]
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
    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private lazy var customerNameInputRow = makeInputRow(
        tag: CellTag.customerName.rawValue,
        title: "Customer Name",
        placeholder: "Enter Customer Name"
    )
    
    private lazy var dateRow = DropdownFormRow(
        tag: CellTag.date.rawValue,
        config: DropdownFormConfig(
            title: "Date",
            placeholder: "\(state.foundedYear ?? 0000)",
            rightImage: UIImage(systemName: "calendar"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleYearSelection()
            }
        )
    )
    
    private lazy var paymentMethodDropdownRow = DropdownFormRow(
        tag: CellTag.paymentMethod.rawValue,
        config: DropdownFormConfig(
            title: "Payment Method",
            placeholder: state.paymentMethod?.name ?? "Select location",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handlePaymentMethodSelection()
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
    
    // MARK: - Segmented Control
    private func makeOptionsSegmentFormRow() -> FormRow {
        SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["Cash Sales", "Credit Sales"],
                selectedIndex: state.selectedSegmentIndex,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] index in
                    guard let self else { return }
                    self.state.selectedSegmentIndex = index
                    self.reloadBodySection(animated: true)
                }
            )
        )
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

    // MARK: - handle selections
    
    private func handlePaymentMethodSelection() {
        gotoSelectLocation? { [weak self] value in
            guard let self, let value else { return }

            self.state.paymentMethod = value
            self.paymentMethodDropdownRow.config.placeholder = value.name
            self.reloadRow(withTag: self.paymentMethodDropdownRow.tag)
        }
    }
    
    private func handleYearSelection() {
        selectFoundedYear? { [weak self] value in
            guard let self, let value else { return }
            state.foundedYear = value
            dateRow.config.placeholder = "\(value)"
            reloadRow(withTag: dateRow.tag)
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


