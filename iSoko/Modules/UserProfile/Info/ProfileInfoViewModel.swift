//
//  ProfileInfoViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit

final class ProfileInfoViewModel: FormViewModel {
    // MARK: - Upload
    var pickFile: ((_ completion: @escaping (PickedFile?) -> Void) -> Void)?
    var onPreviewImage: ((PickedFile) -> Void)?
    var gotoConfirm: (() -> Void)?
    var goToDeleteAccount: (() -> Void)?
    var goToChangePassword: (() -> Void)?

    // MARK: - State
    private var state: State
    
    private let authenticationService = NetworkEnvironment.shared.authenticationService

    // MARK: - Init
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
        configureUploadHandlers()
    }

    // MARK: - Upload Handler
    private func configureUploadHandlers() {
        // nothing extra needed, handled via triggerImagePicker in header row
    }

    // MARK: - Sections
    private func makeSections() -> [FormSection] {
        [
            // HEADER
            FormSection(
                id: Tags.Section.header.rawValue,
                cells: [
                    makeUserCardRow(),
                    SpacerFormRow(tag: 10, height: 24)
                ]
            ),

            // BODY
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: makeBodyRows()
            ),

            // ACTIONS
            FormSection(
                id: Tags.Section.actions.rawValue,
                title: "Account Settings",
                cells: makeActionRows()
            )
        ]
    }

    // MARK: - Header Row Builder
    private func makeUserCardRow() -> FormRow {

        let profile = state.userProfile

        let imageUrl: URL? = URL(string: profile?.profileImage ?? "")

        let fullName = ((profile?.firstName ?? "") + " " + (profile?.lastName ?? ""))
            .trimmingCharacters(in: .whitespaces)

        let localImage: UIImage? = {
            if let data = state.profileImageData {
                return UIImage(data: data)
            }
            return nil
        }()

        return EditableImageIdentityHeaderRow(
            tag: Tags.Cells.headerImage.rawValue,
            config: EditableImageIdentityHeaderConfig(
                imageURL: imageUrl,

                // picked image overrides remote
                localImage: localImage,

                // fallback/default
                placeholderImage: .user,

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

                onProfileImageTap: {
                    print("Profile image tapped")
                },

                onEditImageTap: { [weak self] in
                    self?.triggerImagePicker()
                }
            )
        )
    }

    // MARK: - Trigger image picker
    private func triggerImagePicker() {
        pickFile? { [weak self] file in
            guard let self, let file else { return }

            // 1. Update state
            state.pickedFile = file
            self.state.profileImageData = file.fileData

            // 2. Rebuild header row in section
            guard let sectionIndex = self.sections.firstIndex(where: { $0.id == Tags.Section.header.rawValue }) else { return }
            self.sections[sectionIndex].cells[0] = self.makeUserCardRow()

            // 3. Reload UI
            self.reloadRow(withTag: Tags.Cells.headerImage.rawValue)
            
            // 2. Fire the network call immediately for the image-only update
            Task {
                await self.uploadProfileImage(file)
            }
        }
    }
    
    private func uploadProfileImage(_ file: PickedFile) async {
        showLoader()
        defer { hideLoader() }
        
        do {
            // Call your new isolated endpoint
            let response = try await authenticationService.updateProfileImageOnly(
                id: state.userProfile?.id ?? 0,
                image: file,
                accessToken: state.oauthToken
            )
            
            // Sync the updated profile response back to your local cache
            AppStorage.userProfile = response
            print("✅ Profile image updated successfully!")
            
        } catch let NetworkError.server(response) {
            print("🚫 Image upload server error:", response.message ?? "Unknown")
            state.errorMessage = response.message
            showError(state.errorMessage ?? "Failed to upload image")
            
        } catch {
            print("❌ Image upload error:", error)
            state.errorMessage = "Failed to save profile picture"
            showError(state.errorMessage ?? "Something went wrong")
        }
    }

    // MARK: - Reload helper
    private func reloadRow(withTag tag: Int) {
        for (sectionIndex, section) in sections.enumerated() {
            if let rowIndex = section.cells.firstIndex(where: { $0.tag == tag }) {
                onReloadRow?(IndexPath(row: rowIndex, section: sectionIndex))
                break
            }
        }
    }

    // MARK: - Body Rows
    private func makeBodyRows() -> [FormRow] {
        rowItems.map { item in
            let value = item.value()
            let description = value.isEmpty ? item.placeholder : value

            return ImageTitleDescriptionRow(
                tag: item.tag,
                config: ImageTitleDescriptionConfig(
                    image: item.icon,
                    imageStyle: .rounded,
                    title: item.title,
                    description: description,
                    accessoryType: .none,
                    onTap: nil,
                    isCardStyleEnabled: true
                )
            )
        }
    }

    // MARK: - Row Items
    private struct RowItem {
        let tag: Int
        let icon: UIImage?
        let title: String
        let value: () -> String
        let placeholder: String
    }

    private var rowItems: [RowItem] {
        [
            RowItem(
                tag: Tags.Cells.firstName.rawValue,
                icon: UIImage(systemName: "person.fill"),
                title: "common.label.first_name".localized,
                value: { [weak self] in self?.state.userProfile?.firstName ?? "" },
                placeholder: "Enter your first name"
            ),
            RowItem(
                tag: Tags.Cells.gender.rawValue,
                icon: UIImage(systemName: "person.2.fill"),
                title: "common.label.gender".localized,
                value: { [weak self] in self?.state.userProfile?.gender?.name ?? "" },
                placeholder: "Select your gender"
            ),
            RowItem(
                tag: Tags.Cells.ageGroup.rawValue,
                icon: UIImage(systemName: "calendar"),
                title: "Age Group",
                value: { [weak self] in self?.state.userProfile?.ageGroup?.name ?? "" },
                placeholder: "Select your age group"
            ),
            RowItem(
                tag: Tags.Cells.email.rawValue,
                icon: UIImage(systemName: "envelope.fill"),
                title: "common.label.email_address".localized,
                value: { [weak self] in self?.state.userProfile?.email ?? "" },
                placeholder: "Email"
            ),
            RowItem(
                tag: Tags.Cells.phoneNumber.rawValue,
                icon: UIImage(systemName: "phone.fill"),
                title: "common.label.phone_number".localized,
                value: { [weak self] in self?.state.userProfile?.phoneNumber ?? "" },
                placeholder: "Phone number"
            )
        ]
    }

    // MARK: - Actions
    private func makeActionRows() -> [FormRow] {
        [
            ImageTitleDescriptionRow(
                tag: 9001,
                config: ImageTitleDescriptionConfig(
                    image: UIImage(systemName: "key.fill"),
                    imageStyle: .rounded,
                    title: "Change Password",
                    description: "Update your account password",
                    accessoryType: .image(image: UIImage(named: "forwardArrowRightAligned") ?? .forwardArrow),
                    onTap: {[weak self] in
                        print("Change password")
                        self?.goToChangePassword?()
                    },
                    isCardStyleEnabled: true
                )
            ),
            ImageTitleDescriptionRow(
                tag: 9002,
                config: ImageTitleDescriptionConfig(
                    image: UIImage(systemName: "trash.fill"),
                    imageStyle: .rounded,
                    title: "Delete Account",
                    description: "Permanently remove your account",
                    accessoryType: .image(image: UIImage(named: "forwardArrowRightAligned") ?? .forwardArrow),
                    onTap: { [weak self] in
                        print("Delete account")
                        self?.goToDeleteAccount?()
                    },
                    isCardStyleEnabled: true
                )
            ),
            SpacerFormRow(tag: 909, height: 40)
        ]
    }

    // MARK: - State
    private struct State {
        var hasLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var oauthToken: String = AppStorage.oauthToken?.accessToken ?? ""
        var guestToken: String = AppStorage.guestToken?.accessToken ?? ""
        
        var userDetail: UserDetails? = AppStorage.userDetail
        var userProfile: UserProfileResponse? = AppStorage.userProfile
        
        var errorMessage: String?
        var fieldErrors: [BasicResponse.ErrorsObject]?

        // UI source of truth for profile image
        var pickedFile: PickedFile?
        var profileImageData: Data?
    }

    // MARK: - Tags
    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
            case actions = 2
        }

        enum Cells: Int {
            case headerImage = 0
            case firstName = 1
            case gender = 2
            case ageGroup = 3
            case email = 4
            case phoneNumber = 5
        }
    }
}
