//
//  BookKeepingSuppliesViewModel.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class BookKeepingSuppliesViewModel: FormViewModel {
   
    private var state = State()

    override init() {
        super.init()
    }

    // MARK: - Sections


    // MARK: - Lazy Rows


    // MARK: - State

    private struct State {
    }

    // MARK: - Tags

    enum Tags {
        enum Section: Int {
            case header = 0
        }
        enum Cells: Int {
            case searchBar = 0
            
        }
    }
}
