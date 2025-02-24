//
//  File.swift
//  

import Foundation

public struct BillingPayerData: Codable {
    
    public var billingCountry: String?
    public var billingState: String?
    public var billingCity: String?
    public var billingPostalCode: String?
    public var billingAddressLine1: String?
    public var billingAddressLine2: String?
    public var billingAddressLine3: String?
    
    public init(
        billingCountry: String? = nil,
        billingState: String? = nil,
        billingCity: String? = nil,
        billingPostalCode: String? = nil,
        billingAddressLine1: String? = nil,
        billingAddressLine2: String? = nil,
        billingAddressLine3: String? = nil
    ) {
        self.billingCountry = billingCountry
        self.billingState = billingState
        self.billingCity = billingCity
        self.billingPostalCode = billingPostalCode
        self.billingAddressLine1 = billingAddressLine1
        self.billingAddressLine2 = billingAddressLine2
        self.billingAddressLine3 = billingAddressLine3
    }
}


struct FullPayerData: Codable {
    
    var email: String?
    var mobilePhone: String?
    var billingPayerData = BillingPayerData()
}
