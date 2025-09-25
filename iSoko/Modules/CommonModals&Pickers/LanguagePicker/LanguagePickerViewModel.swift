//
//  LanguagePickerViewModel.swift
//  
//
//  Created by Edwin Weru on 18/09/2025.
//


import DesignSystemKit
import UtilsKit
import UIKit

final class LanguagePickerViewModel: FormViewModel {
    var confirmSelection: ((Language) -> Void)? = { _ in }

    private var state: State?

    override init() {
        self.state = State()
        super.init()

        self.sections = makeSections()
    }

    // MARK: - Section Builders
    
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(FormSection(id: Tags.Section.header.rawValue, title: nil, cells: [makeHeaderTitleRow()]))
        sections.append(makeSelectionSection())
        sections.append(FormSection(id: Tags.Section.confirmation.rawValue, title: nil, cells: [confirmButtonRow]))

        return sections
    }

    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            title: "Choose your Language",
            description: "Chagua lugha / Hitamo nururimi / Sélectionnez la langue",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left,
            titleFontStyle: .title,
            descriptionFontStyle: .headline
        )
        
        return row
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(id: Tags.Section.languages.rawValue, cells: makeSelectionCells())
    }

    private func updateSelectionSection() {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == Tags.Section.languages.rawValue }) else { return }
        sections[sectionIndex].cells = makeSelectionCells()
        reloadSection(sectionIndex)
    }

    private func makeSelectionCells() -> [FormRow] {
        let languages = self.languages()
        return languages.map { makeLanguageRow(for: $0) }
    }

    // MARK: - Row Builders

    private func makeLanguageRow(for language: Language) -> SelectableRow {
        let tag = tag(for: language)
        let isSelected = state?.selectedLanguage?.code == language.code

        return SelectableRow(
            tag: tag,
            config: SelectableRowConfig(
                title: language.name,
                description: nil,
                isSelected: isSelected,
                selectionStyle: .radio,
                isAccessoryVisible: false,
                accessoryImage: nil,
                isCardStyleEnabled: true,
                cardCornerRadius: 12,
                cardBackgroundColor: .secondarySystemGroupedBackground,
                cardBorderColor: UIColor.systemGray4,
                cardBorderWidth: 1,
                onToggle: { [weak self] selected in
                    guard let self = self else { return }
                    if selected {
                        self.state?.selectedLanguage = language
                        self.state?.selectedTag = tag
                        self.updateSelectionSection()
                    }
                }
            )
        )
    }

    // MARK: - Button Row

    lazy var confirmButtonRow = ButtonFormRow(
        tag: 9999,
        model: ButtonFormModel(
            title: "Confirm",
            style: .primary,
            size: .medium,
            icon: nil,
            fontStyle: .headline,
            hapticsEnabled: true
        ) { [weak self] in
            guard let self = self else { return }
            guard let selectedLanguage = self.state?.selectedLanguage else { return }
            self.confirmSelection?(selectedLanguage)
        }
    )

    // MARK: - Helpers

    private func tag(for language: Language) -> Int {
        return language.code.hashValue
    }

    public func languages() -> [Language] {
        let helper = LanguageHelper.shared
        state?.languages = helper.supportedLanguages
        return state?.languages ?? []
    }

    // MARK: - Selection Handling (optional override)

    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        case Tags.Section.header.rawValue:
            print("Header section row selected: \(row.tag)")
        case Tags.Section.languages.rawValue:
            print("Language section row selected: \(row.tag)")
        default:
            break
        }
    }

    // MARK: - State

    private struct State {
        var languages: [Language] = []
        var selectedLanguage: Language?
        var selectedTag: Int?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case languages = 1
            case confirmation = 2
        }

        enum Cells: Int {
            case search = 0
            case language = 1
            case confirm = 2
        }
    }
}
