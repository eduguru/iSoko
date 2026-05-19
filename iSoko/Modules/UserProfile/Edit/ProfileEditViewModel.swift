//
//  ProfileEditViewModel.swift
//  
//
//  Created by Edwin Weru on 11/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class ProfileEditViewModel: FormViewModel {
    
    // MARK: - Navigation / Callbacks
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void)
    -> Void = { _, _, _ in }
    
    var gotoConfirm: (() -> Void)? = { }
    
    // MARK: - State
    private var state: State

    // MARK: - Init
    init(userProfile: UserDetails? = AppStorage.userDetail) {
        self.state = State(userProfile: userProfile)
        super.init()
        self.sections = makeSections()
        configureInputHandlers()
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: [
                    imageRow,
                    firstNameInputRow,
                    emailInputRow,
                    phoneInputRow,
                    selectGenderRow,
                    selectAgeRangeRow,
                    SpacerFormRow(tag: 20),
                    continueButtonRow
                ]
            )
        ]
    }

    // MARK: - Rows
    
    private lazy var imageRow = EditableImageFormRow(
        tag: Tags.Cells.headerImage.rawValue,
        config: .init(
            image: UIImage(named: "user"),// state.userProfile?.profileImage ?? UIImage(named: "user"),
            height: 120,
            fillWidth: false,
            alignment: .left,
            editable: true,
            backgroundColor: .clear,
            cornerRadius: 60
        ),
        onEditTapped: { [weak self] in
            // self?.presentImagePicker()
        }
    )

    private lazy var firstNameInputRow = makeInputRow(
        tag: Tags.Cells.firstName.rawValue,
        title: "First Name",
        placeholder: "Enter First Name",
        initialText: state.firstName
    )

    private lazy var emailInputRow = makeInputRow(
        tag: Tags.Cells.email.rawValue,
        title: "Email Address",
        placeholder: "Enter Email Address",
        initialText: state.email
    )

    private lazy var phoneInputRow = makeInputRow(
        tag: Tags.Cells.phoneNumber.rawValue,
        title: "Phone Number",
        placeholder: "Enter Phone Number",
        initialText: state.phoneNumber
    )

    private func makeInputRow(tag: Int, title: String, placeholder: String, initialText: String?) -> SimpleInputFormRow {
        SimpleInputFormRow(
            tag: tag,
            model: SimpleInputModel(
                text: initialText ?? "",
                config: TextFieldConfig(placeholder: placeholder, keyboardType: .default),
                validation: ValidationConfiguration(isRequired: true, minLength: 3, maxLength: 50),
                titleText: title,
                useCardStyle: true,
                onTextChanged: { [weak self] newText in
                    guard let self else { return }
                    switch tag {
                    case Tags.Cells.firstName.rawValue: self.state.firstName = newText
                    case Tags.Cells.email.rawValue: self.state.email = newText
                    case Tags.Cells.phoneNumber.rawValue: self.state.phoneNumber = newText
                    default: break
                    }
                }
            )
        )
    }

    private lazy var selectGenderRow = DropdownFormRow(
        tag: Tags.Cells.gender.rawValue,
        config: DropdownFormConfig(
            title: "Select Gender",
            placeholder: state.gender?.name ?? "Gender",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in self?.handleGenderSelection() }
        )
    )

    private lazy var selectAgeRangeRow = DropdownFormRow(
        tag: Tags.Cells.ageGroup.rawValue,
        config: DropdownFormConfig(
            title: "Select Age Range",
            placeholder: state.ageRange?.name ?? "Age Range",
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in self?.handleAgeRangeSelection() }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "Continue",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in self?.gotoConfirm?() }
    )

    // MARK: - Input Handlers
    private func configureInputHandlers() {
        // Prefill already handled via initialText
        // Any dynamic behaviors can be added here if needed
    }

    // MARK: - Selection Handlers
    private func handleGenderSelection() {
        goToCommonSelectionOptions(.userGender(page: 0, count: 10), nil) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state.gender = value
            self.selectGenderRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }

    private func handleAgeRangeSelection() {
        goToCommonSelectionOptions(.ageGroups(page: 0, count: 100), nil) { [weak self] value in
            guard let self = self, let value = value else { return }
            self.state.ageRange = value
            self.selectAgeRangeRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
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

    // MARK: - State
    private struct State {
        var isLoggedIn: Bool = true
        var userProfile: UserDetails?

        var firstName: String?
        var email: String?
        var phoneNumber: String?

        var genderOptions: [CommonIdNameModel] = [
            CommonIdNameModel(id: 1, name: "Male"),
            CommonIdNameModel(id: 2, name: "Female")
        ]
        var gender: CommonIdNameModel?
        var ageRange: CommonIdNameModel?

        init(userProfile: UserDetails? = nil) {
            self.userProfile = userProfile
            self.firstName = userProfile?.name
            self.email = userProfile?.email
            self.phoneNumber = userProfile?.phoneNumber
            
//            self.gender = userProfile.flatMap { CommonIdNameModel(from: $0.gender) }
//            self.ageRange = userProfile.flatMap { CommonIdNameModel(from: $0.ageRange) }
        }
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int { case header = 0, body = 1 }
        enum Cells: Int {
            case headerImage = 0
            case firstName = 1
            case email = 2
            case phoneNumber = 3
            case gender = 4
            case ageGroup = 5
            case submit = 6
        }
    }
}
