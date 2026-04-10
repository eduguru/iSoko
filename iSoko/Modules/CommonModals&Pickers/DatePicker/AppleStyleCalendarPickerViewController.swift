//
//  AppleStyleCalendarPickerViewController.swift
//
//
//  Created by Edwin Weru on 08/04/2026.
//

import UIKit
import FSCalendar

final class AppleStyleCalendarPickerViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    // MARK: - Public
    var config: DatePickerConfig!
    var onComplete: ((Date?) -> Void)?

    // MARK: - Private
    private let calendar = FSCalendar()
    private var selectedDate: Date?
    private let headerButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigation()
        setupHeader()
        setupCalendar()
    }

    // MARK: - Setup Navigation
    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(doneTapped))
    }

    // MARK: - Custom Header
    private func setupHeader() {
        headerButton.setTitle("Select Date", for: .normal)
        headerButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        headerButton.addTarget(self, action: #selector(didTapHeader), for: .touchUpInside)
        view.addSubview(headerButton)
        headerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Calendar Setup
    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)

        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: headerButton.bottomAnchor, constant: 8),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Styling
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.weekdayTextColor = .secondaryLabel
        calendar.appearance.todayColor = .app(.primary)
        calendar.appearance.selectionColor = .systemGreen
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.borderRadius = 0.3

        // Dates
        selectedDate = config.initialDate
        calendar.select(selectedDate)

        // Set initial page
        if let initial = config.initialDate {
            calendar.setCurrentPage(initial, animated: false)
        } else if let min = config.minimumDate {
            calendar.setCurrentPage(min, animated: false)
        }
    }

    // MARK: - FSCalendar DataSource
    func minimumDate(for calendar: FSCalendar) -> Date {
        config.minimumDate ?? Date(timeIntervalSince1970: 0)
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        config.maximumDate ?? Date()
    }

    // MARK: - FSCalendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        updateHeaderTitle(date: date)
    }

    private func updateHeaderTitle(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        headerButton.setTitle(formatter.string(from: date), for: .normal)
    }

    // MARK: - Actions
    @objc private func doneTapped() {
        onComplete?(selectedDate)
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        onComplete?(nil)
        dismiss(animated: true)
    }

    // MARK: - Header Tap: Show Year / Month-Year Picker
    @objc private func didTapHeader() {
        let pickerVC = YearMonthPickerModalViewController()
        let currentYear = Calendar.current.component(.year, from: selectedDate ?? Date())
        let currentMonth = Calendar.current.component(.month, from: selectedDate ?? Date())
        pickerVC.selectedYear = currentYear
        pickerVC.selectedMonth = currentMonth
        pickerVC.onSelect = { [weak self] date in
            guard let self = self else { return }
            self.calendar.setCurrentPage(date, animated: true)
            self.calendar.select(date)
            self.selectedDate = date
            self.updateHeaderTitle(date: date)
        }
        present(UINavigationController(rootViewController: pickerVC), animated: true)
    }
}

// MARK: - Year/Month Picker Modal
final class YearMonthPickerModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var onSelect: ((Date) -> Void)?
    var selectedYear: Int?
    var selectedMonth: Int?

    private let picker = UIPickerView()
    private var years: [Int] = []
    private var months: [String] = Calendar.current.monthSymbols

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Select Month & Year"
        setupYears()
        setupPicker()
        setupNavigation()
    }

    private func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                           target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done,
                                                            target: self, action: #selector(doneTapped))
    }

    private func setupYears() {
        let currentYear = Calendar.current.component(.year, from: Date())
        years = Array(1900...currentYear)
    }

    private func setupPicker() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        view.addSubview(picker)

        NSLayoutConstraint.activate([
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let selected = selectedYear, let index = years.firstIndex(of: selected) {
            picker.selectRow(index, inComponent: 1, animated: false)
        }
        if let month = selectedMonth {
            picker.selectRow(month - 1, inComponent: 0, animated: false)
        }
    }

    @objc private func doneTapped() {
        let month = picker.selectedRow(inComponent: 0) + 1
        let year = years[picker.selectedRow(inComponent: 1)]
        let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        onSelect?(date)
        dismiss(animated: true)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    // MARK: - UIPickerView DataSource/Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 } // Month + Year
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? months.count : years.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        component == 0 ? months[row] : "\(years[row])"
    }
}
