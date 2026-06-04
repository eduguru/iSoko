//
//  HomeViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import UIKit
import DesignSystemKit
import StorageKit

class HomeViewController: FormViewController, CloseableViewController {

    var makeRoot: Bool = false

    /// Callback to present country picker (VM / coordinator handles it)
    var onCountryTapped: (() -> Void)?

    private var countryButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        if !makeRoot {
            applyCloseButtonStyling(
                action: #selector(close),
                image: "backArrow"
            )
        }

        setupNavigationCountryButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCountryButton()
    }

    // MARK: - Setup Nav Button

    private func setupNavigationCountryButton() {

        let button = makeCountryButton()

        button.addTarget(
            self,
            action: #selector(didTapCountry),
            for: .touchUpInside
        )

        self.countryButton = button

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: button)
        ]
    }

    // MARK: - Button UI (iOS 14 safe)

    private func makeCountryButton() -> UIButton {

        let button = UIButton(type: .system)

        let flagLabel = UILabel()
        flagLabel.text = currentFlag
        flagLabel.font = .systemFont(ofSize: 20)

        let chevron = UIImageView(
            image: UIImage(systemName: "chevron.down")
        )
        chevron.tintColor = .label
        chevron.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [
            flagLabel,
            chevron
        ])

        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.isUserInteractionEnabled = false

        button.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            stack.topAnchor.constraint(equalTo: button.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -6)
        ])

        button.backgroundColor = UIColor.secondarySystemBackground
        button.layer.cornerRadius = 16

        return button
    }

    // MARK: - Actions

    @objc private func didTapCountry() {
        onCountryTapped?()
    }

    @objc func close() {
        closeAction?()
    }

    // MARK: - Refresh UI

    private func refreshCountryButton() {
        guard
            let button = countryButton,
            let stack = button.subviews.first as? UIStackView,
            let flagLabel = stack.arrangedSubviews.first as? UILabel
        else { return }

        flagLabel.text = currentFlag
    }

    // MARK: - Flag

    private var currentFlag: String {
        let code = (AppStorage.selectedRegionCode ?? "rw").uppercased()
        return Locale.flagEmoji(for: code)
    }

    deinit { }
}

extension Locale {

    static func flagEmoji(for countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .compactMap {
                UnicodeScalar(127397 + $0.value)
            }
            .map(String.init)
            .joined()
    }
}
