//
//  ServiceListingsViewController.swift
//  
//
//  Created by Edwin Weru on 28/10/2025.
//

import UIKit
import DesignSystemKit

class ServiceListingsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Market Place"
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
    
    @objc func didTapButton01() {
        
    }
    
    @objc func didTapButton02() {
        
    }
}
