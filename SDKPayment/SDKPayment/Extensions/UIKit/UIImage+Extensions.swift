//
//  UIImage+Extensions.swift
//  SDKPayment
//
//
//

import UIKit

public extension UIImage {

    static let visaVerifyImage = UIImage(named: "verify-visa", in: .sdkPaymentBundle, compatibleWith: .none)
    static let jcbVerifyImage = UIImage(named: "verify-jcb", in: .sdkPaymentBundle, compatibleWith: .none)
    static let pciVerifyImage = UIImage(named: "verify-pci", in: .sdkPaymentBundle, compatibleWith: .none)
    static let verifyMastercardImage = UIImage(named: "verify-mastercard", in: .sdkPaymentBundle, compatibleWith: .none)
    static let bankLogoUnknownImage = UIImage(named: "bank-logo-unknown", in: .sdkPaymentBundle, compatibleWith: .none)
}
