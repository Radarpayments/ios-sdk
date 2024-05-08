//
//  Locales.swift
//  SDKForms
//
// 
//

import Foundation

public enum Locales: String, Codable {
    
    case en
    case de
    case fr
    case es
    case ru
    case uk
    
    public init(stringValue: String) {
        if let locale = Locales(rawValue: stringValue) {
            self = locale
            return
        }
        
        self = .en
    }
}
