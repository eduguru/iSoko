//
//  AddBookKeepingCustomersViewModel.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class AddBookKeepingCustomersViewModel: FormViewModel {
    var gotoSelectSystemCountry: (CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) -> Void = { _, _ in }
    
    var gotoConfirm: (() -> Void)?
    var goToShowSuccessScreen: (() -> Void)?
    
    // MARK: - Services
    private let bookKeepingService = NetworkEnvironment.shared.bookKeepingService
    
    private var state = State()

    override init() {
        super.init()
        sections = makeSections()
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.header.rawValue,
                cells: [
                    customerNameInputRow,
                    phoneNumberInputRow,
                    emailAddressInputRow,
                    countryInputRow,
                    townInputRow,
                    streetAddressInputRow,

                    SpacerFormRow(tag: 20),
                    addCustomerButtonRow
                ]
            )
        ]
    }

    // MARK: - Lazy Rows

    private lazy var customerNameInputRow = makeInputRow(
        tag: Tags.Cells.customerName.rawValue,
        title: "Customer Name",
        placeholder: "Customer Name",
        keyboard: .default
    )

    private lazy var phoneNumberInputRow = makeInputRow(
        tag: Tags.Cells.phoneNumber.rawValue,
        title: "Phone Number",
        placeholder: "Phone Number",
        keyboard: .phonePad
    )

    private lazy var emailAddressInputRow = makeInputRow(
        tag: Tags.Cells.emailAddress.rawValue,
        title: "Email Address",
        placeholder: "Email Address",
        keyboard: .emailAddress
    )

    private lazy var countryInputRow = DropdownFormRow(
        tag: Tags.Cells.country.rawValue,
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

    private lazy var townInputRow = makeInputRow(
        tag: Tags.Cells.town.rawValue,
        title: "Town",
        placeholder: "Town",
        keyboard: .default
    )

    private lazy var streetAddressInputRow = makeInputRow(
        tag: Tags.Cells.streetAddress.rawValue,
        title: "Street Address",
        placeholder: "Street Address",
        keyboard: .default
    )

    private lazy var addCustomerButtonRow = ButtonFormRow(
        tag: Tags.Cells.addCustomerButton.rawValue,
        model: ButtonFormModel(
            title: "Add Customer",
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

                    case Tags.Cells.customerName.rawValue:
                        state.customerName = newText

                    case Tags.Cells.phoneNumber.rawValue:
                        state.phoneNumber = newText

                    case Tags.Cells.emailAddress.rawValue:
                        state.emailAddress = newText

                    case Tags.Cells.town.rawValue:
                        state.town = newText

                    case Tags.Cells.streetAddress.rawValue:
                        state.streetAddress = newText

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
    
    // MARK: handle selection
    private func handleCountrySelection() {
        gotoSelectSystemCountry(.countries(page: 0, count: 10)) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state.selectedCountry = value
            let dropdownFormRow: DropdownFormRow = countryInputRow
            
            dropdownFormRow.config.placeholder = value.name ?? ""
            self.reloadRow(withTag: dropdownFormRow.tag)
        }
    }

    // MARK: - Submit
    private func submit() async {
        let success = await performNetworkRequest()
        
        if !success {
            print("❌ Failed to add customer")
            return
        }
        
        await MainActor.run { [weak self] in
            self?.gotoConfirm?()
        }
    }
    
    // MARK: - Network
    @discardableResult
    private func performNetworkRequest() async -> Bool {
        guard !state.customerName.isEmpty else {
            print("❌ Customer name required")
            return false
        }

        guard let country = state.selectedCountry else {
            print("❌ No country selected")
            return false
        }

        showLoader()
        
        let payload: [String : Any] = [
            "name": state.customerName,
            "phoneNumber": state.phoneNumber,
            "email": state.emailAddress,
            "countryId": country.id,
            "town": state.town,
            "streetAddress": state.streetAddress
        ]

        print("📦 Payload:", payload)

        do {
            _ = try await bookKeepingService.addCustomer(
                parameters: payload,
                accessToken: state.oauthToken
            )
            
            goToShowSuccessScreen?()
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
        var customerName: String = ""
        var phoneNumber: String = ""
        var emailAddress: String = ""

        var selectedCountry: CountryResponse?
        
        var town: String = ""
        var streetAddress: String = ""
        
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
    }

    // MARK: - Tags

    enum Tags {

        enum Section: Int {
            case header = 0
        }

        enum Cells: Int {
            case customerName = 0
            case phoneNumber = 1
            case emailAddress = 2
            case country = 3
            case town = 4
            case streetAddress = 5
            case addCustomerButton = 6
        }
    }
}
