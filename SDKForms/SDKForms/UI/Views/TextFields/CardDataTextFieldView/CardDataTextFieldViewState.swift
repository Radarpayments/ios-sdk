//
//  CardDataTextFieldViewConfig.swift
//  SDKForms
//
// 
//

import Foundation

struct CardDataTextFieldViewState {
    
    let id: String
    let placeholder: String
    var text: String? = nil
    let pattern: CardDataTextFieldStringPattern
    var errorMessage = ""
    
    var hideleftImageView = true
    var isSecureInput = false
    var inputIsAvailable = true
    var isFilled = false
    
    var textFieldViewTextDidChange: ((_ inputView: InputView) -> Void)?
    var textFieldDoneButtonHandler: ((_ inputView: InputView) -> Void)?
}
