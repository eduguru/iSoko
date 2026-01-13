//
//  BasicProfileDataViewModel.swift
//
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit

final class BasicProfileDataViewModel: FormViewModel {
    // var gotoSelectGender: (_ options: [CommonIdNameModel], _ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _, _ in }
    var gotoSelectGender: ( _ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _ in }
    var gotoSelectAgeRange: (_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _ in }
    var gotoSelectRole: (_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _ in }
    var gotoSelectLocation: (_ completion: @escaping (LocationModel?) -> Void) -> Void = { _ in }

    var gotoSelectOrgType: (_ completion: @escaping (OrganisationTypeModel?) -> Void) -> Void = { _ in }
    var gotoSelectOrgSize: (_ completion: @escaping (OrganisationSizeModel?) -> Void) -> Void = { _ in }

    var gotoConfirm: ((_ builder: RegistrationBuilder) -> Void)? = { _ in }

    private var state: State?

    // MARK: - Init
    init(builder: RegistrationBuilder, registrationType: RegistrationType) {
        self.state = State(registrationType: registrationType, builder: builder)
        super.init()
        self.sections = makeSections()
    }

    func switchRegistrationType(to newType: RegistrationType) {
        state?.registrationType = newType
        sections = makeSections()
        onReloadData?()
    }

    // MARK: - Form Construction
    private func makeSections() -> [FormSection] {
        guard let state = state else { return [] }

        var sections: [FormSection] = []
        sections.append(makeHeaderSection())

        switch state.registrationType {
        case .individual:
            sections.append(makeNamesSection())
            sections.append(makeRolesSection())
        case .organisation:
            sections.append(makeOrgFieldsSection())
        }

        return sections
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [makeHeaderTitleRow()]
        )
    }

    private func makeNamesSection() -> FormSection {
        FormSection(
            id: Tags.Section.names.rawValue,
            title: "Full name",
            cells: [firstNameInputRow, lastNameInputRow]
        )
    }

    private func makeRolesSection() -> FormSection {
        FormSection(
            id: Tags.Section.roles.rawValue,
            title: nil,
            cells: [
                selectGenderRow,
                selectAgeRangeRow,
                selectRoleRow,
                selectLocationRow,
                referralCodeInputRow,
                SpacerFormRow(tag: 1001),
                continueButtonRow
            ]
        )
    }

    private func makeOrgFieldsSection() -> FormSection {
        FormSection(
            id: Tags.Section.org.rawValue,
            title: "Organization Details",
            cells: [
                orgNameInputRow,
                orgTypeDropdownRow,
                orgSizeDropdownRow,
                selectRoleRow,
                selectLocationRow,
                SpacerFormRow(tag: 1002),
                continueButtonRow
            ]
        )
    }

    // MARK: - Header
    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: Tags.Cells.title.rawValue,
            title: state?.registrationType.title ?? "",
            description: state?.registrationType.subtitle ?? "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
    }

    // MARK: - Input Rows
    lazy var selectAgeRangeRow = makeAgeRangeRow()
    lazy var selectRoleRow = makeRoleRow()
    lazy var selectLocationRow = makeLocationRow()
    lazy var selectGenderRow = makeGenderRow()

    lazy var firstNameInputRow = makeFirstNameInputRow()
    lazy var lastNameInputRow = makeLastNameInputRow()
    lazy var referralCodeInputRow = makeReferralInputRow()

    lazy var orgNameInputRow = makeOrgNameRow()
    lazy var orgTypeDropdownRow = makeOrgTypeRow()
    lazy var orgSizeDropdownRow = makeOrgSizeRow()

    lazy var continueButtonRow = ButtonFormRow(
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

    // MARK: - Row Factories
    private func makeFirstNameInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.firstName.rawValue,
            model: SimpleInputModel(
                text: state?.firstName ?? "",
                config: TextFieldConfig(
                    placeholder: "First name *",
                    keyboardType: .default
                ),
                validation: ValidationConfiguration(
                    isRequired: true,
                    minLength: 2,
                    maxLength: 50
                ),
                titleText: "First name *",
                useCardStyle: true,
                onTextChanged: { [weak self] text in
                    guard let self else { return }
                    self.state?.firstName = text
                    self.state?.builder.firstName = text
                }
            )
        )
    }

    private func makeLastNameInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.lastName.rawValue,
            model: SimpleInputModel(
                text: state?.lastName ?? "",
                config: TextFieldConfig(
                    placeholder: "Last name *",
                    keyboardType: .default
                ),
                validation: ValidationConfiguration(
                    isRequired: true,
                    minLength: 2,
                    maxLength: 50
                ),
                titleText: "Last name *",
                useCardStyle: true,
                onTextChanged: { [weak self] text in
                    guard let self else { return }
                    self.state?.lastName = text
                    self.state?.builder.lastName = text
                }
            )
        )
    }

    private func makeReferralInputRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.referralCode.rawValue,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(placeholder: "Referral Code", keyboardType: .default),
                titleText: "Referral Code",
                useCardStyle: true
            )
        )
    }

    private func makeOrgNameRow() -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: Tags.Cells.orgName.rawValue,
            model: SimpleInputModel(
                text: "",
                config: TextFieldConfig(placeholder: "Organization name *", keyboardType: .default),
                validation: ValidationConfiguration(isRequired: true),
                titleText: "Organization name",
                useCardStyle: true
            )
        )
    }

    private func makeOrgTypeRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.orgType.rawValue,
            config: DropdownFormConfig(
                title: "Organization Type",
                placeholder: state?.orgType?.name ?? "Select type",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.gotoSelectOrgType { selected in
                        guard let self = self, let value = selected else { return }
                        self.state?.orgType = value
                        self.orgTypeDropdownRow.config.placeholder = value.name ?? "Org Type"
                        self.reloadRowWithTag(self.orgTypeDropdownRow.tag)
                    }
                }
            )
        )
    }

    private func makeOrgSizeRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.orgSize.rawValue,
            config: DropdownFormConfig(
                title: "Organization Size",
                placeholder: state?.orgSize?.name ?? "Select size",
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.gotoSelectOrgSize { selected in
                        guard let self = self, let value = selected else { return }
                        self.state?.orgSize = value
                        self.orgSizeDropdownRow.config.placeholder = value.name ?? "Org Size"
                        self.reloadRowWithTag(self.orgSizeDropdownRow.tag)
                    }
                }
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
                onTap: { [weak self] in
                    self?.handleAgeRangeSelection()
                }
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
                onTap: { [weak self] in
                    self?.handleGenderSelection()
                }
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
                onTap: { [weak self] in
                    self?.handleRoleSelection()
                }
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
                onTap: { [weak self] in
                    self?.handleLocationSelection()
                }
            )
        )
    }

    // MARK: - Selection Handlers
    private func handleGenderSelection() {
        gotoSelectGender() { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.gender = value
            self.selectGenderRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }

    private func handleAgeRangeSelection() {
        gotoSelectAgeRange { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.ageRange = value
            self.selectAgeRangeRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
        }
    }

    private func handleRoleSelection() {
        gotoSelectRole { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.roles = value
            self.selectRoleRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectRoleRow.tag)
        }
    }

    private func handleLocationSelection() {
        gotoSelectLocation { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state?.location = value
            self.selectLocationRow.config.placeholder = value.name ?? ""
            
            self.reloadRowWithTag(self.selectLocationRow.tag)
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

    // MARK: - Mapping to RegistrationBuilder
    func mapToRegistrationBuilder() -> RegistrationBuilder? {
        guard let state = state else { return state?.builder }

        // Individual
        state.builder.firstName = state.firstName
        state.builder.lastName = state.lastName
        state.builder.gender = state.gender?.toIDNamePairInt
        state.builder.role = state.roles?.toIDNamePairInt
        state.builder.ageGroup = state.ageRange?.toIDNamePairInt
        state.builder.location = state.location?.toIDNamePairString
        state.builder.referralCode = state.referralCode

        // Organization
        state.builder.isOrganization = (state.registrationType == .organisation)
        state.builder.organizationName = state.orgName
        state.builder.organizationType = state.orgType?.toIDNamePairInt
        state.builder.organizationSize = state.orgSize?.toIDNamePairInt

        return state.builder
    }

    // MARK: - State
    private struct State {
        var registrationType: RegistrationType
        var builder: RegistrationBuilder

        // Individual
        var firstName: String?
        var lastName: String?
        var genderOptions: [CommonIdNameModel] = [
            CommonIdNameModel(id: 1, name: "Male"),
            CommonIdNameModel(id: 2, name: "Female")
        ]
        var gender: CommonIdNameModel?
        var ageRange: CommonIdNameModel?
        var roles: CommonIdNameModel?
        var location: LocationModel?
        var referralCode: String?

        // Organization
        var orgName: String?
        var orgType: OrganisationTypeModel?
        var orgSize: OrganisationSizeModel?
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case names = 1
            case gender = 2
            case roles = 3
            case org = 4
        }

        enum Cells: Int {
            case title = 0
            case firstName = 1
            case lastName = 2
            case gender = 3
            case ageRange = 4
            case roles = 5
            case location = 6
            case referralCode = 7
            case submit = 8
            case orgName = 9
            case orgType = 10
            case orgSize = 11
        }
    }
}
