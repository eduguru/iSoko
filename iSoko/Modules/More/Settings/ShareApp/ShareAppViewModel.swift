//
//  ShareAppViewModel.swift
//
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit
import StorageKit
import LinkPresentation

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
            FormSection(id: Tags.Section.header.rawValue, cells: [
                imageFormRow,
                SpacerFormRow(tag: -00999, height: 10)
            ])
        ]
        
        sections.append(
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: [
                    referralCount,
                    SpacerFormRow(tag: 00100, height: 10),
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
            image: .logo,
            imagePosition: .center,
            imageHeight: 100,
            cardSettings: .default
        )
    )

    lazy var promoCodeFormRow = PromoCodeFormRow(
        tag: 101,
        config: PromoCodeModel(
            title: "Share your invite code",
            code: state.userProfile?.referralCode ?? "ISOKO2025",
            subtitle: "Invite friends and earn rewards",
            buttonTitle: "Copy Code",
            cardSettings: .default,
            onCopyTapped: {
                print("Copied!")
            }
        )
    )
    
    private lazy var referralCount = ImageTitleDescriptionRow(
            tag: -0909,
            config: ImageTitleDescriptionConfig(
                image: UIImage(systemName: "person.badge.plus"),
                imageStyle: .rounded,
                title: "People invited",
                description: "\(state.userProfile?.referralCount ?? 0)",
                accessoryType: .none,
                onTap: {},
                isCardStyleEnabled: true
            )
        )

    // MARK: - Submit Button

    private lazy var submitButtonRow: FormRow = {
        let title = "Share App"
        let style: ButtonStyleType = .outlined// state.isLoggedIn ? .primary : .outlined

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
        let code = state.userProfile?.referralCode ?? "ISOKO2025"
        let urlString = "https://isoko.app/download"

        let message = """
        Check out the iSOKO app!

        Use my invite code: \(code)

        \(urlString)
        """

        let provider = ShareAppItemSource(
            message: message,
            url: URL(string: urlString)!
        )

        onShareRequested?([provider])
    }

    // MARK: - State

    private struct State {
        var isLoggedIn: Bool = true
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
            case headerTitle = 1
            case submit
        }
    }
}


final class ShareAppItemSource: NSObject, UIActivityItemSource {

    private let message: String
    private let url: URL

    init(message: String, url: URL) {
        self.message = message
        self.url = url
    }

    func activityViewControllerPlaceholderItem(
        _ activityViewController: UIActivityViewController
    ) -> Any {
        return message
    }

    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any {
        return message
    }

    func activityViewControllerLinkMetadata(
        _ activityViewController: UIActivityViewController
    ) -> LPLinkMetadata? {

        let metadata = LPLinkMetadata()
        metadata.title = "iSOKO App Invitation"
        metadata.originalURL = url
        metadata.url = url

        return metadata
    }
}
