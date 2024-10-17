//
//  NewCardVCSection.swift
//  SDKForms
//
// 
//

import Foundation

enum NewCardVCSectionType {
    
    case logo
    case cardInfo
}

struct NewCardVCSection {
    
    let type: NewCardVCSectionType
    
    var header: AnyHashable?
    var footer: AnyHashable?
    
    var items: [AnyHashable]
    
    init(
        type: NewCardVCSectionType,
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
