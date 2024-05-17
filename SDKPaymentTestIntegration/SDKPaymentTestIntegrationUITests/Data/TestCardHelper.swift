//
//  TestCardHelper.swift
//  SDKPaymentIntegrationUITests
//

//

import Foundation

struct TestCardHelper {
    
    static let testCardWith3DS = TestCard(
        pan: "5000001111111115",
        expiry: "12/30",
        cvc: "123",
        holder: "CARD HOLDER"
    )

    static let successFull3DS = TestCard(
        pan: "5555555555555599",
        expiry: "12/24",
        cvc: "123",
        holder: "CARD HOLDER"
    )

    static let successFrictionless3DS2 = TestCard(
        pan: "4111111111111111",
        expiry: "12/24",
        cvc: "123",
        holder: "CARD HOLDER"
    )

    static let failFrictionless3DS = TestCard(
        pan: "5168494895055780",
        expiry: "12/24",
        cvc: "123",
        holder: "CARD HOLDER"
    )

    static let successAttempt3DS = TestCard(
        pan: "4000001111111118",
        expiry: "12/30",
        cvc: "123",
        holder: "CARD HOLDER"
    )

    static let successSSL = TestCard(
        pan: "4444555511113333",
        expiry: "12/24",
        cvc: "123",
        holder: "CARD HOLDER"
    )
    
    static func getLabelForSavedCardFrom(testCard: TestCard) -> String {
        return "**" + testCard.pan.takeLast(4)
    }

    static func getExpireForSavedCardFrom(testCard: TestCard) -> String {
        return testCard.expiry.takeLast(2) + "/" + testCard.expiry.take(2)
    }

    static func getLabelForSavedBindingItemFrom(testCard: TestCard) -> String {
        return testCard.pan.take(6) + "**" + testCard.pan.takeLast(4) + " " + testCard.expiry
    }
}
