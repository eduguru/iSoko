//
//  DatePickerConfig.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit


public struct DatePickerConfig {
    public let mode: DatePickerMode
    public let minimumDate: Date?
    public let maximumDate: Date?
    public let initialDate: Date?

    static func year(min: Date? = nil, max: Date? = Date(), initial: Date? = nil) -> DatePickerConfig {
        .init(mode: .year, minimumDate: min, maximumDate: max, initialDate: initial)
    }

    static func monthYear(min: Date? = nil, max: Date? = Date(), initial: Date? = nil) -> DatePickerConfig {
        .init(mode: .monthYear, minimumDate: min, maximumDate: max, initialDate: initial)
    }

    static func fullDate(min: Date? = nil, max: Date? = nil, initial: Date? = nil) -> DatePickerConfig {
        .init(mode: .fullDate, minimumDate: min, maximumDate: max, initialDate: initial)
    }
}
