//
//  DatePickerConfig.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import Foundation

// DatePickerConfig.swift
struct DatePickerConfig {
    let mode: DatePickerMode
    let minimumDate: Date?
    let maximumDate: Date?
    let initialDate: Date?

    static func year(
        min: Date? = nil,
        max: Date? = Date(),
        initial: Date? = nil
    ) -> DatePickerConfig {
        .init(mode: .year, minimumDate: min, maximumDate: max, initialDate: initial)
    }

    static func monthYear(
        min: Date? = nil,
        max: Date? = Date(),
        initial: Date? = nil
    ) -> DatePickerConfig {
        .init(mode: .monthYear, minimumDate: min, maximumDate: max, initialDate: initial)
    }

    static func fullDate(
        min: Date? = nil,
        max: Date? = nil,
        initial: Date? = nil
    ) -> DatePickerConfig {
        .init(mode: .fullDate, minimumDate: min, maximumDate: max, initialDate: initial)
    }
}


// Date+Picker.swift
extension Date {

    static func from(year: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year))!
    }

    static func from(year: Int, month: Int) -> Date {
        Calendar.current.date(
            from: DateComponents(year: year, month: month, day: 1)
        )!
    }

    var yearOnlyNormalized: Date {
        Date.from(year: Calendar.current.component(.year, from: self))
    }

    var yearComponent: Int {
        Calendar.current.component(.year, from: self)
    }

    var monthComponent: Int {
        Calendar.current.component(.month, from: self)
    }
}
