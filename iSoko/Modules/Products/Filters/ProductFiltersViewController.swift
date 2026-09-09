//
//  ProductFiltersViewController.swift
//  
//
//  Created by Edwin Weru on 04/09/2026.
//

import UIKit
import DesignSystemKit

class ProductFiltersViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filters"
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
    }

    @objc func close() { closeAction?() }
    
    deinit {}
}
