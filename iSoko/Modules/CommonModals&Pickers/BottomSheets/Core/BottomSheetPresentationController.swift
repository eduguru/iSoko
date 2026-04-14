
//
//  BottomSheetPresentationController.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public final class BottomSheetPresentationController: UIPresentationController {

    private let dimmingView = UIView()
    private let style: BottomSheetModel.Style

    public init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        style: BottomSheetModel.Style
    ) {
        self.style = style
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: - Presentation

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        dimmingView.alpha = 0
        dimmingView.frame = containerView.bounds
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        )

        containerView.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        })
    }

    override public func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }

    @objc private func dismissSheet() {
        presentedViewController.dismiss(animated: true)
    }

    // MARK: - Layout

    override public var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let bounds = containerView.bounds
        let height: CGFloat = style == .floating ? 260 : 220

        let horizontalInset: CGFloat = style == .floating ? 16 : 0
        let width = bounds.width - (horizontalInset * 2)

        return CGRect(
            x: horizontalInset,
            y: bounds.height - height,
            width: width,
            height: height
        )
    }

    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
