//
//  CardListVCSection.swift
//  SDKForms
//
// 
//

import Foundation

enum CardListVCSectionType {
    
    case cards
}

struct CardListVCSection {
    
    let type: CardListVCSectionType
    
    let header: AnyHashable?
    let footer: AnyHashable?
    
    var items: [AnyHashable]
    
    init(
        type: CardListVCSectionType,
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
