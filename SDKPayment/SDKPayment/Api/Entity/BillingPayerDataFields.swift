//
//  File.swift
//  

import Foundation

enum BillingPayerDataFields: String, CaseIterable {
    
    case MOBILE_PHONE
    case EMAIL
    case BILLING_COUNTRY
    case BILLING_STATE
    case BILLING_POSTAL_CODE
    case BILLING_CITY
    case BILLING_ADDRESS_LINE1
    case BILLING_ADDRESS_LINE2
    case BILLING_ADDRESS_LINE3
    
    init?(stringValue: String) {
        if let targetCase = BillingPayerDataFields(rawValue: stringValue) {
            self = targetCase
            return
        }
        
        return nil
    }
}
