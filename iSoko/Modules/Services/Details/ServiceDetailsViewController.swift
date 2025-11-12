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
        
        let btn01 = UIButton(type: .custom)
        btn01.setTitle("Create", for: .normal)
        btn01.addTarget(self, action: #selector(didTapButton01), for: .touchUpInside)
        
        let actionButton01 = UIBarButtonItem(customView: btn01)
        
        navigationItem.rightBarButtonItems = [actionButton01]
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
