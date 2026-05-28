//
//  ProfileEditViewController.swift
//  
//
//  Created by Edwin Weru on 11/11/2025.
//

import UIKit
import DesignSystemKit
import UtilsKit

class ProfileEditViewController: FormViewController, CloseableViewController {
    var makeRoot: Bool = false
    
    private let pickerCoordinator = FilePickerBottomSheetCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile Edit"
        
        if !makeRoot { applyCloseButtonStyling(action: #selector(close), image: "backArrow") }
        
        guard let vm = viewModel as? ProfileEditViewModel else {
            fatalError("Expected ProfileEditViewModel")
        }

        vm.pickFile = { [weak self] completion in
            guard let self else { return }

            self.pickerCoordinator.present(
                from: self,
                selectionLimit: 1,
                allowedTypes: [.pdf, .png, .jpeg]
            ) { pickedFile in
                completion(pickedFile)
            }
        }
        
        
        vm.onPreviewImage = { [weak self] file in
//            guard let data = file.fileData,
//                  let image = UIImage(data: data) else { return }
//
//            let vc = ImagePreviewViewController(image: image)
//            self?.present(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func close() {
        closeAction?()
    }
    
    deinit { }
    
    @objc func didTapButton01() {
        
    }
    
    @objc func didTapButton02() {
        
    }
}


