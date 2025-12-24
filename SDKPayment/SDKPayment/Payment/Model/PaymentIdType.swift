//
//  PaymentIdType.swift
//  SDKPayment
//
//
//

import Foundation
import SDKCore

public enum PaymentIdType {

    case sessionId(id: String)
    case mdOrder(id: String)
}
