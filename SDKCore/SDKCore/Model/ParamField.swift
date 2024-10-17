//
//  ParamField.swift
//  SDKCore
//
// 
//

import Foundation

/// Possible error locations.
public enum ParamField: Error {
    // Unknown error.
    case UNKNOWN
    // Card number error.
    case PAN
    // CVC error.
    case CVC
    // Expiry date error.
    case EXPIRY
    // Cardholder error.
    case CARDHOLDER
    // Binding number error.
    case BINDING_ID
    // Number order error.
    case MD_ORDER
    // Public key error.
    case PUB_KEY
}
