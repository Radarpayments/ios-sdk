//
//  CardDataTextFieldViewConfig.swift
//  SDKForms
//
// 
//

import Foundation

struct CardDataTextFieldViewState {
    
    let placeholder: String
    var text: String? = nil
    let pattern: CardDataTextFieldStringPattern
    var errorMessage = ""
    
    var hideleftImageView = true
    var isSecureInput = false
    var inputIsAvailable = true
}
