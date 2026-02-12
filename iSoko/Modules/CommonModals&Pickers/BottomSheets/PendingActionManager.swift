//
//  PendingActionManager.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

final class PendingActionManager {
    static let shared = PendingActionManager()
    private init() {}

    private var pendingAction: (() -> Void)?

    func set(_ action: @escaping () -> Void) {
        pendingAction = action
    }

    func execute() {
        pendingAction?()
        pendingAction = nil
    }

    func clear() {
        pendingAction = nil
    }
}


