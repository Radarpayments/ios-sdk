//
//  File.swift
//  

import Foundation

struct BillingPayerDataHelper {
    
    private let payerData: BillingPayerData
    
    init(payerData: BillingPayerData) {
        self.payerData = payerData
    }
    
    func value(for field: BillingPayerDataFields) -> String? {
        switch field {
        case .BILLING_COUNTRY:              payerData.billingCountry
        case .BILLING_STATE:                payerData.billingState
        case .BILLING_CITY:                 payerData.billingCity
        case .BILLING_POSTAL_CODE:          payerData.billingPostalCode
        case .BILLING_ADDRESS_LINE1:        payerData.billingAddressLine1
        case .BILLING_ADDRESS_LINE2:        payerData.billingAddressLine2
        case .BILLING_ADDRESS_LINE3:        payerData.billingAddressLine3
        case .EMAIL, .MOBILE_PHONE:         nil
        }
    }
}
