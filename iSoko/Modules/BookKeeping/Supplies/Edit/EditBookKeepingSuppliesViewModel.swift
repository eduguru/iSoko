//
//  EditBookKeepingSuppliesViewModel.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class EditBookKeepingSuppliesViewModel: FormViewModel {
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void)
    -> Void = { _, _, _ in }
    
    var gotoSelectSystemCountry: (CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) -> Void = { _, _ in }

    var gotoConfirm: (() -> Void)?
    var goToShowSuccessScreen: (() -> Void)?
    var goToAddCategory: (() -> Void)? = { }
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    // MARK: - State
    private var state: State
    
    // MARK: - Init
    init(supplier: SupplierResponse) {
        self.state = State(supplier: supplier)
        super.init()
        sections = makeSections()
        prefill()
    }
    
    // MARK: - Prefill (ONLY REAL DIFFERENCE)
    private func prefill() {
        
        supplierNameInputRow.model.text = state.supplierName
        phoneNumberInputRow.model.text = state.phoneNumber
        emailAddressInputRow.model.text = state.emailAddress
        townInputRow.model.text = state.town
        streetAddressInputRow.model.text = state.streetAddress
        
        if let country = state.selectedCountry {
            countryInputRow.config.placeholder = country.name ?? ""
        }
        
        if let category = state.selectedCategory {
            categoryRow.config.placeholder = category.name ?? ""
        }
    }

    // MARK: - Section Builder 
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: SectionTag.main.rawValue,
                cells: [
                    titleFormRow,
                    SpacerFormRow(tag: 10, height: 16),
                    supplierNameInputRow,
                    phoneNumberInputRow,
                    emailAddressInputRow,
                    townInputRow,
                    streetAddressInputRow,
                    countryInputRow,
                    categoryRow,

                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows (UNCHANGED EXACTLY)

    private lazy var supplierNameInputRow = makeInputRow(
        tag: CellTag.supplierName.rawValue,
        title: "Supplier Name",
        placeholder: "Supplier Name",
        keyboard: .default
    )

    private lazy var phoneNumberInputRow = makeInputRow(
        tag: CellTag.phoneNumber.rawValue,
        title: "Phone Number",
        placeholder: "Phone Number",
        keyboard: .phonePad
    )

    private lazy var emailAddressInputRow = makeInputRow(
        tag: CellTag.emailAddress.rawValue,
        title: "Email Address",
        placeholder: "Email Address",
        keyboard: .emailAddress
    )

    private lazy var townInputRow = makeInputRow(
        tag: CellTag.town.rawValue,
        title: "City/Town",
        placeholder: "City/Town (optional)",
        keyboard: .default
    )

    private lazy var streetAddressInputRow = makeInputRow(
        tag: CellTag.streetAddress.rawValue,
        title: "Physical Address",
        placeholder: "Physical Address (optional)",
        keyboard: .default
    )
    
    private lazy var countryInputRow = DropdownFormRow(
        tag: CellTag.country.rawValue,
        config: DropdownFormConfig(
            title: "Country",
            placeholder: "Country",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleCountrySelection()
            }
        )
    )
    
    private lazy var categoryRow = DropdownFormRow(
        tag: CellTag.categoryRow.rawValue,
        config: DropdownFormConfig(
            title: "Category",
            placeholder: "Select an option",
            rightImage: UIImage(systemName: "chevron.down"),
            onTap: { [weak self] in
                self?.handleSpplierCategorySelection()
            },
            onActionTap: { [weak self] in
                self?.goToAddCategory?()
            },
            actionImage: UIImage(systemName: "plus.square"),
            showsActionButton: true
        )
    )
    
    private lazy var titleFormRow: FormRow = makeTitleRow(
        title: "Edit Supplier",
        description: "Update Details Below"
    )
    
    private func makeTitleRow(title: String, description: String) -> FormRow {
        TitleDescriptionFormRow(
            tag: UUID().hashValue,
            model: TitleDescriptionModel(
                title: title,
                description: description,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .headline,
                descriptionFontStyle: .subheadline
            )
        )
    }

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Update Supplier",
            style: .primary,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            Task { await self?.submit() }
        }
    )

    // MARK: - Input Builder 
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
                validation: ValidationConfiguration(isRequired: false),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }

                    switch tag {

                    case CellTag.supplierName.rawValue:
                        self.state.supplierName = newText

                    case CellTag.phoneNumber.rawValue:
                        self.state.phoneNumber = newText

                    case CellTag.emailAddress.rawValue:
                        self.state.emailAddress = newText

                    case CellTag.town.rawValue:
                        self.state.town = newText

                    case CellTag.streetAddress.rawValue:
                        self.state.streetAddress = newText

                    default:
                        break
                    }
                }
            )
        )
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

    // MARK: - Selection Handlers (UNCHANGED LOGIC)

    private func handleSpplierCategorySelection() {
        goToCommonSelectionOptions(.supplierCategory(page: 0, count: 10), nil) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state.selectedCategory = value
            
            self.categoryRow.config.placeholder = value.name ?? ""
            self.reloadRow(withTag: self.categoryRow.tag)
        }
    }
    
    private func handleCountrySelection() {
        gotoSelectSystemCountry(.countries(page: 0, count: 10)) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state.selectedCountry = value
            
            self.countryInputRow.config.placeholder = value.name ?? ""
            self.reloadRow(withTag: self.countryInputRow.tag)
        }
    }

    // MARK: - Submit (ONLY API CHANGE)
    private func submit() async {
        let success = await performNetworkRequest()

        if success {
            DispatchQueue.main.async { [weak self] in
                self?.gotoConfirm?()
            }
        }
    }

    // MARK: - Network (SWAPPED ONLY)
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        guard let country = state.selectedCountry else {
            print("❌ No country selected")
            return false
        }

        guard let category = state.selectedCategory else {
            print("❌ No category selected")
            return false
        }

        showLoader()

        let payload: [String: Any] = [
            "id": state.supplier.id,
            "name": state.supplierName,
            "phoneNumber": state.phoneNumber,
            "email": state.emailAddress,
            "countryId": country.id,
            "categoryId": category.id,
            "town": state.town,
            "streetAddress": state.streetAddress
        ]

        do {
//            _ = try await bookKeepingService.updateSupplier(
//                parameters: payload,
//                accessToken: state.oauthToken
//            )

            hideLoader()
            goToShowSuccessScreen?()
            return true

        } catch {
            hideLoader()
            print("❌ Error:", error)
            return false
        }
    }

    // MARK: - State (EXTENDED ONLY)
    private struct State {
        let supplier: SupplierResponse
        
        var supplierName: String
        var phoneNumber: String
        var emailAddress: String
        var town: String
        var streetAddress: String
        
        var selectedCountry: CountryResponse?
        var selectedCategory: CommonIdNameModel?

        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""

        init(supplier: SupplierResponse) {
            self.supplier = supplier
            
            self.supplierName = supplier.name ?? ""
            self.phoneNumber = supplier.phoneNumber ?? ""
            self.emailAddress = supplier.email ?? ""
            self.town = supplier.town ?? ""
            self.streetAddress = supplier.streetAddress ?? ""

            self.selectedCountry = CountryResponse( from: supplier.country)
            self.selectedCategory = CommonIdNameModel(from: supplier.category) ?? CommonIdNameModel(id: -1, name: "Unknown", description: nil)
            
        }
    }

    // MARK: - Tags 
    private enum SectionTag: Int {
        case main = 0
    }

    private enum CellTag: Int {
        case continueButton = 0
        case supplierName = 1
        case phoneNumber = 2
        case emailAddress = 3
        case country = 4
        case town = 5
        case streetAddress = 6
        case categoryRow = 7
    }
}
