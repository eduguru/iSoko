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

    private let filePicker = FilePickerHelper()
    private var uploadRow: UploadFormRow!

    var makeRoot: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Cast here
        guard let vm = viewModel as? CompleteNewTradeAssociationViewModel else {
            fatalError("Expected CompleteNewTradeAssociationViewModel")
        }

        uploadRow = vm.uploadCertificateRow

        vm.pickFile = { [weak self] completion in
            guard let self else { return }

            self.filePicker.presentPicker(
                from: self,
                source: .documents,
                selectionLimit: 1,
                allowedTypes: [.pdf, .png, .jpeg, .jpeg],
                completion: { result in
                    switch result {
                    case .success(let files):
                        completion(files.first)
                    case .failure:
                        completion(nil)
                    }
                }
            )
        }
    }

    @objc func close() {
        closeAction?()
    }
}
