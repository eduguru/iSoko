//
//  BottomSheetCoordinator.swift
//  
//
//  Created by Edwin Weru on 12/02/2026.
//

import UIKit

public final class BottomSheetCoordinator {

    private weak var presenter: UIViewController?

    public init(presenter: UIViewController) {
        self.presenter = presenter
    }

    public func present(_ model: BottomSheetModel) {
        guard let presenter = presenter else { return }
        let vc = BottomSheetViewController(model: model)
        presenter.present(vc, animated: true)
    }
}
