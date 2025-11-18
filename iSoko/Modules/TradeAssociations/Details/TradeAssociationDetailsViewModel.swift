//
//  TradeAssociationDetailsViewModel.swift
//  
//
//  Created by Edwin Weru on 12/11/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class TradeAssociationDetailsViewModel: FormViewModel {
    
    private var state: State
    
    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }
    
    // MARK: - make sections
    
    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []
        
        sections.append(FormSection(id: Tags.Section.header.rawValue, cells: [segmentedOptions]))
        
        sections.append(
            FormSection(
                id: Tags.Section.body.rawValue,
                cells: makeImageRows()
            )
        )
        
        return sections
    }
    
    // MARK: - Lazy or Computed Rows
    private lazy var segmentedOptions = makeOptionsSegmentFormRow()

    private func makeOptionsSegmentFormRow() -> FormRow {
        let styledSegmentRow = SegmentedFormRow(
            model: SegmentedFormModel(
                title: nil,
                segments: ["About", "News"],
                selectedIndex: state.selectedSegmentIndex,
                tag: 2001,
                tintColor: .gray,
                selectedSegmentTintColor: .app(.primary),
                backgroundColor: .white,
                titleTextColor: .darkGray,
                segmentTextColor: .lightGray,
                selectedSegmentTextColor: .white,
                onSelectionChanged: { [weak self] selectedIndex in
                    guard let self = self else { return }
                    self.state.selectedSegmentIndex = selectedIndex
                    self.reloadBodySection()
                }
            )
        )
        return styledSegmentRow
    }
    
    // MARK: - Body Reload Logic
    private func reloadBodySection() {
        // Replace the "body" section with updated rows
        var updatedSections = sections

        // let newBodyRows = makeImageRows(for: state.selectedSegmentIndex)
        let newBodySection = FormSection(id: Tags.Section.body.rawValue, cells: [])

        if updatedSections.count > 1 {
            updatedSections[1] = newBodySection
        } else {
            updatedSections.append(newBodySection)
        }

        // Trigger UI reload automatically through didSet
        self.sections = updatedSections

        // Optionally, if you want a fade animation on the body section:
        onReloadSection?(Tags.Section.body.rawValue)
    }
    
    /// Generates a reusable ImageTitleDescriptionRow
    private func makeImageTitleDescriptionRow(
        tag: Int,
        image: UIImage,
        title: String,
        description: String,
        onTap: (() -> Void)? = nil
    ) -> FormRow {
        return ImageTitleDescriptionRow(
            tag: tag,
            config: ImageTitleDescriptionConfig(
                image: image,
                imageStyle: .rounded,
                title: title,
                description: description,
                accessoryType: .none,
                onTap: onTap,
                isCardStyleEnabled: true
            )
        )
    }
    
    /// Easily loop and create multiple rows
    
    private func makeRowItemsArray() -> [RowItemModel] {
        var items: [RowItemModel] = []
        
        items.append(contentsOf: [
            RowItemModel(title: "www.assocation-website.com", description: "", image: .link, onTap: { [weak self] in
                
            }),
            RowItemModel(title: "+254 738 789 333", description: "", image: .activate, onTap: { [weak self] in
                
            }),
            RowItemModel(title: "Nairobi, Kenya", description: "", image: .location, onTap: { [weak self] in
                
            })
        ])
        
        return items
    }
    
    private func makeImageRows() -> [FormRow] {
        let items = makeRowItemsArray()
        
        return items.enumerated().map { index, item in
            makeImageTitleDescriptionRow(
                tag: 2000 + index,
                image: item.image,
                title: item.title,
                description: item.description,
                onTap: item.onTap
            )
        }
    }
    
    // MARK: - State
    
    private struct State {
        var isLoggedIn: Bool = true
        var selectedSegmentIndex: Int = 0
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
        }
    }
}
