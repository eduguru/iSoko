//
//  ServiceDetailsViewController.swift
//  
//
//  Created by Edwin Weru on 31/10/2025.
//

import UIKit
import DesignSystemKit

class ServiceDetailsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Service Details"
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
