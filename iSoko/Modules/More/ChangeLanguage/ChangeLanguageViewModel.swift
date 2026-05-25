//
//  ChangeLanguageViewModel.swift
//  
//
//  Created by Edwin Weru on 14/05/2026.
//

import DesignSystemKit
import UtilsKit
import UIKit
import StorageKit

final class ChangeLanguageViewModel: FormViewModel {

    var confirmSelection: ((Language) -> Void)? = { _ in }

    private var state: State?

    // MARK: - Init

    override init() {
        self.state = State()
        super.init()

        self.sections = makeSections()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLanguageChange),
            name: .languageChanged,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Language Change Handler

    @objc private func handleLanguageChange() {
        refreshAllSections()
    }

    private func refreshAllSections() {

        // Rebuild full structure (important for localized strings)
        sections = makeSections()

        reloadSection(Tags.Section.header.rawValue)
        reloadSection(Tags.Section.languages.rawValue)
        reloadSection(Tags.Section.confirmation.rawValue)
    }

    // MARK: - Sections

    private func makeSections() -> [FormSection] {

        return [
            makeHeaderSection(),
            makeSelectionSection(),
            makeConfirmationSection()
        ]
    }

    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [makeHeaderTitleRow()]
        )
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(
            id: Tags.Section.languages.rawValue,
            cells: makeSelectionCells()
        )
    }

    private func makeConfirmationSection() -> FormSection {
        FormSection(
            id: Tags.Section.confirmation.rawValue,
            title: nil,
            cells: [makeConfirmButtonRow()]
        )
    }

    // MARK: - Header

    private func makeHeaderTitleRow() -> FormRow {

        TitleDescriptionFormRow(
            tag: 101,
            model: TitleDescriptionModel(
                title: "common.language_picker.title".localized,
                description: "common.language_picker.description".localized,
                maxTitleLines: 2,
                maxDescriptionLines: 0,
                titleEllipsis: .none,
                descriptionEllipsis: .none,
                layoutStyle: .stackedVertical,
                textAlignment: .left,
                titleFontStyle: .title,
                descriptionFontStyle: .headline
            )
        )
    }

    // MARK: - Selection

    private func makeSelectionCells() -> [FormRow] {
        let languages = self.languages()
        return languages.map { makeLanguageRow(for: $0) }
    }

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

    private func updateSelectionSection() {

        guard let index = sections.firstIndex(where: {
            $0.id == Tags.Section.languages.rawValue
        }) else { return }

        sections[index].cells = makeSelectionCells()
        reloadSection(index)
    }

    // MARK: - Confirm Button

    private func makeConfirmButtonRow() -> ButtonFormRow {

        ButtonFormRow(
            tag: 9999,
            model: ButtonFormModel(
                title: "common.button.confirm".localized,
                style: .primary,
                size: .medium,
                icon: nil,
                fontStyle: .headline,
                hapticsEnabled: true
            ) { [weak self] in

                guard let self = self,
                      let selectedLanguage = self.state?.selectedLanguage else { return }

                // 1. Persist selection
                AppStorage.selectedLanguage = selectedLanguage.code

                // 2. Apply language globally
                LocalizationManager.shared.setLanguage(selectedLanguage.code)

                // 3. Notify app (SINGLE SOURCE OF TRUTH EVENT)
                NotificationCenter.default.post(
                    name: .languageChanged,
                    object: selectedLanguage.code
                )

                // 4. Callback
                self.confirmSelection?(selectedLanguage)
            }
        )
    }

    // MARK: - Helpers

    private func tag(for language: Language) -> Int {
        language.code.hashValue
    }

    public func languages() -> [Language] {
        let helper = LanguageHelper.shared
        state?.languages = helper.supportedLanguages
        return state?.languages ?? []
    }

    // MARK: - Selection Handling

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
