//
//  AddBookKeepingCustomersViewModel.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class AddBookKeepingCustomersViewModel: FormViewModel {

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

    private lazy var countryInputRow = makeInputRow(
        tag: Tags.Cells.country.rawValue,
        title: "Country",
        placeholder: "Country",
        keyboard: .default
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

                    case Tags.Cells.country.rawValue:
                        state.country = newText

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

    // MARK: - Submit

    private func submit() async {
        // TODO: API submission
    }

    // MARK: - State

    private struct State {
        var customerName: String = ""
        var phoneNumber: String = ""
        var emailAddress: String = ""
        var country: String = ""
        var town: String = ""
        var streetAddress: String = ""
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
