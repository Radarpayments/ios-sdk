//
//  DefaultPaymentStringProcessorTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class DefaultPaymentStringProcessorTest: XCTestCase {

    var paymentStringProcessor: PaymentStringProcessor!

    override func setUp() {
        super.setUp()

        NSTimeZone.default = TimeZone(identifier: "Europe/Moscow")!
        paymentStringProcessor = DefaultPaymentStringProcessor()
    }

    func testShouldReturnFilledTemplateForANewCard() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cvv: "444",
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077/444/202012/7f472085-399e-414e-b51c-a7b538aee497//CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForANewCardWithoutCvv() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )

        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077//202012/7f472085-399e-414e-b51c-a7b538aee497//CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForANewCardWithoutExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                cvv: "444",
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )

        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077/444//7f472085-399e-414e-b51c-a7b538aee497//CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForANewCardWithoutCVVAndExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )

        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077///7f472085-399e-414e-b51c-a7b538aee497//CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSavedCard() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cvv: "444"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022//444/202012/7f472085-399e-414e-b51c-a7b538aee497/47eb0336-5ad9-4e03-8a1e-b9f3656ec768//MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSavedCardWithoutCvv() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12)
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022///202012/7f472085-399e-414e-b51c-a7b538aee497/47eb0336-5ad9-4e03-8a1e-b9f3656ec768//MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSavedForCardWithoutExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                cvv: "444"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022//444//7f472085-399e-414e-b51c-a7b538aee497/47eb0336-5ad9-4e03-8a1e-b9f3656ec768//MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSavedForCardWithoutCVVAndExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "7f472085-399e-414e-b51c-a7b538aee497",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768")
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022////7f472085-399e-414e-b51c-a7b538aee497/47eb0336-5ad9-4e03-8a1e-b9f3656ec768//MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForNewCardWithoutMdOrder() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cvv: "444",
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077/444/202012///CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForNewCardWithoutMdOrderCVV() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077//202012///CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForNewCardWithoutMdOrderExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                cvv: "444",
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077/444////CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForNewCardWithoutMdOrderCvvExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardPanIdentifier("4532896701439077"),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/4532896701439077/////CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSaveCardWithoutMdOrder() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cvv: "444",
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022//444/202012//47eb0336-5ad9-4e03-8a1e-b9f3656ec768/CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSaveCardWithoutMdOrderCvv() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                expDate: ExpiryDate(expYear: 2020, expMonth: 12),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022///202012//47eb0336-5ad9-4e03-8a1e-b9f3656ec768/CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSaveCardWithoutMdOrderExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                cvv: "444",
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022//444///47eb0336-5ad9-4e03-8a1e-b9f3656ec768/CardHolderName/MSDK_CORE")
    }

    func testShouldReturnFilledTemplateForSaveCardWithoutMdOrderCvvExpDate() {
        let template = paymentStringProcessor.createPaymentString(
            order: "",
            // Timestamp in seconds
            timestamp: 1594009580,
            uuid: "fd4b1011-727a-41e8-95b4-d7092d729022",
            cardInfo: CoreCardInfo(
                identifier: .cardBindingIdIdentifier("47eb0336-5ad9-4e03-8a1e-b9f3656ec768"),
                cardHolder: "CardHolderName"
            ),
            registeredFrom: .MSDK_CORE
        )
        
        XCTAssertEqual(template, "2020-07-06T07:26:20+03:00/fd4b1011-727a-41e8-95b4-d7092d729022/////47eb0336-5ad9-4e03-8a1e-b9f3656ec768/CardHolderName/MSDK_CORE")
    }
}
