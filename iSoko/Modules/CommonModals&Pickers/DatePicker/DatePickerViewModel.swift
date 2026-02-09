//
//  DatePickerViewModel.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import Foundation

// DatePickerViewModel.swift
final class DatePickerViewModel {

    let config: DatePickerConfig
    var selectedDate: Date
    var onConfirm: ((Date?) -> Void)?

    init(config: DatePickerConfig) {
        self.config = config
        self.selectedDate = config.initialDate ?? Date()
    }
}
