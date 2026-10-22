//
//  CardNetworkResolver.swift
//  SDKPayment
//

import Foundation

enum CardNetwork {

    case visa
    case mastercard
    case amex
    case unionpay
    case diners
    case jcb
    case discover
    case maestro
    case unknown

    /// Base name of the logo in the asset catalog, nil when there is no logo.
    var assetName: String? {
        switch self {
        case .visa: return "visa"
        case .mastercard: return "mastercard"
        case .amex: return "amex"
        case .unionpay: return "unionpay"
        case .jcb: return "jcb"
        case .discover: return "discover"
        case .maestro: return "maestro"
        case .diners, .unknown: return nil
        }
    }
}

/// Resolves a partial or complete card number to its network by the leading digits.
/// Same ranges as CardNetworkResolver in the KMP SDK. Mir (2200–2204) is deliberately not recognised.
enum CardNetworkResolver {

    static func resolve(_ cardNumber: String) -> CardNetwork {
        let digits = cardNumber.filter(\.isNumber)
        guard let first = digits.first else { return .unknown }

        let two = prefix(digits, 2)
        let three = prefix(digits, 3)
        let four = prefix(digits, 4)

        if first == "4" { return .visa }
        if two == 34 || two == 37 { return .amex }
        if let two, (51...55).contains(two) { return .mastercard }
        if let four, (2221...2720).contains(four) { return .mastercard }
        if two == 62 { return .unionpay }

        if two == 36 || two == 38 || two == 39 || (three.map { (300...305).contains($0) } ?? false) || four == 3095 {
            return .diners
        }
        if let four, (3528...3589).contains(four) { return .jcb }
        if four == 6011 || (three.map { (644...649).contains($0) } ?? false) || two == 65 { return .discover }
        if two == 50 || (two.map { (56...58).contains($0) } ?? false) || four == 6304 || four == 6759
            || (four.map { (6761...6763).contains($0) } ?? false) {
            return .maestro
        }

        return .unknown
    }

    private static func prefix(_ digits: String, _ length: Int) -> Int? {
        guard digits.count >= length else { return nil }

        return Int(digits.prefix(length))
    }
}
