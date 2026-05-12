//
//  NewsDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 15/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class NewsDetailsViewModel: FormViewModel {

    private var state: State

    init(_ item: NewsDetailsItem) {
        self.state = State(newsItem: item)
        super.init()
        self.sections = makeSections()
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {
        [
            makeHeaderSection(),
            makeBodySection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            cells: [headerImage, headerTitle, headerMeta]
        )
    }

    private func makeBodySection() -> FormSection {
        FormSection(
            id: Tags.Section.body.rawValue,
            cells: [bodyText]
        )
    }

    // MARK: - Lazy Rows

    private lazy var headerImage: FormRow = makeHeaderImageRow()
    private lazy var headerTitle: FormRow = makeHeaderTitleRow()
    private lazy var headerMeta: FormRow = makeHeaderMetaRow()
    private lazy var bodyText: FormRow = makeBodyTextRow()

    // MARK: - Header Image

    private func makeHeaderImageRow() -> FormRow {

        let imageURL = state.newsItem.image?.url(baseURL: DirectusImageHelper.baseURL)

        return ImageFormRow(
            tag: 1,
            config: .init(
                image: .blankRectangle,
                imageURL: imageURL,
                height: 200,
                fillWidth: true,
                aspectRatio: 16 / 9
            )
        )
    }

    // MARK: - Title

    private func makeHeaderTitleRow() -> FormRow {
        TitleDescriptionFormRow(
            tag: 101,
            model: TitleDescriptionModel(
                title: state.newsItem.title,
                description: "",
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .tail,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left
            )
        )
    }

    // MARK: - Meta (date + category)

    private func makeHeaderMetaRow() -> FormRow {

        let dateText = formatDate(state.newsItem.createdOn)
        let category = state.newsItem.category

        return TitleDescriptionFormRow(
            tag: 102,
            model: TitleDescriptionModel(
                title: category,
                description: dateText,
                maxTitleLines: 1,
                maxDescriptionLines: 1,
                titleEllipsis: .tail,
                descriptionEllipsis: .tail,
                layoutStyle: .stackedVertical,
                textAlignment: .left
            )
        )
    }

    // MARK: - Body

    private func makeBodyTextRow() -> FormRow {
        RichDescriptionFormRow(
            tag: 3001,
            model: RichDescriptionModel(
                title: "",
                htmlDescription: state.newsItem.body,
                textAlignment: .left
            )
        )
    }

    // MARK: - Date Formatting

    private func formatDate(_ isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = formatter.date(from: isoString) else {
            return isoString
        }

        let display = DateFormatter()
        display.dateFormat = "dd MMM yyyy, hh:mm a"
        display.locale = Locale.current
        display.timeZone = TimeZone.current

        return display.string(from: date)
    }

    // MARK: - State

    private struct State {
        var newsItem: NewsDetailsItem
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case body = 1
        }
    }
}
