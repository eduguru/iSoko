//
//  HomeViewModel.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class HomeViewModel: FormViewModel {
    private var state: State?

    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        return [
            FormSection(id: 001, cells: [searchRow])
        ]
    }

    lazy var searchRow = SearchFormRow(
            tag: 3001,
            model: SearchFormModel(
                placeholder: "Search for anything",
                keyboardType: .default,
                searchIcon: UIImage(systemName: "magnifyingglass"),
                searchIconPlacement: .right,
                filterIcon: nil,
                didTapSearchIcon: { print("Search icon tapped") },
                didTapFilterIcon: { print("Filter icon tapped") },
                didStartEditing: { text in print("Started editing with: \(text)") },
                didEndEditing: { text in print("Ended editing with: \(text)") },
                onTextChanged: { text in print("Search text changed: \(text)") }
            )
        )

    // MARK: - State

    private struct State {
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
