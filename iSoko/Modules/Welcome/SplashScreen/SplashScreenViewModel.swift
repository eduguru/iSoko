//
//  SplashScreenViewModel.swift
//  
//
//  Created by Edwin Weru on 21/10/2025.
//

import DesignSystemKit
import UIKit
import UtilsKit

final class SplashScreenViewModel: FormViewModel {
    var goToConfirm: (() -> Void)? = { }

    private var state: State?

    override init() {
        self.state = State()
        super.init()
        
        self.sections = makeSections()
    }

    // MARK: - make sections

    private func makeSections() -> [FormSection] {
        return [ ]
    }


    // MARK: - State

    private struct State {
    }

    // MARK: - Tags

}
