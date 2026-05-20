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
        self.state = State(userDetail: userProfile)
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
                    lastNameInputRow,
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
            image: UIImage(named: "user"),
            imageUrl: URL(string: state.userProfile?.profileImage ?? ""),
            height: 120,
            fillWidth: false,
            alignment: .center,
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
        title: "common.label.first_name".localized,
        placeholder: "Enter First Name",
        initialText: state.firstName
    )
    
    private lazy var lastNameInputRow = makeInputRow(
        tag: Tags.Cells.lastName.rawValue,
        title: "Last Name",
        placeholder: "Enter Last Name",
        initialText: state.lastName
    )

    private lazy var emailInputRow = makeInputRow(
        tag: Tags.Cells.email.rawValue,
        title: "common.label.email_address".localized,
        placeholder: "Enter Email Address",
        initialText: state.email
    )

    private lazy var phoneInputRow = makeInputRow(
        tag: Tags.Cells.phoneNumber.rawValue,
        title: "common.label.phone_number".localized,
        placeholder: "common.basic_profile_security.phone_placeholder".localized,
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
            title: "common.label.select_gender".localized,
            placeholder: state.gender?.name ?? "common.label.gender".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in self?.handleGenderSelection() }
        )
    )

    private lazy var selectAgeRangeRow = DropdownFormRow(
        tag: Tags.Cells.ageGroup.rawValue,
        config: DropdownFormConfig(
            title: "common.label.select_age_range".localized,
            placeholder: state.ageRange?.name ?? "common.label.age_range".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in self?.handleAgeRangeSelection() }
        )
    )

    private lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "common.button.continue".localized,
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

        var fullName: String?
        var firstName: String?
        var lastName: String?
        
        var email: String?
        var phoneNumber: String?
        var userDetail: UserDetails? = AppStorage.userDetail
        var userProfile: UserProfileResponse? = AppStorage.userProfile

        var gender: CommonIdNameModel?
        var ageRange: CommonIdNameModel?

        init(userDetail: UserDetails? = nil) {
            self.userDetail = userDetail
            
            self.fullName = userDetail?.name
            self.firstName = userProfile?.firstName
            self.lastName = userProfile?.lastName
            
            self.email = userProfile?.email
            self.phoneNumber = userProfile?.phoneNumber
            
            self.gender = userProfile.flatMap { CommonIdNameModel(from: $0.gender) }
            self.ageRange = userProfile.flatMap { CommonIdNameModel(from: $0.ageGroup) }
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
            case lastName
        }
    }
}
