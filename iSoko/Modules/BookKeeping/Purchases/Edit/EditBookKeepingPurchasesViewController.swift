//
//  EditBookKeepingPurchasesViewController.swift
//  
//
//  Created by Edwin Weru on 18/02/2026.
//


import UIKit
import DesignSystemKit

class EditBookKeepingPurchasesViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Purchases"
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
