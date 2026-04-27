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
    private let imageView = UIImageView()
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
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupContent()
        buildButtons()
    }

    // MARK: - Content

    private func setupContent() {

        // IMAGE
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false

        if let icon = model.icon {
            imageView.image = icon
            imageView.isHidden = false
        } else {
            imageView.isHidden = true
        }

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

        // CLOSE BUTTON
        closeButton.setTitle("✕", for: .normal)
        closeButton.isHidden = !model.showCloseButton
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        // STACK
        let stack = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            messageLabel,
            buttonStack
        ])

        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .fill   // ✅ FIXED (was .center)
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        container.addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        applyStateStyle()

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: model.icon == nil ? 0 : 64),
            imageView.widthAnchor.constraint(equalToConstant: model.icon == nil ? 0 : 64),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -24),

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
            imageView.tintColor = .systemGreen

        case .error:
            titleLabel.textColor = .systemRed
            imageView.tintColor = .systemRed

        case .normal:
            titleLabel.textColor = .label
            imageView.tintColor = .label
        }
    }

    // MARK: - Buttons

    private func buildButtons() {

        let isSingle = model.buttons.count == 1

        buttonStack.axis = isSingle ? .vertical : .horizontal
        buttonStack.spacing = 12
        buttonStack.alignment = .fill       // ✅ CRITICAL FIX
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

            button.addAction(UIAction { _ in
                self.dismiss(animated: true) {
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

// MARK: - Transitioning

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
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0
            self.container.transform = CGAffineTransform(translationX: 0, y: 20)
        }) { _ in
            super.dismiss(animated: false, completion: completion)
        }
    }
}


//    private func buildButtons() {
//
//        buttonStack.axis = model.buttons.count == 1 ? .vertical : .horizontal
//        buttonStack.spacing = 12
//        buttonStack.distribution = .fillEqually
//
//        model.buttons.prefix(2).forEach { btnModel in
//
//            let button = UIButton(type: .system)
//            button.setTitle(btnModel.title, for: .normal)
//            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
//            button.layer.cornerRadius = 14
//            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//            switch btnModel.style {
//            case .primary:
//                button.backgroundColor = .app(.primary)
//                button.setTitleColor(.white, for: .normal)
//            case .secondary:
//                button.backgroundColor = .secondarySystemBackground
//                button.setTitleColor(.label, for: .normal)
//            }
//
//            button.addAction(UIAction { _ in
//                self.dismiss(animated: true) {
//                    btnModel.action()
//                }
//            }, for: .touchUpInside)
//
//            buttonStack.addArrangedSubview(button)
//        }
//    }
    
