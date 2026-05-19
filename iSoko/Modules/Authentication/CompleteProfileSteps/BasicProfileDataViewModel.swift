//
//  BasicProfileDataViewModel.swift
//
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit
import StorageKit
import UtilsKit

@MainActor
final class BasicProfileDataViewModel: FormViewModel {

    // MARK: - Callbacks
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }

    var gotoSelectLocation: (CommonUtilityOption, _ completion: @escaping (LocationModel?) -> Void) -> Void = { _, _ in }
    var gotoSelectCountry: (CommonUtilityOption, _ completion: @escaping (CountryResponse?) -> Void) -> Void = { _, _ in }
    
    var gotoConfirm: ((_ builder: RegistrationBuilder) -> Void)? = { _ in }
    var showCountryPicker: ((_ completion: @escaping (Country) -> Void) -> Void)?
    
    private var state: State?
    
    let countryHelper = CountryHelper()
    let authenticationService = NetworkEnvironment.shared.authenticationService

    // MARK: - Init
    init(builder: RegistrationBuilder) {
        self.state = State(registrationBuilder: builder)
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Form Construction
    private func makeSections() -> [FormSection] {
        guard let state = state else { return [] }

        var cells: [FormRow] = [
            makeHeaderTitleRow(),
            firstNameInputRow,
            lastNameInputRow,
            selectGenderRow,
            selectAgeRangeRow,
            selectRoleRow,
            selectCountryRow,
            selectLocationRow
            
        ]

        if let referralCode = state.referralCode, !referralCode.isEmpty {
            cells.append(referralCodeInputRow)
        }

        // Conditionally add email or phone
        if state.registrationBuilder.email == nil {
            cells.append(emailInputRow)
        } else if state.phoneNumber == nil {
            cells.append(phoneDropDownRow)
        }

        cells.append(SpacerFormRow(tag: 1001))
        cells.append(continueButtonRow)

        return [
            FormSection(
                id: Tags.Section.main.rawValue,
                title: nil,
                cells: cells
            )
        ]
    }

    // MARK: - Header
    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.title.rawValue,
            model: TitleDescriptionModel(
                title: "Create Your Profile",
                description: "Complete your details to continue",
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .none,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .title,
                descriptionFontStyle: .headline
            )
        )
    }

    // MARK: - Input Rows
    lazy var firstNameInputRow = makeFirstNameInputRow()
    lazy var lastNameInputRow = makeLastNameInputRow()
    lazy var referralCodeInputRow = makeReferralInputRow()
    lazy var selectAgeRangeRow = makeAgeRangeRow()
    lazy var selectRoleRow = makeRoleRow()
    lazy var selectLocationRow = makeLocationRow()
    lazy var selectCountryRow = makeCountryRow() // <-- New
    lazy var selectGenderRow = makeGenderRow()
    lazy var continueButtonRow = makeContinueButtonRow()

    lazy var emailInputRow: SimpleInputFormRow = {
        let model = SimpleInputModel(
            text: state?.email ?? "",
            config: TextFieldConfig(
                placeholder: "Email Address",
                keyboardType: .emailAddress
            ),
            validation: ValidationConfiguration(isRequired: true, minLength: 3, maxLength: 50),
            titleText: nil,
            useCardStyle: true,
            onTextChanged: { [weak self] newText in
                guard let self = self else { return }
                self.state?.email = newText
                self.state?.registrationBuilder.email = newText
            }
        )
        return SimpleInputFormRow(tag: Tags.Cells.emailInput.rawValue, model: model)
    }()

    lazy var phoneDropDownRow: PhoneDropDownFormRow = { [weak self] in
        guard let self = self else { fatalError("Self is nil") }
        let iso = AppStorage.selectedRegion?.capitalized ?? "KE"
        let selectedCountry: Country = countryHelper.country(forISO: iso)
            ?? countryHelper.defaultCountry
            ?? Country(id: "KE", name: "Kenya", phoneCode: "+254", continentCode: "AF")

        return PhoneDropDownFormRow(
            tag: Tags.Cells.phoneDropDown.rawValue,
            model: PhoneDropDownModel(
                phoneNumber: self.state?.phoneNumber ?? "",
                selectedCountry: selectedCountry,
                placeholder: "Enter phone number",
                titleText: nil,
                validation: ValidationConfiguration(
                    isRequired: true,
                    minLength: 5,
                    maxLength: 15
                ),
                onPhoneChanged: { [weak self] new in
                    guard let self = self else { return }
                    
                    self.state?.phoneNumber = "\(selectedCountry.phoneCode)\(new)"
                    self.state?.registrationBuilder.phoneNumber = self.state?.phoneNumber ?? new
                },
                onCountryTapped: { [weak self] in
                    self?.showCountryPicker? { selectedCountry in
                        self?.updatePhoneCountry(selectedCountry)
                    }
                }
            )
        )
    }()

    private func updatePhoneCountry(_ newCountry: Country) {
        var model = phoneDropDownRow.model
        model.selectedCountry = newCountry
        phoneDropDownRow.model = model
        reloadRowWithTag(phoneDropDownRow.tag)
    }

    // MARK: - Row Factories
    private func makeFirstNameInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.firstName.rawValue,
            model: SimpleInputModel(
                text: state?.firstName ?? "",
                config: TextFieldConfig(placeholder: "First name *", keyboardType: .default),
                validation: ValidationConfiguration(isRequired: true, minLength: 2, maxLength: 50),
                titleText: "First name *",
                useCardStyle: true,
                onTextChanged: { [weak self] text in
                    self?.state?.firstName = text
                    self?.state?.registrationBuilder.firstName = text
                }
            )
        )
    }

    private func makeLastNameInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.lastName.rawValue,
            model: SimpleInputModel(
                text: state?.lastName ?? "",
                config: TextFieldConfig(placeholder: "Last name *", keyboardType: .default),
                validation: ValidationConfiguration(isRequired: true, minLength: 2, maxLength: 50),
                titleText: "Last name *",
                useCardStyle: true,
                onTextChanged: { [weak self] text in
                    self?.state?.lastName = text
                    self?.state?.registrationBuilder.lastName = text
                }
            )
        )
    }

    private func makeReferralInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.referralCode.rawValue,
            model: SimpleInputModel(
                text: state?.referralCode ?? "",
                config: TextFieldConfig(placeholder: "Referral Code", keyboardType: .default),
                titleText: "Referral Code",
                useCardStyle: true
            )
        )
    }

    private func makeGenderRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.gender.rawValue,
            config: DropdownFormConfig(
                title: "Select Gender",
                placeholder: state?.gender?.name ?? "Gender",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in self?.handleGenderSelection() }
            )
        )
    }

    private func makeAgeRangeRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.ageRange.rawValue,
            config: DropdownFormConfig(
                title: "Select Age Range",
                placeholder: state?.ageRange?.name ?? "Age Range",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in self?.handleAgeRangeSelection() }
            )
        )
    }

    private func makeRoleRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.roles.rawValue,
            config: DropdownFormConfig(
                title: "Select Role",
                placeholder: state?.roles?.name ?? "Role",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in self?.handleRoleSelection() }
            )
        )
    }

    private func makeLocationRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.location.rawValue,
            config: DropdownFormConfig(
                title: "Select Location",
                placeholder: state?.location?.name ?? "Location",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in self?.handleLocationSelection() }
            )
        )
    }

    private func makeCountryRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.country.rawValue,
            config: DropdownFormConfig(
                title: "Select Country",
                placeholder: state?.registrationBuilder.country?.name ?? "Country",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in self?.handleCountrySelection() }
            )
        )
    }

    private func makeContinueButtonRow() -> ButtonFormRow {
        ButtonFormRow(
            tag: Tags.Cells.submit.rawValue,
            model: ButtonFormModel(
                title: "Continue",
                style: .primary,
                size: .medium,
                icon: nil,
                fontStyle: .headline,
                hapticsEnabled: true
            ) { [weak self] in
                guard let builder = self?.mapToRegistrationBuilder() else { return }
                
                self?.gotoConfirm?(builder)
            }
        )
    }

    // MARK: - Selection Handlers
    private func handleGenderSelection() {
        goToCommonSelectionOptions(.userGender(page: 0, count: 10), nil) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.gender = value
            self.selectGenderRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }

    private func handleAgeRangeSelection() {
        goToCommonSelectionOptions(.ageGroups(page: 0, count: 100), nil) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.ageRange = value
            self.selectAgeRangeRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
        }
    }

    private func handleRoleSelection() {
        goToCommonSelectionOptions(.userRoles(page: 0, count: 100), nil) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.roles = value
            self.selectRoleRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectRoleRow.tag)
        }
    }

    private func handleLocationSelection() {
        gotoSelectLocation(.locations(page: 0, count: 100)) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.location = value
            self.selectLocationRow.config.placeholder = value.name ?? ""
            self.reloadRowWithTag(self.selectLocationRow.tag)
        }
    }

    private func handleCountrySelection() {
        gotoSelectCountry(.countries(page: 0, count: 100)) { [weak self] selectedCountry in
            guard let self = self, let selectedCountry = selectedCountry else { return }
            
            self.state?.registrationBuilder.country = IDNamePair(id: selectedCountry.id, name: selectedCountry.name)
            
            self.selectCountryRow.config.placeholder = selectedCountry.name ?? ""
            self.reloadRowWithTag(self.selectCountryRow.tag)
        }
    }

    // MARK: - Helpers
    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    func mapToRegistrationBuilder() -> RegistrationBuilder? {
        guard let state = state else { return nil }
        
        state.registrationBuilder.firstName = state.firstName
        state.registrationBuilder.lastName = state.lastName
        state.registrationBuilder.gender = state.gender?.toIDNamePairInt
        state.registrationBuilder.role = state.roles?.toIDNamePairInt
        state.registrationBuilder.ageGroup = state.ageRange?.toIDNamePairInt
        state.registrationBuilder.location = state.location?.toIDNamePairString
        state.registrationBuilder.referralCode = state.referralCode
        
        return state.registrationBuilder
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case main = 0
        }

        enum Cells: Int {
            case title = 0
            case firstName = 1
            case lastName = 2
            case gender = 3
            case ageRange = 4
            case roles = 5
            case location = 6
            case country = 11
            case referralCode = 7
            case submit = 8
            case emailInput = 9
            case phoneDropDown = 10
        }
    }

    // MARK: - State
    private struct State {
        var registrationBuilder: RegistrationBuilder
        var firstName: String?
        var lastName: String?
        var gender: CommonIdNameModel?
        var ageRange: CommonIdNameModel?
        var roles: CommonIdNameModel?
        var location: LocationModel?
        var referralCode: String?
        var email: String?
        var phoneNumber: String?
    }
}
