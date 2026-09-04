//
//  AssociationPublicProductsViewController.swift
//  
//
//  Created by Edwin Weru on 21/07/2026.
//

import UIKit
import DesignSystemKit

class AssociationPublicProductsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    var goToSortOptions: ((_ onSelect: @escaping (ProductSortOption) -> Void) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let sortItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(didTapSort)
        )
        navigationItem.rightBarButtonItem = sortItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func close() { closeAction?() }

    @objc private func didTapSort() {
        goToSortOptions? { [weak self] option in
            (self?.viewModel as? AssociationPublicProductsViewModel)?.applySort(option)
        }
    }

    deinit {}
}
