//
//  AllTradeAssociationViewController.swift
//  
//
//  Created by Edwin Weru on 21/07/2026.
//

import UIKit
import DesignSystemKit

class AllTradeAssociationViewController: FormViewController, CloseableViewController {
    var goToCreateAction: (() -> Void)?
    var makeRoot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trade Associations"
        
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
        
        let btn01 = UIButton(type: .system) //use .system for automatic tint/color handling
        btn01.setTitle("Create", for: .normal)
        btn01.setTitleColor(.app(.primary), for: .normal) //set an explicit color (or .label for adaptive)
        btn01.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        btn01.addTarget(self, action: #selector(didTapButton01), for: .touchUpInside)

        btn01.sizeToFit()

        
        let actionButton01 = UIBarButtonItem(customView: btn01)
        // navigationItem.rightBarButtonItem = actionButton01
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
    
    @objc func didTapButton01() {
        goToCreateAction?()
    }
}


