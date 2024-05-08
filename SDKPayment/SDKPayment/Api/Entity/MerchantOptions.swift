//
//  MerchantOptions.swift
//  SDKPayment
//
// 
//

import Foundation

enum MerchantOption: String, Codable {
    
    case googlePay     = "GOOGLEPAY"
    case masterCardTDS = "MASTERCARD_TDS"
    case mir           = "MIR"
    case masterCard    = "MASTERCARD"
    case visa          = "VISA"
    case visaTDS       = "VISA_TDS"
    case mirTDS        = "MIR_TDS"
    case applePay      = "APPLEPAY"
    case ssl           = "SSL"
}
