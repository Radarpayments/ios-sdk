//
//  DefaultPaymentStringProcessor.swift
//  SDKCore
//
// 
//

import Foundation

/// Implementation of a processor for generating a line with payment information using a template.
public final class DefaultPaymentStringProcessor: PaymentStringProcessor {

    private let SPLASH = "/"
    
    public init() {}

    /// Generates a list of payment data using a template.
    ///
    /// Available template options :
    ///

    ///  timestamp(1)/uuid(2)/pan(3)/cvv(4)/expdate(5)/mdOrder(6)/bindingId(7)/cardholder(8)/registeredFrom(9)
    ///
    /// - Parameters:
    ///     - order: order identifier.
    ///     - timestamp: request date.
    ///     - uuid: identifier in UUID standard.
    ///     - cardInfo: information about the withdrawal card.
    ///     - registeredFrom: source of token generation.
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    public func createPaymentString(order: String,
                                    timestamp: Int64,
                                    uuid: String,
                                    cardInfo: CoreCardInfo,
                                    registeredFrom: MSDKRegisteredFrom = .MSDK_CORE
    ) -> String {
        let cardIdentifier = cardInfo.identifier
        let bindingId: String = {
            if case let .cardBindingIdIdentifier(value) = cardIdentifier {
                return value
            }
            return ""
        }()

        var str = String()
        // timestamp(1)
        str.append(Date(timeIntervalSince1970: TimeInterval(timestamp))
            .formatDate(dateFormatter: dateFormatter))
        str.append(SPLASH)
        // uuid (2)
        str.append(uuid)
        str.append(SPLASH)
        // pan (3)
        if case let .cardPanIdentifier(value) = cardIdentifier {
            str.append(value)
        }
        str.append(SPLASH)
        // cvv(4)
        str.append(cardInfo.cvv ?? "")
        str.append(SPLASH)
        // expdate(5)
        str.append(cardInfo.expDate?.format() ?? "")
        str.append(SPLASH)
        // mdOrder(6)
        str.append(order)
        str.append(SPLASH)
        // bindingId(7)
        str.append(bindingId)
        str.append(SPLASH)
        // cardHolder(8)
        str.append(cardInfo.cardHolder ?? "")
        str.append(SPLASH)
        // registeredFrom (9)
        str.append(registeredFrom.rawValue)
        

        return str
    }
}
