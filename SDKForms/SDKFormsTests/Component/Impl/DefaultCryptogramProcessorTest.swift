//
//  DefaultCryptogramProcessorTest.swift
//  SDKFormsTests
//
// 
//

import XCTest
import SwiftyMocky
@testable import SDKForms
@testable import SDKCore


final class DefaultCryptogramProcessorTest: XCTestCase {
    
    private var defaultCryptogramProcessor: DefaultCryptogramProcessor!
    private let keyProvider = KeyProviderTestMock()
//    RemoteKeyProvider(url: "https://dev.bpcbt.com/payment/se/keys.do")
    private let paymentStringProcessor = PaymentStringProcessorTestMock()
    private let cryptogramCipher = CryptogramCipherTestMock()
    
    override func setUp() {
        super.setUp()
        
        defaultCryptogramProcessor = DefaultCryptogramProcessor(
            keyProvider: keyProvider,
            paymentStringProcessor: paymentStringProcessor,
            cryptogramCipher: cryptogramCipher
        )
        
        Matcher.default.register(Key.self) { lhs, rhs in
            lhs.value == rhs.value
                && lhs.protocol == rhs.protocol
                && lhs.expiration == rhs.expiration
        }
        
        Matcher.default.register(CoreCardInfo.self) { lhs, rhs in
            lhs.identifier == rhs.identifier
                && lhs.cvv == rhs.cvv
                && lhs.expDate?.expYear == rhs.expDate?.expYear
                && lhs.expDate?.expMonth == rhs.expDate?.expMonth
        }
    }
    
    func testShouldCreatePaymentCryptogram() {
        let key = Key(
            value: "",
            protocol: "",
            expiration: 1598689996644
        )
        
        Given(keyProvider, .provideKey(willReturn: key))
        Given(
            paymentStringProcessor, 
                .createPaymentString(
                    order: .value("413519e0-c625-468b-a250-698ce1d94126"),
                    timestamp: .value(1598682006644),
                    uuid: .value("71bded36-ad00-41cd-aa33-3f723dfafe81"),
                    cardInfo: .value(CoreCardInfo(identifier: .cardPanIdentifier("123456789012"))),
                    willReturn: "paymentStringValue"
                )
        )
        Given(cryptogramCipher, .encode(data: "paymentStringValue", key: .value(key), willReturn: "cryptogramValue"))
        
        let cryptogram = try! defaultCryptogramProcessor.create(
            order: "413519e0-c625-468b-a250-698ce1d94126",
            timestamp: 1598682006644,
            uuid: "71bded36-ad00-41cd-aa33-3f723dfafe81",
            cardInfo: CoreCardInfo(identifier: .cardPanIdentifier("123456789012")),
            registeredFrom: .MSDK_FORMS
        )
        
        XCTAssertEqual(cryptogram, "cryptogramValue")
    }
    
    func testShouldCreatePaymentWithoutOrder() {
        let key = Key(
            value: "",
            protocol: "",
            expiration: 1598689996644
        )
        
        Given(keyProvider, .provideKey(willReturn: key))
        Given(
            paymentStringProcessor,
                .createPaymentString(
                    order: .value(""),
                    timestamp: .value(1598682006644),
                    uuid: .value("71bded36-ad00-41cd-aa33-3f723dfafe81"),
                    cardInfo: .value(CoreCardInfo(identifier: .cardPanIdentifier("123456789012"))),
                    willReturn: "paymentStringValue"
                )
        )
        Given(cryptogramCipher, .encode(data: "paymentStringValue", key: .value(key), willReturn: "cryptogramValue"))
        
        let cryptogram = try! defaultCryptogramProcessor.create(
            timestamp: 1598682006644,
            uuid: "71bded36-ad00-41cd-aa33-3f723dfafe81",
            cardInfo: CoreCardInfo(identifier: .cardPanIdentifier("123456789012")),
            registeredFrom: .MSDK_FORMS
        )
        
        XCTAssertEqual(cryptogram, "cryptogramValue")
    }
}
