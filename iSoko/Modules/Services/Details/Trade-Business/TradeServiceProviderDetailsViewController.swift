//
//  TradeServiceProviderDetailsViewController.swift
//  
//
//  Created by Edwin Weru on 22/03/2026.
//

import UIKit
import DesignSystemKit

class TradeServiceProviderDetailsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Details"
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit {
    }
}
