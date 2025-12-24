//
//  BindingCardTableModel.swift
//  SDKPayment
//
// 
//

import UIKit

public struct BindingCardTableModel: Hashable {
    
    let id: String
    let cardSystemImageName: String?
    let cardNumberText: String
    let cardExpiryText: String
}
