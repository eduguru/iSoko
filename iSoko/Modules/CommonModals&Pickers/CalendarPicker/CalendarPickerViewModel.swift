//
//  CalendarPickerViewModel.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import Foundation

final class CalendarPickerViewModel {

    let mode: CalendarPickerMode
    let minDate: Date?
    let maxDate: Date?

    var selectedDate: Date? {
        didSet { onSelectionChange?(selectedDate) }
    }

    var onConfirm: ((Date?) -> Void)?
    var onSelectionChange: ((Date?) -> Void)?

    init(
        mode: CalendarPickerMode,
        minDate: Date?,
        maxDate: Date?,
        initialDate: Date?
    ) {
        self.mode = mode
        self.minDate = minDate
        self.maxDate = maxDate
        self.selectedDate = initialDate
    }

    func normalizedDate() -> Date? {
        guard let date = selectedDate else { return nil }

        switch mode {
        case .year:
            return .from(year: date.yearComponent)
        case .monthYear:
            return .from(year: date.yearComponent, month: date.monthComponent)
        case .fullDate:
            return date
        }
    }
}
