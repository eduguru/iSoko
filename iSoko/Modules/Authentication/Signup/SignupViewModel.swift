//
//  SignupViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import DesignSystemKit
import UIKit

final class SignupViewModel: FormViewModel {
    var goToSignUp: (() -> Void)? = { }
    
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
        sections.append(makeCredentialsSection())
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                makeHeaderTitleRow(),
            ]
        )
    }
    
    private func makeCredentialsSection() -> FormSection {
        FormSection(
            id: Tags.Section.credentials.rawValue,
            title: nil,
            cells: [
                SpacerFormRow(tag: 1001),
                makeSimpleImageTitleDescriptionRow(),
                makeImageTitleDescriptionRow()
            ]
        )
        
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Welcome to the app, Welcome to the app, Welcome to the app",
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
    
    private func makeSimpleImageTitleDescriptionRow() -> FormRow {
        return SimpleImageTitleDescriptionRow(
            tag: 1,
            image: UIImage(named: "user"),
            imageIsRounded: true,
            title: "John Doe",
            description: "iOS Developer",
            showsArrow: true
        ) {
            print("Cell tapped")
        }
    }
    
    private func makeImageTitleDescriptionRow() -> FormRow {
        let row = ImageTitleDescriptionRow(
            tag: 102,
            config: ImageTitleDescriptionConfig(
                image: UIImage(named: "user"),
                imageStyle: .rounded, title: "Account Settings",
                description: "Manage your personal information, Manage your personal information, Manage your personal information",
                accessoryType: .image(image: UIImage(named: "forwardArrowRightAligned") ?? .arrowDown),
                onTap: {
                    print("Cell tapped")
                }
            )
        )

        return row
    }
    
    // MARK: - selection
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
            // Handle header taps here
        case Tags.Section.credentials.rawValue:
            print("Credentials section row selected: \(row.tag)")
            // Handle credentials taps here
        default:
            break
        }
    }
    
    
    private struct State {
        
    }
    
    enum Tags {
        enum Section: Int {
            case header = 0
            case credentials = 1
        }
        
        enum Cells: Int {
            case signIn = 0
            case forgotPassword = 1
            case register = 2
            case guest = 3
            case divideLine = 4
            case headerImage = 5
            case headerTitle = 6
        }
    }
}

