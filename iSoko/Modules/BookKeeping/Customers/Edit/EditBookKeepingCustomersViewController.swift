//
//  EditBookKeepingCustomersViewController.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//

import UIKit
import DesignSystemKit

class EditBookKeepingCustomersViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Customer"
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
