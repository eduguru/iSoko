//
//  BasicProfileDataViewModel.swift
//
//
//  Created by Edwin Weru on 22/09/2025.
//

import DesignSystemKit
import UIKit

final class BasicProfileDataViewModel: FormViewModel {
    var gotoSelectGender: (_ options: [CommonIdNameModel], _ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _, _ in }
    var gotoSelectAgeRange: (_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _ in }
    var gotoSelectRole: (_ completion: @escaping (CommonIdNameModel?) -> Void) -> Void = { _ in }
    var gotoSelectLocation: (_ completion: @escaping (LocationModel?) -> Void) -> Void = { _ in }
    
    var gotoConfirm: (() -> Void)? = { }
    
    private var state: State?
    
    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }
    
    // MARK: -  make sections
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(makeHeaderSection())
        sections.append(makeNamesSection())
        // sections.append(makeGenderSection())
        sections.append(makeRolesSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [ makeHeaderTitleRow()]
        )
    }
    
    private func makeNamesSection() -> FormSection {
        FormSection(
            id: Tags.Section.names.rawValue,
            title: "Full name",
            cells: [ firstNameInputRow, lastNameInputRow]
        )
    }
    
    private func makeGenderSection() -> FormSection {
        FormSection(
            id: Tags.Section.gender.rawValue,
            title: "Gender",
            cells: makeGenderSelectionCells()
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
    
    // MARK: - make rows
    private lazy var selectAgeRangeRow = makeAgeRangeRow()
    private lazy var selectRoleRow = makeRoleRow()
    private lazy var selectLocationRow = makeLocationRow()
    private lazy var selectGenderRow = makeGenderRow()
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: -101,
            title: "Tell us about yourself",
            description: "",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
        
        return row
    }
    
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
            self?.gotoConfirm?()
        }
    )
    
    private func makeGenderSelectionCells() -> [FormRow] {
        return state?.genderOptions.map { makeGenderOptionRow(for: $0) } ?? []
    }
    
    private func reloadGenderSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.gender.rawValue }) else { return }
        sections[sectionIndex].cells = makeGenderSelectionCells()
        reloadSection(sectionIndex)
    }

    private func makeGenderOptionRow(for option: CommonIdNameModel) -> SelectableRow {
        let isSelected = state?.gender?.id == option.id
        return SelectableRow(
            tag: option.id,
            config: SelectableRowConfig(
                title: option.name,
                description: nil,
                isSelected: isSelected,
                selectionStyle: .radio,
                isAccessoryVisible: false,
                isCardStyleEnabled: false,
                onToggle: { [weak self] selected in
                    guard let self = self, selected else { return }
                    self.state?.gender = option
                    self.reloadGenderSection()
                }
            )
        )
    }

    lazy var firstNameInputRow = SimpleInputFormRow(
        tag: Tags.Cells.firstName.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "First name *",
                keyboardType: .default,
                accessoryImage: nil
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 3,
                maxLength: 50,
                errorMessageRequired: "Email is required",
                errorMessageLength: "Must be 5–50 characters"
            ),
            titleText: "First name *",
            useCardStyle: true
        )
    
    )
    
    lazy var lastNameInputRow = SimpleInputFormRow(
        tag: Tags.Cells.lastName.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Last name *",
                keyboardType: .default,
                accessoryImage: nil
            ),
            validation: ValidationConfiguration(
                isRequired: true,
                minLength: 3,
                maxLength: 50,
                errorMessageRequired: "Email is required",
                errorMessageLength: "Must be 5–50 characters"
            ),
            titleText: "Last name *",
            useCardStyle: true
        )
    
    )
    
    lazy var referralCodeInputRow = SimpleInputFormRow(
        tag: Tags.Cells.referralCode.rawValue,
        model: SimpleInputModel(
            text: "",
            config: TextFieldConfig(
                placeholder: "Referral Code",
                keyboardType: .default,
                accessoryImage: nil
            ),
            validation: nil,
            titleText: "Referral Code",
            useCardStyle: true
        )
    
    )

    // MARK: - make selection rows -
    
    private func makeAgeRangeRow() -> DropdownFormRow {
        DropdownFormRow(
            tag: Tags.Cells.ageRange.rawValue,
            config: DropdownFormConfig(
                title: "Select Age Range",
                placeholder: state?.ageRange?.name ?? "Age Range",
                leftImage: nil,
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
                leftImage: nil,
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
                leftImage: nil,
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
                leftImage: nil,
                rightImage: UIImage(systemName: "chevron.down"),
                isCardStyleEnabled: true,
                onTap: { [weak self] in
                    self?.handleLocationSelection()
                }
            )
        )
    }

    // MARK: - handle selection rows -
    
    private func handleGenderSelection() {
        gotoSelectGender(state?.genderOptions ?? []) { [weak self] selectedValue in
            guard let self = self, let value = selectedValue else { return }

            self.state?.gender = value
            self.selectGenderRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }
    
    private func handleAgeRangeSelection() {
        gotoSelectAgeRange { [weak self] selectedValue in
            guard let self = self, let value = selectedValue else { return }

            self.state?.ageRange = value
            self.selectAgeRangeRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
        }
    }
    
    private func handleRoleSelection() {
        gotoSelectRole { [weak self] selectedValue in
            guard let self = self, let value = selectedValue else { return }

            self.state?.roles = value
            self.selectRoleRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectRoleRow.tag)
        }
    }
    
    private func handleLocationSelection() {
        gotoSelectLocation { [weak self] selectedValue in
            guard let self = self, let value = selectedValue else { return }

            self.state?.location = value
            self.selectLocationRow.config.placeholder = value.name ?? ""
            self.reloadRowWithTag(self.selectLocationRow.tag)
        }
    }

    // MARK: - Helpers

    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                onReloadRow?(indexPath)
                break
            }
        }
    }
    
    
    // MARK: - selection
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        default:
            break
        }
    }
    
    private struct State {
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
    }

    
    enum Tags {
        enum Section: Int {
            case header = 0
            case names = 1
            case gender = 2
            case roles = 3
        }
        
        enum Cells: Int {
            case title = 0
            case firstName = 1
            case lastName = 2
            case gender = 3
            case male = 4
            case female = 5
            case ageRange = 6
            case roles = 7
            case location = 8
            case referralCode = 9
            case submit = 10
        }
    }
}
