
//
//  BottomSheetPresentationController.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public final class BottomSheetPresentationController: UIPresentationController, UIGestureRecognizerDelegate {

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

    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        dimmingView.alpha = 0
        dimmingView.frame = containerView.bounds
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        tap.delegate = self
        dimmingView.addGestureRecognizer(tap)

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

    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let presentedView = presentedView else { return true }
        let location = touch.location(in: containerView)
        return !presentedView.frame.contains(location)
    }

    // MARK: - Layout

    override public var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }

        let bounds = containerView.bounds
        let horizontalInset: CGFloat = style == .floating ? 16 : 0
        let width = bounds.width - (horizontalInset * 2)

        // Use the full available height as a ceiling; Auto Layout inside the
        // presented view will determine the actual rendered height via its
        // bottomAnchor ≤ safeArea constraint. We just need the frame to be
        // at least as tall as the content — so give it everything from the
        // top safe area down. Touches then land correctly on every row.
        let availableHeight = bounds.height - containerView.safeAreaInsets.top

        return CGRect(
            x: horizontalInset,
            y: bounds.height - availableHeight,
            width: width,
            height: availableHeight
        )
    }

    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
