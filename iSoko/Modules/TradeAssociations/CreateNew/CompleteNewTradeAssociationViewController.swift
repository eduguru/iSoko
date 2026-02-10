//
//  CompleteNewTradeAssociationViewController.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit
import DesignSystemKit
import UtilsKit

final class CompleteNewTradeAssociationViewController: FormViewController {

    var makeRoot: Bool = false
    private let pickerCoordinator = FilePickerBottomSheetCoordinator()
    private var uploadRow: UploadFormRow!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let vm = viewModel as? CompleteNewTradeAssociationViewModel else {
            fatalError("Expected CompleteNewTradeAssociationViewModel")
        }

        uploadRow = vm.uploadCertificateRow

        vm.pickFile = { [weak self] completion in
            guard let self else { return }

            self.pickerCoordinator.present(from: self,
                                           selectionLimit: 1,
                                           allowedTypes: [.pdf, .png, .jpeg, .jpeg]) { pickedFile in
                completion(pickedFile)
            }
        }
    }
    
    @objc func close() {
        closeAction?()
    }
}
