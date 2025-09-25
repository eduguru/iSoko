//
//  SignupViewModel.swift
//  iSoko
//
//  Created by Edwin Weru on 12/08/2025.
//

import DesignSystemKit
import UIKit

final class SignupViewModel: FormViewModel {
    var confirmSelection: ((CommonIdNameModel) -> Void)? = { _ in }

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
            title: "Choose your account type",
            description: "Select your type of account that best describe your needs",
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .left
        )
        
        return row
    }

    private func makeSelectionSection() -> FormSection {
        FormSection(id: Tags.Section.transactions.rawValue, cells: makeSelectionCells())
    }
    
    private func updateSelectionSection() {
        guard let sectionIndex = sections.firstIndex( where: { $0.id == Tags.Section.transactions.rawValue }) else { return }
        let cells = makeSelectionCells()
        
        sections[sectionIndex].cells = cells
        reloadSection(sectionIndex)
    }

    private func makeSelectionCells() -> [FormRow] {
        let items = options()
        return items.map { makeCountryRow(for: $0) }
    }

    // MARK: - Row Builders

    private func makeCountryRow(for item: CommonIdNameModel) -> SelectableRow {
        let tag = tag(for: item)
        let isSelected: Bool = state?.selectedOption?.id == item.id ? true : false

        return SelectableRow(
            tag: tag,
            config: SelectableRowConfig(
                title: item.name,
                description: item.description ?? "",
                isSelected: isSelected,
                selectionStyle: .radio,
                isAccessoryVisible: true,
                accessoryImage: nil,
                isCardStyleEnabled: true,
                cardCornerRadius: 12,
                cardBackgroundColor: .secondarySystemGroupedBackground,
                cardBorderColor: UIColor.systemGray4,
                cardBorderWidth: 1,
                onToggle: { [weak self] selected in
                    guard let self = self else { return }

                    if selected {
                        self.state?.selectedOption = item
                        self.state?.selectedTag = tag
                        self.updateSelectionSection()
                    }
                }
            ),
            useDividerStyle: false
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
            guard let selectedOption = self.state?.selectedOption else { return }

            self.confirmSelection?(selectedOption)
        }
    )

    // MARK: - Helpers

    private func tag(for item: CommonIdNameModel) -> Int {
        return item.id.hashValue
    }
    
    // MARK: - Country Data
    private func options() -> [CommonIdNameModel] {
        var items: [CommonIdNameModel] = []
        
        items.append(CommonIdNameModel(
            id: 0,
            name: "Individual Account",
            description: "Perfect for sole proprietor, freelancers, and individual business owners managing their own operations")
        )
        
        items.append(CommonIdNameModel(
            id: 1,
            name: "Organisation Account",
            description: "Ideal for companies, partnerships, cooperatives, and organisations with multiple stakeholders")
        )

        state?.options = items
        return state?.options ?? []
    }

    // MARK: - Selection Handling (optional override)
    override func didSelectRow(at indexPath: IndexPath, row: FormRow) {
        switch indexPath.section {
        default:
            break
        }
    }

    // MARK: - State

    private struct State {
        var options: [CommonIdNameModel] = []
        var selectedOption: CommonIdNameModel?
        var searchText: String = ""
        var selectedTag: Int?
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
            case transactions = 1
            case confirmation = 2
        }

        enum Cells: Int {
            case search = 0
            case ceountry = 1
            case comfirm = 2
        }
    }
}
