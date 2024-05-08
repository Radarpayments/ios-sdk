//
//  CardNumberFormatter.swift
//  SDKForms
//
// 
//

import Foundation
import SDKCore

final class CardNumberFormatter {
    
    private let PAN_LAST_DIGITS_COUNT = 4
    
    func maskCardNumber(pan: String) -> String {
        let clearPan = pan.digitsOnly()
        
        let number = clearPan.count >= PAN_LAST_DIGITS_COUNT
            ? String(clearPan.suffix(PAN_LAST_DIGITS_COUNT))
            : pan
        
        return "**\(number)"
    }
}
