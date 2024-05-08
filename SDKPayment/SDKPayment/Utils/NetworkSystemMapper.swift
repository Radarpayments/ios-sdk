//
//  NetworkSystemMapper.swift
//  SDKPayment
//
// 
//

import Foundation
import PassKit

final class NetworkSystemMapper {
    
    func networktSystem(paymentSystem: PaymentSystem) -> PKPaymentNetwork {
        switch paymentSystem {
        case .visa: return .visa
        case .masterCard: return .masterCard
        case .jcb: return .JCB
        case .interac: return .interac
        case .discover: return .discover
        case .amex: return .amex
        }
    }
}
