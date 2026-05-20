//
//  AddBookKeepingCustomersViewController.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import UIKit
import DesignSystemKit

class AddBookKeepingCustomersViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "bookkeeping.add_customer.add_button".localized
        // Do any additional setup after loading the view.
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
