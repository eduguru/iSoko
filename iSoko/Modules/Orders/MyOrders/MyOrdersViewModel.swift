//
//  MyOrdersViewModel.swift
//  
//
//  Created by Edwin Weru on 03/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class MyOrdersViewModel: FormViewModel {
    
    private var state: State

    override init() {
        self.state = State()
        super.init()
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        var sections: [FormSection] = []

        return sections
    }

    // MARK: - Lazy or Computed Rows

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
        }
    }
}
