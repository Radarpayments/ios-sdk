//
//  File.swift
//  

import Foundation

enum OrderPayerDataFields: String {
    
    case MOBILE_PHONE
    
    init?(stringValue: String) {
        if let targetCase = OrderPayerDataFields(rawValue: stringValue) {
            self = targetCase
            return
        }
        return nil
    }
}
