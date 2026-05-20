//
//  NotificationsViewModel.swift
//  
//
//  Created by Edwin Weru on 20/05/2026.
//


import DesignSystemKit
import UIKit
import StorageKit

final class NotificationsViewModel: FormViewModel {
    
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
        
        return sections
    }
    
    private func makeHeaderSection() -> FormSection {
        FormSection(
            id: Tags.Section.header.rawValue,
            title: nil,
            cells: [
                makeHeaderImageCell()
            ]
        )
    }
    
    // MARK: - make rows
    private func makeHeaderImageCell() -> FormRow {
        let imageRow = ImageFormRow(
            tag: 1,
            config: .init(
                image: .noData,
                height: 120
            )
        )
        return imageRow
        
    }
    
    private func makeHeaderTitleRow() -> FormRow {
        let row = TitleDescriptionFormRow(
            tag: 101,
            model: TitleDescriptionModel(
            title:  "common.country_language.header_title".localized,
            description: "common.country_language.header_description".localized,
            maxTitleLines: 2,
            maxDescriptionLines: 0,  // unlimited lines
            titleEllipsis: .none,
            descriptionEllipsis: .none,
            layoutStyle: .stackedVertical,
            textAlignment: .center
        )
        )
        
        return row
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
