//
//  CalendarPicking.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

protocol CalendarPicking: UIViewController {
    var onConfirm: ((Date?) -> Void)? { get set }
    var onCancel: (() -> Void)? { get set }

    func configure(
        mode: CalendarPickerMode,
        minDate: Date?,
        maxDate: Date?,
        initialDate: Date?
    )
}


enum CalendarPickerFactory {

    static func makePicker() -> CalendarPicking {

        if #available(iOS 16.0, *) {
            return ModernCalendarPickerViewController()
        } else {
            return LegacyCalendarPickerViewController()
        }
    }
}
