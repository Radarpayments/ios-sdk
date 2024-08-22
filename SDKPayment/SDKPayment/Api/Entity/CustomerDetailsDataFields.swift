//
//  File.swift
//  

import Foundation

enum CustomerDetailsDataFields: String {
    
    case EMAIL
    case PHONE
    
    init?(stringValue: String) {
        if let targetCase = CustomerDetailsDataFields(rawValue: stringValue) {
            self = targetCase
            return
        }
        
        return nil
    }
}
