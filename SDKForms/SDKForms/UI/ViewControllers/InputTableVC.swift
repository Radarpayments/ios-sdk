//
//  InputTableVC.swift
//

import UIKit
import SDKCore

protocol InputTableVC: UIViewController {
    
    var tableView: UITableView { get }
    
    func nextInputView() -> InputView?
}

extension InputTableVC {
    
    func nextInputView() -> InputView? {
        tableView.visibleCells
            .compactMap({ $0 as? InputCell })
            .flatMap({ $0.inputViews })
            .first { !$0.isFilled }
    }
    
    func setActiveNextInputOrEndEditing() {
        if let nextInputView = nextInputView() {
            nextInputView.setActive(true)
            return
        }
        
        view.endEditing(true)
    }
    
    func checkValidation(value: String, validator: BaseValidator<String>) -> ValidationResult {
        validator.validate(data: value)
    }
    
    func setActiveNextInputIfValid(_ validationResult: ValidationResult, activeInput: InputView) {
        if validationResult.isValid {
            activeInput.setFilled(true)
            setActiveNextInputOrEndEditing()
        }
    }
}
