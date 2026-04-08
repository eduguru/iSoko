//
//  MonthYearPickerView.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

final class MonthYearPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    private let pickerView = UIPickerView()
    private let months = Calendar.current.monthSymbols
    private let years: [Int]

    private var selectedMonth: Int
    private var selectedYear: Int

    var onChange: ((Date) -> Void)?

    init(minDate: Date?, maxDate: Date?, initialDate: Date?) {
        let minYear = minDate?.yearComponent ?? 1900
        let maxYear = maxDate?.yearComponent ?? Calendar.current.component(.year, from: Date())
        self.years = Array(minYear...maxYear)

        let initial = initialDate ?? Date()
        self.selectedMonth = initial.monthComponent
        self.selectedYear = initial.yearComponent

        super.init(frame: .zero)

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        addSubview(pickerView)

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        pickerView.selectRow(selectedMonth - 1, inComponent: 0, animated: false)
        pickerView.selectRow(years.firstIndex(of: selectedYear) ?? 0, inComponent: 1, animated: false)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? months.count : years.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        component == 0 ? months[row] : String(years[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { selectedMonth = row + 1 }
        else { selectedYear = years[row] }
        onChange?(Date.from(year: selectedYear, month: selectedMonth))
    }
}
