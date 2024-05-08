//
//  PaymentBottomSheetVCSection.swift
//  SDKForms
//
// 
//

import Foundation

enum PaymentBottomSheetVCSectionType {
    
    case applePay
    case cards
}

struct PaymentBottomSheetVCSection {
    
    let type: PaymentBottomSheetVCSectionType
    
    let header: AnyHashable?
    let footer: AnyHashable?
    
    let items: [AnyHashable]
    
    init(
        type: PaymentBottomSheetVCSectionType,
        header: AnyHashable? = nil,
        footer: AnyHashable? = nil,
        items: [AnyHashable]
    ) {
        self.type = type
        self.header = header
        self.footer = footer
        self.items = items
    }
}
