//
//  YearPickerView.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

final class YearPickerView: UIView {

    private let picker = UIPickerView()
    private let years: [Int]

    var onChange: ((Date) -> Void)?

    init(min: Int = 1900, max: Int = Calendar.current.component(.year, from: Date())) {
        self.years = Array(min...max)
        super.init(frame: .zero)

        picker.dataSource = self
        picker.delegate = self
        addSubview(picker)
    }

    required init?(coder: NSCoder) { fatalError() }
}

extension YearPickerView: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        years.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        String(years[row])
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        onChange?(Date.from(year: years[row]))
    }
}
