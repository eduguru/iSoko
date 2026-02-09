//
//  DatePickerViewController.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

// DatePickerViewController.swift
final class DatePickerViewController: UIViewController {

    var viewModel: DatePickerViewModel!
    var closeAction: (() -> Void)?

    private let datePicker = UIDatePicker()
    private var monthYearPicker: MonthYearPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        setupHeader()
        setupPicker()
    }

    private func setupHeader() {
        let cancel = UIButton(type: .system)
        cancel.setTitle("Cancel", for: .normal)
        cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let confirm = UIButton(type: .system)
        confirm.setTitle("Confirm", for: .normal)
        confirm.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [cancel, UIView(), confirm])
        stack.axis = .horizontal
        stack.alignment = .center

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupPicker() {
        switch viewModel.config.mode {

        case .year:
            setupSystemDatePicker()
            viewModel.selectedDate = datePicker.date.yearOnlyNormalized
            datePicker.addTarget(self, action: #selector(yearChanged), for: .valueChanged)

        case .fullDate:
            setupSystemDatePicker()
            datePicker.addTarget(self, action: #selector(fullDateChanged), for: .valueChanged)

        case .monthYear:
            setupMonthYearPicker()
        }
    }

    private func setupSystemDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = viewModel.config.minimumDate
        datePicker.maximumDate = viewModel.config.maximumDate
        datePicker.date = viewModel.selectedDate

        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupMonthYearPicker() {
        let picker = MonthYearPickerView(
            minDate: viewModel.config.minimumDate,
            maxDate: viewModel.config.maximumDate,
            initialDate: viewModel.config.initialDate
        )

        picker.onChange = { [weak self] date in
            self?.viewModel.selectedDate = date
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

    @objc private func yearChanged() {
        viewModel.selectedDate = datePicker.date.yearOnlyNormalized
    }

    @objc private func fullDateChanged() {
        viewModel.selectedDate = datePicker.date
    }

    @objc private func confirmTapped() {
        viewModel.onConfirm?(viewModel.selectedDate)
    }

    @objc private func cancelTapped() {
        closeAction?()
    }
}
