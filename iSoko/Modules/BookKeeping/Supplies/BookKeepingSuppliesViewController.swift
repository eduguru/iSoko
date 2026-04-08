//
//  BookKeepingSuppliesViewController.swift
//  
//
//  Created by Edwin Weru on 20/01/2026.
//

import UIKit
import DesignSystemKit

class BookKeepingSuppliesViewController: FormViewController, CloseableViewController {
    
    var goToCreateAction: (() -> Void)?
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Supplies"
        
        if !makeRoot {
            applyCloseButtonStyling(action: #selector(close), image: "backArrow")
        }
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let createItem = UIBarButtonItem(
            title: "Create",
            style: .plain,
            target: self,
            action: #selector(didTapCreate)
        )
        
        // Optional: make it slightly stronger (closer to your semibold look)
        createItem.setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        
        navigationItem.rightBarButtonItem = createItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    @objc private func close() {
        closeAction?()
    }
    
    @objc private func didTapCreate() {
        goToCreateAction?()
    }
    
    deinit { }
}
