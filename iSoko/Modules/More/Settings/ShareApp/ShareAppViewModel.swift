//
//  ShareAppViewModel.swift
//
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class ShareAppViewModel: FormViewModel {

    // MARK: - Properties

    private var state: State

    /// Emits the items to share when the user taps the share button
    var onShareRequested: (([Any]) -> Void)?

    // MARK: - Init

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Make Sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = [
            FormSection(id: Tags.Section.header.rawValue, cells: [imageFormRow])
        ]
        
        sections.append(
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: [
                    promoCodeFormRow,
                    SpacerFormRow(tag: 00100, height: 24),
                    submitButtonRow
                ]
            )
        )

        return sections
    }

    // MARK: - Lazy Rows

    lazy var imageFormRow = ContentCardFormRow(
        tag: 1,
        config: ContentCardModel(
            title: "Share the iSOKO app invite code",
            text: "Share the iSOKO app by inviting your friends to check it out.",
            image: .promoPage,
            imagePosition: .center,
            imageHeight: 340,
            cardSettings: .default
        )
    )

    lazy var promoCodeFormRow = PromoCodeFormRow(
        tag: 101,
        config: PromoCodeModel(
            title: "Share your invite code",
            code: "ISOKO2025",
            subtitle: "Invite friends and earn rewards",
            buttonTitle: "Copy Code",
            cardSettings: .default,
            onCopyTapped: {
                print("Copied!")
            }
        )
    )

    // MARK: - Submit Button

    private lazy var submitButtonRow: FormRow = {
        let title = "Share App"
        let style: ButtonStyleType = state.isLoggedIn ? .primary : .outlined

        let buttonModel = ButtonFormModel(
            title: title,
            style: style,
            size: .medium,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            self?.shareApp()
        }

        return ButtonFormRow(tag: Tags.Cells.submit.rawValue, model: buttonModel)
    }()

    // MARK: - Share Action

    private func shareApp() {
        let code = "ISOKO2025"
        let message = "Check out the iSOKO app! Use my invite code: \(code)"

        // Only emit the items to share; the coordinator or VC handles presentation
        onShareRequested?([message])
    }

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
            case headerTitle = 1
            case submit
        }
    }
}
