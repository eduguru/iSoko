//
//  OrganisationListingsViewController.swift
//  
//
//  Created by Edwin Weru on 01/10/2025.
//

import UIKit
import DesignSystemKit

class OrganisationListingsViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    var goToCreateAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        goToCreateAction?()
    }
}
