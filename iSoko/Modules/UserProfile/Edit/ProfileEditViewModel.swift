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

@MainActor
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
    
    private let countryHelper = CountryHelper()
    private let authenticationService = NetworkEnvironment.shared.authenticationService

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
                    headerRow,
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
    
    // MARK: - Mutable Header Row

    private lazy var headerRow: EditableImageIdentityHeaderRow = {
        EditableImageIdentityHeaderRow(
            tag: Tags.Cells.headerImage.rawValue,
            config: makeHeaderConfig()
        )
    }()

    // MARK: - Header Config Builder

    private func makeHeaderConfig() -> EditableImageIdentityHeaderConfig {

        let profile = state.userProfile

        let imageUrl: URL? = URL(string: profile?.profileImage ?? "")

        let fullName = (
            (state.firstName ?? "")
            + " "
            + (state.lastName ?? "")
        )
        .trimmingCharacters(in: .whitespaces)

        let localImage: UIImage? = {

            if let data = state.profileImageData {
                return UIImage(data: data)
            }

            return nil
        }()

        return EditableImageIdentityHeaderConfig(

            imageURL: imageUrl,

            // local override
            localImage: localImage,

            // fallback
            placeholderImage: .user,

            title: fullName.isEmpty
            ? "user.profile.default_name".localized
            : fullName,

            subtitle: state.email ?? "user.profile.default_email".localized,

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

            onProfileImageTap: {
                print("Profile image tapped")
            },

            onEditImageTap: { [weak self] in
                self?.triggerImagePicker()
            }
        )
    }

    // MARK: - Mutable Header Refresh

    private func refreshHeaderRow() {

        headerRow.config = makeHeaderConfig()

        reloadRowWithTag(Tags.Cells.headerImage.rawValue)
    }

    // MARK: - IMAGE PICK FLOW

    private func triggerImagePicker() {

        pickFile? { [weak self] file in

            guard let self, let file else { return }

            // update draft state
            self.state.profileImageData = file.fileData

            // mutate existing row
            self.refreshHeaderRow()
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

    // MARK: - Input Factory

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
                config: TextFieldConfig(
                    placeholder: placeholder,
                    keyboardType: .default
                ),
                validation: ValidationConfiguration(
                    isRequired: true,
                    minLength: 3,
                    maxLength: 50
                ),
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

                    // keep header reactive
                    self.refreshHeaderRow()
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
            onTap: { [weak self] in
                self?.handleGenderSelection()
            }
        )
    )

    private lazy var selectAgeRangeRow = DropdownFormRow(
        tag: Tags.Cells.ageGroup.rawValue,
        config: DropdownFormConfig(
            title: "common.label.select_age_range".localized,
            placeholder: state.ageRange?.name ?? "common.label.age_range".localized,
            rightImage: UIImage(systemName: "chevron.down"),
            isCardStyleEnabled: true,
            onTap: { [weak self] in
                self?.handleAgeRangeSelection()
            }
        )
    )

    // MARK: - Continue
    private lazy var continueButtonRow = ButtonFormRow(
        tag: Tags.Cells.submit.rawValue,
        model: ButtonFormModel(
            title: "common.button.continue".localized,
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in

            self?.gotoConfirm?()
        }
    )

    // MARK: - Input Handlers
    private func configureInputHandlers() {
        // reactive updates handled inline
    }

    // MARK: - Selection Handlers
    private func handleGenderSelection() {

        goToCommonSelectionOptions(
            .userGender(page: 0, count: 10),
            nil
        ) { [weak self] value in

            guard let self, let value else { return }

            self.state.gender = value

            self.selectGenderRow.config.placeholder = value.name

            self.reloadRowWithTag(self.selectGenderRow.tag)
        }
    }

    private func handleAgeRangeSelection() {
        goToCommonSelectionOptions(
            .ageGroups(page: 0, count: 100),
            nil
        ) { [weak self] value in

            guard let self, let value else { return }

            self.state.ageRange = value

            self.selectAgeRangeRow.config.placeholder = value.name

            self.reloadRowWithTag(self.selectAgeRangeRow.tag)
        }
    }

    // MARK: - Reload Row

    func reloadRowWithTag(_ tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {

            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {

                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))

                break
            }
        }
    }
    
    private func performProfileUpdate() async -> Bool {
        showLoader()
        defer { hideLoader() }

        do {
            let userPayload = buildUserPayload()
            let jsonData = try JSONSerialization.data(withJSONObject: userPayload)
            let jsonString = String(data: jsonData, encoding: .utf8)

            guard let jsonString else {
                throw NSError(domain: "Invalid JSON", code: -1)
            }

            var multipart: [String: Any] = [
                "user": jsonString
            ]

            // attach image if exists
            if let imageData = state.profileImageData {
                multipart["profileImage"] = imageData
            }

            // let response = try await authenticationService.updateUserProfile(user: <#T##[String : Any]?#>, image: <#T##PickedFile?#>, accessToken: <#T##String#>)

            // sync local cache
            // AppStorage.userProfile = response

            return true

        } catch let NetworkError.server(response) {

            print("🚫 Server error:", response.message ?? "Unknown")

            state.errorMessage = response.message
            state.fieldErrors = response.errors

            showError(state.errorMessage ?? "Update failed")
            return false

        } catch {

            print("❌ Profile update error:", error)

            state.errorMessage = "Something went wrong"
            showError(state.errorMessage ?? "Update failed")

            return false
        }
    }
    
    private func buildUserPayload() -> [String: Any] {
        [
            "firstName": state.firstName ?? "",
            "middleName": "",
            "lastName": state.lastName ?? "",
            
            "countryId": state.userProfile?.country?.id ?? 0,
            "locationId": state.userProfile?.location?.id ?? 0,
            
            "genderId": state.gender?.id ?? 0,
            "ageGroupId": state.ageRange?.id ?? 0,
            "status": "Active"
        ]
    }

    // MARK: - State

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
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?

        // local unsaved override
        var profileImageData: Data?

        init(userDetail: UserDetails? = nil) {

            self.userDetail = userDetail

            self.userProfile = AppStorage.userProfile

            self.fullName = userDetail?.name

            self.firstName = userProfile?.firstName
            self.lastName = userProfile?.lastName

            self.email = userProfile?.email
            self.phoneNumber = userProfile?.phoneNumber

            self.gender = userProfile.flatMap {
                CommonIdNameModel(from: $0.gender)
            }

            self.ageRange = userProfile.flatMap {
                CommonIdNameModel(from: $0.ageGroup)
            }
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
