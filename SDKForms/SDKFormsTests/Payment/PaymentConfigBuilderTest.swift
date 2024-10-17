//
//  PaymentConfigBuilderTest.swift
//  SDKFormsTests
//
// 
//

import XCTest
@testable import SDKForms

final class PaymentConfigBuilderTest: XCTestCase {
    
    func testShouldReturnTheme() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .theme(theme: .dark)
                .build()
                .theme, .dark
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .theme(theme: .light)
                .build()
                .theme, .light
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .theme(theme: .system)
                .build()
                .theme, .system
        )
    }
    
    func testShouldReturnLocale() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .locale(locale: .init(identifier: "en"))
                .build()
                .locale
                .identifier, "en"
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .locale(locale: .init(identifier: "de"))
                .build()
                .locale
                .identifier, "de"
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .locale(locale: .init(identifier: "fr"))
                .build()
                .locale
                .identifier, "fr"
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .locale(locale: .init(identifier: "es"))
                .build()
                .locale
                .identifier, "es"
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .locale(locale: .init(identifier: "ru"))
                .build()
                .locale
                .identifier, "ru"
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
                .locale(locale: .init(identifier: "uk"))
                .build()
                .locale
                .identifier, "uk"
        )
    }
    
    func testShouldReturnOrderNumber() {
        let expectedOrder = "394f2c04-430c-4102-81e6-451d79234fc8"
        
        let actualOrder = PaymentConfigBuilder(order: expectedOrder)
            .build()
            .order
        
        XCTAssertEqual(expectedOrder, actualOrder)
    }
    
    func testShouldReturnCardSaveOptionsAsHIDEByDefault() {
        let cardSaveOptions = PaymentConfigBuilder(order: "18818587-aa98-4149-8780-3816afbd67f7")
            .build()
            .cardSaveOptions
        
        XCTAssertEqual(cardSaveOptions, .hide)
    }
    
    func testShouldReturnDefinedCardSaveOptionsAsNO_BY_DEFAULT() {
        let cardSaveOptions = PaymentConfigBuilder(order: "00d46e7d-ee70-4a8f-95d1-6da9c52d7473")
            .cardSaveOptions(options: .noByDefault)
            .build()
            .cardSaveOptions
        
        XCTAssertEqual(cardSaveOptions, .noByDefault)
    }
    
    func testShouldReturnDefinedCardSaveOptionsAsYES_BY_DEFAULT() {
        let cardSaveOptions = PaymentConfigBuilder(order: "632c6bb5-5917-44bc-b73d-db78145e2985")
            .cardSaveOptions(options: .yesByDefault)
            .build()
            .cardSaveOptions
        
        XCTAssertEqual(cardSaveOptions, .yesByDefault)
    }
    
    func testShouldReturnEmptyCardsByDefault() {
        let cards = PaymentConfigBuilder(order: "2c04b14c-136b-40e3-bddc-9c371bf7848a")
            .build()
            .cards
        
        XCTAssertEqual(cards, [])
    }
    
    func testShouldReturnDefinedCards() {
        let expectedCards: Set<Card> = [
            Card(pan: "492980xxxxxx7724", bindingId: "ee199a55-cf16-41b2-ac9e-cc1c731edd19")
        ]
        
        let actualCards = PaymentConfigBuilder(order: "08aba475-1291-4f22-b593-e359487b431d")
            .cards(cards: expectedCards)
            .build()
            .cards
            
        XCTAssertEqual(expectedCards, actualCards)
    }
    
    func testShouldReturnEmptyButtonTextByDefault() {
        let buttonText = PaymentConfigBuilder(order: "fefdc0a0-1c7e-4a28-81d4-63384205b266")
            .build()
            .buttonText
        
        XCTAssertNil(buttonText)
    }
    
    func testShouldReturnDefinedButtonText() {
        let expectedButtonText = "Pay"

        let actualButtonText = PaymentConfigBuilder(order: "24bcdfe5-1683-4108-b1c9-1970f40401c2")
            .buttonText(buttonText: expectedButtonText)
            .build()
            .buttonText
        
        XCTAssertEqual(expectedButtonText, actualButtonText)
    }
    
    func testShouldReturnGeneratedUuidValueByDefault() {
        let order = "2545f609-490b-4c8d-a3fb-be1f8d30fa77"
        
        let firstUUID = PaymentConfigBuilder(order: order)
            .build()
            .uuid
        let secondUUID = PaymentConfigBuilder(order: order)
            .build()
            .uuid
        
        XCTAssertNotEqual(firstUUID, "")
        XCTAssertNotEqual(secondUUID, "")
        XCTAssertNotEqual(firstUUID, secondUUID)
    }
    
    func testShouldReturnDefinedUuid() {
        let expectedUuid = "62d0bb9e-111b-4c28-a79e-e7fb8d1791eb"
        
        let actualUuid = PaymentConfigBuilder(order: "701e6250-fab1-403d-a6d0-10267c5faf6f")
            .uuid(uuid: expectedUuid)
            .build()
            .uuid
        
        XCTAssertEqual(expectedUuid, actualUuid)
    }
    
    func testShouldReturnSameGeneratedValueOfUuidForTheSameBuilder() {
        let builder = PaymentConfigBuilder(order: "3d73539f-2bc1-4dc6-8575-d36789af74e4")
        
        let firstUUID = builder
            .build()
            .uuid
        let secondUUID = builder
            .build()
            .uuid
        
        XCTAssertNotEqual(firstUUID, "")
        XCTAssertNotEqual(secondUUID, "")
        XCTAssertEqual(firstUUID, secondUUID)
    }
    
    func testShouldReturnCurrentTimestampByDefault() {
        let order = "039e5501-d39b-47c1-a0e5-bd1d3ae917ad"
        
        let beforeExecute = Int64(Date().timeIntervalSince1970)
        Thread.sleep(forTimeInterval: TimeInterval(1))
        let firstTimestamp = PaymentConfigBuilder(order: order)
            .build()
            .timestamp
        Thread.sleep(forTimeInterval: TimeInterval(1))
        let secondTimestamp = PaymentConfigBuilder(order: order)
            .build()
            .timestamp
        Thread.sleep(forTimeInterval: TimeInterval(1))
        let afterExecute = Int64(Date().timeIntervalSince1970)
        
        XCTAssertNotEqual(firstTimestamp, 0)
        XCTAssertNotEqual(secondTimestamp, 0)
        XCTAssertNotEqual(firstTimestamp, secondTimestamp)
        XCTAssertGreaterThan(firstTimestamp, beforeExecute)
        XCTAssertGreaterThan(secondTimestamp, beforeExecute)
        XCTAssertLessThan(firstTimestamp, afterExecute)
        XCTAssertLessThan(secondTimestamp, afterExecute)
    }
    
    func testShouldReturnDefinedTimestamp() {
        let expectedTimestamp: Int64 = 1593791597
        
        let actualTimestamp = PaymentConfigBuilder(order: "455152ee-25c5-4aad-bbd6-6b408b265d1d")
            .timestamp(timestamp: expectedTimestamp)
            .build()
            .timestamp
        
        XCTAssertEqual(expectedTimestamp, actualTimestamp)
    }
    
    func testShouldReturnSameValueOfTimestampForTheSameBuilder() {
        let builder = PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")

        let firstTimestamp = builder
            .build()
            .timestamp
        let secondTimestamp = builder
            .build()
            .timestamp

        XCTAssertNotEqual(firstTimestamp, 0)
        XCTAssertNotEqual(secondTimestamp, 0)
        XCTAssertEqual(firstTimestamp, secondTimestamp)
    }
    
    func testShouldReturnBindingCvcRequired() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .bindingCVCRequired(required: true)
                .build()
                .bindingCVCRequired, true
        )

        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .bindingCVCRequired(required: false)
                .build()
                .bindingCVCRequired, false
        )
    }
    
    func testShouldReturnBindingCvcRequiredByDefault() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .build()
                .bindingCVCRequired, true
        )
    }
    
    func testShouldReturnCameraScannerOptionsENABLEDByDefault() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .build()
                .cameraScannerOptions, .enabled
        )
    }
    
    func testShouldReturnCameraScannerOptions() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .cameraScannerOptions(options: .enabled)
                .build()
                .cameraScannerOptions, .enabled
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .cameraScannerOptions(options: .disabled)
                .build()
                .cameraScannerOptions, .disabled
        )
    }
    
    func testShouldReturnHolderInputOptionsHIDEByDefault() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .build()
                .holderInputOptions, .hide
        )
    }
    
    func testShouldReturnHolderInputOptions() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .holderInputOptions(options: .visible)
                .build()
                .holderInputOptions, .visible
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .holderInputOptions(options: .hide)
                .build()
                .holderInputOptions, .hide
        )
    }
    
    func testShouldReturnDisplayApplePay() {
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .build()
                .displayApplePay, false
        )
        
        XCTAssertEqual(
            PaymentConfigBuilder(order: "5eec2dec-b86a-48b3-b296-a772eb5ff77f")
                .displayApplePay(isDisplay: true)
                .build()
                .displayApplePay, true
        )
    }
}
