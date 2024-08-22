//
//  SelectedCardVCSection.swift
//  SDKForms
//
// 
//

import Foundation

enum SelectedCardVCSectionType {
    
    case cardInfo
    case mandatoryFields
    case actions
}

struct SelectedCardVCSection {
    
    var type: SelectedCardVCSectionType
    
    var header: AnyHashable?
    var footer: AnyHashable?
    
    var items: [AnyHashable]
    
    init(
        type: SelectedCardVCSectionType,
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
