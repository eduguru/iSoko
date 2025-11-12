//
//  MoreViewController.swift
//  iSoko
//
//  Created by Edwin Weru on 28/07/2025.
//

import UIKit
import DesignSystemKit

class MoreViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Account"
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
}

