//
//  AddBookKeepingSuppliesViewModel.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class AddBookKeepingSuppliesViewModel: FormViewModel {
    
    var gotoConfirm: (() -> Void)?

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
                    supplierNameInputRow,
                    phoneNumberInputRow,
                    emailAddressInputRow,
                    countryInputRow,
                    townInputRow,
                    streetAddressInputRow,

                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows

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

    private lazy var countryInputRow = makeInputRow(
        tag: CellTag.country.rawValue,
        title: "Country",
        placeholder: "Country",
        keyboard: .default
    )

    private lazy var townInputRow = makeInputRow(
        tag: CellTag.town.rawValue,
        title: "Town",
        placeholder: "Town",
        keyboard: .default
    )

    private lazy var streetAddressInputRow = makeInputRow(
        tag: CellTag.streetAddress.rawValue,
        title: "Street Address",
        placeholder: "Street Address",
        keyboard: .default
    )

    // MARK: - Row Builder

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

                    case CellTag.country.rawValue:
                        self.state.country = newText

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

    // MARK: - Button

    private lazy var continueButtonRow = ButtonFormRow(
        tag: CellTag.continueButton.rawValue,
        model: ButtonFormModel(
            title: "Add Supplier",
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

    }

    // MARK: - State
    private struct State {

        var supplierName: String = ""
        var phoneNumber: String = ""
        var emailAddress: String = ""
        var country: String = ""
        var town: String = ""
        var streetAddress: String = ""

        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""

        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?
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
    }
}
