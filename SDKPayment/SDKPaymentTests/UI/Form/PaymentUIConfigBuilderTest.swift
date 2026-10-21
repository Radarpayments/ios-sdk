//
//  PaymentUIConfigBuilderTest.swift
//  SDKPaymentTests
//
// 
//

import XCTest
@testable import SDKPayment

final class PaymentUIConfigBuilderTest: XCTestCase {

    func testSucceesBuildWithKeyProviderUrl() {
        XCTAssertNoThrow(
            try PaymentUIConfigBuilder()
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .build()
        )
    }
    
    func testSucceedBuildWithCustomKeyProvider() {
        XCTAssertNoThrow(
            try PaymentUIConfigBuilder()
                .keyProvider(
                    provider: CachedKeyProvider(
                        keyProvider: RemoteKeyProvider(
                            url: "https://dev.bpcbt.com/payment/se/keys.do"
                        )
                    )
                )
                .build()
        )
    }
    
    func testBuildWithoutKeyProviderShouldThrowException() {
        XCTAssertThrowsError(try PaymentUIConfigBuilder().build())
    }
    
    func testBuildTwoDifferentKeyProviderShouldThrowException() {
        XCTAssertThrowsError(
            try PaymentUIConfigBuilder()
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .keyProvider(provider: RemoteKeyProvider(url: "https://dev.bpcbt.com/payment/se/keys.do"))
                .build()
        )
    }
    
    func testBuildWithTwoDifferentKeyProviderSwapOrderShouldThrowException() {
        XCTAssertThrowsError(
            try PaymentUIConfigBuilder()
                .keyProvider(provider: RemoteKeyProvider(url: "https://dev.bpcbt.com/payment/se/keys.do"))
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .build()
        )
    }
}
