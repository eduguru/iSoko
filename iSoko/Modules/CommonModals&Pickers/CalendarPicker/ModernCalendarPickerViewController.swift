//
//  ModernCalendarPickerViewController.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

@available(iOS 16.0, *)
final class ModernCalendarPickerViewController: UIViewController, CalendarPicking {

    var onConfirm: ((Date?) -> Void)?
    var onCancel: (() -> Void)?

    private let header = PickerHeaderView()
    private let calendarView = UICalendarView()

    private var viewModel: CalendarPickerViewModel!
    private var mode: CalendarPickerMode = .fullDate

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

        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)

        view.addSubview(header)
        view.addSubview(calendarView)

        header.translatesAutoresizingMaskIntoConstraints = false
        calendarView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),

            calendarView.topAnchor.constraint(equalTo: header.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

@available(iOS 16.0, *)
extension ModernCalendarPickerViewController: UICalendarSelectionSingleDateDelegate {

    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        guard let components = dateComponents,
              let date = Calendar.current.date(from: components) else { return }

        viewModel.selectedDate = date
    }
}
