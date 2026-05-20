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
    
    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []

        sections.append(FormSection(
            id: Tags.Section.body.rawValue,
            cells: Helpers.insertDividers(into: [
                imageRow,
                firstNameRow,
                genderRow,
                ageGroupRow,
                emailRow,
                phoneNumberRow
            ])
        ))

        return sections
    }

    // MARK: - Lazy or Computed Rows

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

    private lazy var firstNameRow = TitleDescriptionFormRow(
        tag: Tags.Cells.firstName.rawValue,
        model: TitleDescriptionModel(
            title: "common.label.first_name".localized,
            description: state.userProfile?.firstName ?? "Enter your first name",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    )

    private lazy var genderRow = TitleDescriptionFormRow(
        tag: Tags.Cells.gender.rawValue,
        model: TitleDescriptionModel(
            title: "common.label.gender".localized,
            description: state.userProfile?.gender?.name ?? "Select your gender",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    )

    private lazy var ageGroupRow = TitleDescriptionFormRow(
        tag: Tags.Cells.ageGroup.rawValue,
        model: TitleDescriptionModel(
            title: "Age Group",
            description: state.userProfile?.ageGroup?.name ?? "Select your age group",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    )

    private lazy var emailRow = TitleDescriptionFormRow(
        tag: Tags.Cells.email.rawValue,
        model: TitleDescriptionModel(
            title: "common.label.email_address".localized,
            description: state.userProfile?.email ?? "common.basic_profile_security.email_placeholder".localized,
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    )

    private lazy var phoneNumberRow = TitleDescriptionFormRow(
        tag: Tags.Cells.phoneNumber.rawValue,
        model: TitleDescriptionModel(
            title: "common.label.phone_number".localized,
            description: state.userProfile?.phoneNumber ?? "Enter your phone number",
            maxTitleLines: 2,
            maxDescriptionLines: 0,
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
    )

    // MARK: - State

    private struct State {
        var isLoggedIn: Bool = AppStorage.hasLoggedIn ?? false
        var userDetail: UserDetails? = AppStorage.userDetail
        var userProfile: UserProfileResponse? = AppStorage.userProfile
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
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
