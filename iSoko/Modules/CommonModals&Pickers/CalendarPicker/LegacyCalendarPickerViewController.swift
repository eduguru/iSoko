//
//  LegacyCalendarPickerViewController.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import FSCalendar

final class LegacyCalendarPickerViewController: UIViewController, CalendarPicking {

    var onConfirm: ((Date?) -> Void)?
    var onCancel: (() -> Void)?

    private let header = PickerHeaderView()
    private let calendar = FSCalendar()

    private var viewModel: CalendarPickerViewModel!
    private var mode: CalendarPickerMode = .fullDate
    private var calendarHeightConstraint: NSLayoutConstraint!

    func configure(
        mode: CalendarPickerMode,
        minDate: Date?,
        maxDate: Date?,
        initialDate: Date?
    ) {
        self.mode = mode
        self.viewModel = CalendarPickerViewModel(
            mode: mode,
            minDate: minDate,
            maxDate: maxDate,
            initialDate: initialDate
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        calendar.delegate = self
        calendar.dataSource = self
        calendar.scrollDirection = .horizontal

        // FIX: prevent auto resize
        calendar.scope = .month
        calendar.placeholderType = .none

        view.addSubview(header)
        view.addSubview(calendar)

        header.translatesAutoresizingMaskIntoConstraints = false
        calendar.translatesAutoresizingMaskIntoConstraints = false

        calendarHeightConstraint = calendar.heightAnchor.constraint(equalToConstant: 350)
        calendarHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),

            calendar.topAnchor.constraint(equalTo: header.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bind() {
        header.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        header.confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        viewModel.onSelectionChange = { [weak self] _ in
            self?.header.confirmButton.isEnabled = true
        }
    }

    @objc private func confirmTapped() {
        onConfirm?(viewModel.normalizedDate())
    }

    @objc private func cancelTapped() {
        onCancel?()
    }
}

extension LegacyCalendarPickerViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {

        switch mode {

        case .year:
            // Select the first day of that year
            let newDate = Date.from(year: date.yearComponent)
            viewModel.selectedDate = newDate
            calendar.select(newDate)

        case .monthYear:
            // Select the first day of that month
            let newDate = Date.from(year: date.yearComponent, month: date.monthComponent)
            viewModel.selectedDate = newDate
            calendar.select(newDate)

        case .fullDate:
            viewModel.selectedDate = date
        }
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        viewModel.minDate ?? .distantPast
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        viewModel.maxDate ?? .distantFuture
    }
}
