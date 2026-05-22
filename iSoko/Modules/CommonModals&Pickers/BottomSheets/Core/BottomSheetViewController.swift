//
//  BottomSheetViewController.swift
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

// MARK: - BottomSheetViewController

public final class BottomSheetViewController: UIViewController {

    private var model: BottomSheetModel

    private let container      = UIView()
    private let imageView      = UIImageView()
    private let titleLabel     = UILabel()
    private let messageLabel   = UILabel()
    private let closeButton    = UIButton(type: .system)
    private let buttonStack    = UIStackView()
    private let itemsStack     = UIStackView()
    private let mainStack      = UIStackView()   // owns the full vertical layout

    // MARK: - Init

    public init(model: BottomSheetModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = model.style == .floating ? 18 : 14
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupContent()
    }

    // MARK: - Content

    private func setupContent() {

        // IMAGE
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = model.icon
        imageView.isHidden = model.icon == nil

        // TITLE
        titleLabel.text = model.title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        // MESSAGE
        if let message = model.message {
            messageLabel.text = message
            messageLabel.font = .systemFont(ofSize: 15)
            messageLabel.textColor = .secondaryLabel
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
        } else {
            messageLabel.isHidden = true
        }

        // CLOSE — use a wrapper that doesn't block touches outside its own bounds
        closeButton.setTitle("✕", for: .normal)
        closeButton.isHidden = !model.showCloseButton
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        applyStateStyle()

        // ITEMS (radio list)
        buildItems()

        // BUTTONS
        buildButtons()

        // MAIN STACK — single source of vertical layout truth
        mainStack.axis = .vertical
        mainStack.spacing = 14
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        mainStack.addArrangedSubview(imageView)
        mainStack.addArrangedSubview(titleLabel)
        if !messageLabel.isHidden { mainStack.addArrangedSubview(messageLabel) }
        if !itemsStack.arrangedSubviews.isEmpty { mainStack.addArrangedSubview(itemsStack) }
        if !buttonStack.arrangedSubviews.isEmpty { mainStack.addArrangedSubview(buttonStack) }

        container.addSubview(mainStack)
        container.addSubview(closeButton)
        container.bringSubviewToFront(closeButton)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: model.icon == nil ? 0 : 64),
            imageView.widthAnchor.constraint(equalToConstant: model.icon == nil ? 0 : 64),

            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - State Styling

    private func applyStateStyle() {
        switch model.state {
        case .success:
            titleLabel.textColor = .systemGreen
            imageView.tintColor  = .systemGreen
        case .error:
            titleLabel.textColor = .systemRed
            imageView.tintColor  = .systemRed
        case .normal:
            titleLabel.textColor = .label
            imageView.tintColor  = .label
        }
    }

    // MARK: - Items

    private func buildItems() {
        guard let items = model.items, !items.isEmpty else { return }

        itemsStack.axis      = .vertical
        itemsStack.spacing   = 10
        itemsStack.alignment = .fill

        for (index, item) in items.enumerated() {
            let row = RadioRowView(item: item)
            row.tag = index
            row.onTap = { [weak self] in self?.selectItem(at: index) }
            itemsStack.addArrangedSubview(row)
        }
    }

    private func selectItem(at index: Int) {
        guard var items = model.items else { return }

        for i in items.indices { items[i].isSelected = (i == index) }
        model.items = items

        for (i, view) in itemsStack.arrangedSubviews.enumerated() {
            (view as? RadioRowView)?.setSelected(i == index)
        }

        model.onItemSelected?(items[index])
    }

    // MARK: - Buttons

    private func buildButtons() {
        guard !model.buttons.isEmpty else { return }

        let isSingle = model.buttons.count == 1
        buttonStack.axis         = isSingle ? .vertical : .horizontal
        buttonStack.spacing      = 12
        buttonStack.alignment    = .fill
        buttonStack.distribution = .fillEqually

        model.buttons.prefix(2).forEach { btnModel in
            let button = UIButton(type: .system)
            button.setTitle(btnModel.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.layer.cornerRadius = 14
            button.clipsToBounds = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true

            switch btnModel.style {
            case .primary:
                button.backgroundColor = .app(.primary)
                button.setTitleColor(.white, for: .normal)
            case .secondary:
                button.backgroundColor = .secondarySystemBackground
                button.setTitleColor(.label, for: .normal)
            }

            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                if btnModel.shouldDismiss {
                    self.dismiss(animated: true) { btnModel.action() }
                } else {
                    btnModel.action()
                }
            }, for: .touchUpInside)

            buttonStack.addArrangedSubview(button)
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

// MARK: - RadioRowView

private final class RadioRowView: UIView {

    var onTap: (() -> Void)?

    private let titleLabel = UILabel()
    private let radioIcon  = UIImageView()

    init(item: BottomSheetModel.BottomSheetItem) {
        super.init(frame: .zero)
        setup(item: item)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup(item: BottomSheetModel.BottomSheetItem) {
        layer.cornerRadius = 12
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Title
        titleLabel.text = item.title
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Radio icon
        radioIcon.contentMode = .scaleAspectFit
        radioIcon.tintColor = .label
        radioIcon.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(radioIcon)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: radioIcon.leadingAnchor, constant: -8),

            radioIcon.widthAnchor.constraint(equalToConstant: 22),
            radioIcon.heightAnchor.constraint(equalToConstant: 22),
            radioIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            radioIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        setSelected(item.isSelected)

        // Full-size invisible button — UIButton touch handling beats any gesture recogniser
        // conflict and works correctly at every index position including 0.
        let tapButton = UIButton(type: .system)
        tapButton.backgroundColor = .clear
        tapButton.setTitle(nil, for: .normal)
        tapButton.translatesAutoresizingMaskIntoConstraints = false
        tapButton.addAction(UIAction { [weak self] _ in self?.onTap?() }, for: .touchUpInside)
        addSubview(tapButton)
        NSLayoutConstraint.activate([
            tapButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tapButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            tapButton.topAnchor.constraint(equalTo: topAnchor),
            tapButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setSelected(_ selected: Bool) {
        backgroundColor = selected
            ? UIColor.systemBlue.withAlphaComponent(0.15)
            : UIColor.secondarySystemBackground
        radioIcon.image = UIImage(systemName: selected
            ? "largecircle.fill.circle"
            : "circle")
    }


}

// MARK: - Transitioning

extension BottomSheetViewController: UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            style: model.style
        )
    }

    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
            self.container.transform = CGAffineTransform(translationX: 0, y: 20)
        }) { _ in
            super.dismiss(animated: false, completion: completion)
        }
    }
}

