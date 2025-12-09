//
//  ProfileInfoViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

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
                pills,
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
    
    private lazy var pills = PillsFormRow(
        tag: 0090,
        items: [
            PillItem(id: "01", title: "Hey there"),
            PillItem(id: "03", title: "Hey you"),
            PillItem(id: "04", title: "Hey man"),
            PillItem(id: "05", title: "Hey girl"),
            PillItem(id: "06", title: "Hey there"),
            PillItem(id: "07", title: "Hey")
        ]
    )

    private lazy var imageRow = EditableImageFormRow(
        tag: 2001,
        config: .init(
            image: UIImage(named: "user"),
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


    private lazy var firstNameRow = TitleDescriptionFormRow(
        tag: Tags.Cells.firstName.rawValue,
        title: "First Name",
        description: "Enter your first name",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
    )

    private lazy var genderRow = TitleDescriptionFormRow(
        tag: Tags.Cells.gender.rawValue,
        title: "Gender",
        description: "Select your gender",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
    )

    private lazy var ageGroupRow = TitleDescriptionFormRow(
        tag: Tags.Cells.ageGroup.rawValue,
        title: "Age Group",
        description: "Select your age group",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
    )

    private lazy var emailRow = TitleDescriptionFormRow(
        tag: Tags.Cells.email.rawValue,
        title: "Email Address",
        description: "Enter your email",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
    )

    private lazy var phoneNumberRow = TitleDescriptionFormRow(
        tag: Tags.Cells.phoneNumber.rawValue,
        title: "Phone Number",
        description: "Enter your phone number",
        maxTitleLines: 2,
        maxDescriptionLines: 0,
        titleEllipsis: .none,
        descriptionEllipsis: .none,
        layoutStyle: .stackedVertical,
        textAlignment: .left
    )

    // MARK: - State

    private struct State {
        var isLoggedIn: Bool = true
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
