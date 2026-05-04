//
//  BookKeepingSaleDetailsViewController.swift
//  
//
//  Created by Edwin Weru on 16/02/2026.
//

import UIKit
import DesignSystemKit

class BookKeepingSaleDetailsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sales Details"
        // Do any additional setup after loading the view.
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var goToEditAction: (() -> Void)?
    
    private func setupNavigationBar() {
        let createItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )
        
        // Optional: make it slightly stronger (closer to your semibold look)
        createItem.setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        
        navigationItem.rightBarButtonItem = createItem
    }
    
    @objc private func didTapEdit() {
        guard let model = viewModel as? BookKeepingSaleDetailsViewModel else { return }
        model.goToEditAction()
        
        // goToEditAction?()
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
}
