//
//  DatePickerViewController.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

final class DatePickerViewController: UIViewController {

    // MARK: - Public
    var config: DatePickerConfig!
    var onComplete: ((Date?) -> Void)?

    // MARK: - Private
    private let datePicker = UIDatePicker()
    private var monthYearPicker: MonthYearPickerView?
    private var selectedDate: Date = Date()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupPicker()
    }

    // MARK: - Setup
    private func setupNavigation() {
        title = "Select Date"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneTapped)
        )
    }

    private func setupPicker() {
        selectedDate = config.initialDate ?? Date()

        switch config.mode {
        case .fullDate, .year:
            setupSystemDatePicker()
        case .monthYear:
            setupMonthYearPicker()
        }
    }

    private func setupSystemDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.calendar = Calendar.current
        datePicker.minimumDate = config.minimumDate
        datePicker.maximumDate = config.maximumDate
        datePicker.date = selectedDate

        if config.mode == .year {
            selectedDate = datePicker.date.yearOnlyNormalized
        }

        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupMonthYearPicker() {
        let picker = MonthYearPickerView(
            minDate: config.minimumDate,
            maxDate: config.maximumDate,
            initialDate: config.initialDate
        )

        picker.onChange = { [weak self] date in
            self?.selectedDate = date
        }

        monthYearPicker = picker
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func dateChanged() {
        switch config.mode {
        case .year:
            selectedDate = datePicker.date.yearOnlyNormalized
        case .fullDate:
            selectedDate = datePicker.date
        case .monthYear:
            break
        }
    }

    @objc private func doneTapped() {
        onComplete?(selectedDate)
    }

    @objc private func cancelTapped() {
        onComplete?(nil)
    }
}
