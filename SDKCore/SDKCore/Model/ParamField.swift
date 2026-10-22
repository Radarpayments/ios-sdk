//
//  ParamField.swift
//  SDKCore
//
//
//

import Foundation

/// Possible error locations.
public enum ParamField: String, Error {
    // Unknown error.
    case UNKNOWN = "UNKNOWN"
    // Card number error
    case PAN = "PAN"
    // CVC error
    case CVC = "CVC"
    // Expiry date error
    case EXPIRY = "EXPIRY"
    // Cardholder error
    case CARDHOLDER = "CARDHOLDER"
    // Public key error
    case PUB_KEY = "PUB_KEY"
    // Stored payment method Id
    case STORED_PAYMENT_METHOD_ID = "STORED_PAYMENT_METHOD_ID"
    // Binding number error
    case BINDING_ID = "BINDING_ID"
    // Number order error
    case MD_ORDER = "MD_ORDER"
}
