//
//  BottomSheetViewController.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public final class BottomSheetViewController: UIViewController {

    private let model: BottomSheetModel

    private let container = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let buttonStack = UIStackView()

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
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {

        view.backgroundColor = .clear

        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = model.style == .floating ? 18 : 14
        container.layer.masksToBounds = true

        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupContent()
        buildButtons()
    }

    private func setupContent() {

        titleLabel.text = model.title
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        if let message = model.message {
            messageLabel.text = message
            messageLabel.font = .systemFont(ofSize: 15)
            messageLabel.textColor = .secondaryLabel
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
        } else {
            messageLabel.isHidden = true
        }

        closeButton.setTitle("✕", for: .normal)
        closeButton.isHidden = !model.showCloseButton
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            messageLabel,
            buttonStack
        ])

        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        container.addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func buildButtons() {

        buttonStack.axis = model.buttons.count == 1 ? .vertical : .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually

        model.buttons.prefix(2).forEach { btnModel in

            let button = UIButton(type: .system)
            button.setTitle(btnModel.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.layer.cornerRadius = 14
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true

            switch btnModel.style {
            case .primary:
                button.backgroundColor = .systemBlue
                button.setTitleColor(.white, for: .normal)
            case .secondary:
                button.backgroundColor = .secondarySystemBackground
                button.setTitleColor(.label, for: .normal)
            }

            button.addAction(UIAction { _ in
                self.dismiss(animated: true) {
                    btnModel.action()
                }
            }, for: .touchUpInside)

            buttonStack.addArrangedSubview(button)
        }
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

extension BottomSheetViewController: UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {

        return BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            style: model.style
        )
    }
}
