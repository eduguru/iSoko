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
    
    // MARK: - Callbacks
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    var onPreviewImage: ((PickedFile) -> Void)?
    var gotoConfirm: (() -> Void)?
    
    var goToCommonSelectionOptions: (
        CommonUtilityOption,
        _ staticOptions: [CommonIdNameModel]?,
        _ completion: @escaping (CommonIdNameModel?) -> Void
    ) -> Void = { _, _, _ in }
    
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
                    makeUserCardRow(),
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
    
    // MARK: - HEADER ROW (SOURCE OF TRUTH)
    private func makeUserCardRow() -> FormRow {
        let profile = state.userProfile
        let imageUrl: URL? = URL(string: profile?.profileImage ?? "")
        
        let fullName = ((profile?.firstName ?? "") + " " + (profile?.lastName ?? ""))
            .trimmingCharacters(in: .whitespaces)
        
        let image: UIImage? = {
            if let data = state.profileImageData {
                return UIImage(data: data)
            }
            return .user
        }()
        
        return EditableImageIdentityHeaderRow(
            tag: Tags.Cells.headerImage.rawValue,
            config: EditableImageIdentityHeaderConfig(
                imageURL: imageUrl,
                image: image ?? .user,
                title: fullName.isEmpty
                ? "user.profile.default_name".localized
                : fullName,
                subtitle: profile?.email ?? "user.profile.default_email".localized,
                
                leadingChip: PaddedChipView(
                    text: profile?.verified ?? false
                    ? "user.profile.verified".localized
                    : "user.profile.not_verified".localized,
                    icon: UIImage(systemName: "checkmark.seal.fill"),
                    tint: .systemGreen
                ),
                
                trailingChip: PaddedChipView(
                    text: "user.profile.since".localized,
                    tint: .secondaryLabel
                ),
                
                onProfileImageTap: { print("Profile image tapped") },
                
                onEditImageTap: { [weak self] in
                    self?.triggerImagePicker()
                }
            )
        )
    }
    
    // MARK: - IMAGE PICK FLOW
    private func triggerImagePicker() {
        pickFile? { [weak self] file in
            guard let self, let file else { return }
            
            // 1. Update state
            self.state.profileImageData = file.fileData
            
            // 2. Replace header row in section
            guard let sectionIndex = self.sections.firstIndex(where: {
                $0.id == Tags.Section.body.rawValue
            }) else { return }
            
            self.sections[sectionIndex].cells[0] = self.makeUserCardRow()
            
            // 3. Reload UI
            self.reloadRowWithTag(Tags.Cells.headerImage.rawValue)
        }
    }
    
    // MARK: - INPUT ROWS
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
    
    private func makeInputRow(
        tag: Int,
        title: String,
        placeholder: String,
        initialText: String?
    ) -> SimpleInputFormRow {
        
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
                    case Tags.Cells.firstName.rawValue:
                        self.state.firstName = newText
                    case Tags.Cells.lastName.rawValue:
                        self.state.lastName = newText
                    case Tags.Cells.email.rawValue:
                        self.state.email = newText
                    case Tags.Cells.phoneNumber.rawValue:
                        self.state.phoneNumber = newText
                    default:
                        break
                    }
                }
            )
        )
    }
    
    // MARK: - DROPDOWNS
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
    
    // MARK: - INPUT HANDLERS
    private func configureInputHandlers() {
        // Prefill handled via initialText
        // No dynamic handlers needed here for now
    }
    
    // MARK: - SELECTION HANDLERS
    private func handleGenderSelection() {
        goToCommonSelectionOptions(.userGender(page: 0, count: 10), nil) { [weak self] value in
            guard let self, let value else { return }
            self.state.gender = value
            self.selectGenderRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }
    
    private func handleAgeRangeSelection() {
        goToCommonSelectionOptions(.ageGroups(page: 0, count: 100), nil) { [weak self] value in
            guard let self, let value else { return }
            self.state.ageRange = value
            self.selectAgeRangeRow.config.placeholder = value.name
            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
        }
    }
    
    // MARK: - RELOAD ROW
    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }
    
    // MARK: - STATE
    private struct State {

        var isLoggedIn: Bool = true

        var fullName: String?

        var firstName: String?
        var lastName: String?

        var email: String?
        var phoneNumber: String?

        var userDetail: UserDetails?
        var userProfile: UserProfileResponse?

        var gender: CommonIdNameModel?
        var ageRange: CommonIdNameModel?

        // profile image override (picked file)
        var profileImageData: Data?

        init(userDetail: UserDetails? = nil) {

            self.userDetail = userDetail
            self.userProfile = AppStorage.userProfile

            // PREFILL CORE FIELDS
            self.fullName = userDetail?.name

            self.firstName = userProfile?.firstName
            self.lastName = userProfile?.lastName

            self.email = userProfile?.email
            self.phoneNumber = userProfile?.phoneNumber

            // PREFILL DROPDOWNS
            self.gender = userProfile.flatMap { CommonIdNameModel(from: $0.gender) }
            self.ageRange = userProfile.flatMap { CommonIdNameModel(from: $0.ageGroup) }
        }
    }
    
    // MARK: - TAGS
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
        
        enum Cells: Int {
            case headerImage = 0
            case firstName = 1
            case lastName = 2
            case email = 3
            case phoneNumber = 4
            case gender = 5
            case ageGroup = 6
            case submit = 7
        }
    }
}
