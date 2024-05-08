//
//  SDKConfigBuilderTest.swift
//  SDKFormsTests
//
// 
//

import XCTest
@testable import SDKForms

final class SDKConfigBuilderTest: XCTestCase {
    
    func testSucceesBuildWithKeyProviderUrl() {
        XCTAssertNoThrow(
            try SDKConfigBuilder()
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .build()
        )
    }
    
    func testSucceedBuildWithCustomKeyProvider() {
        XCTAssertNoThrow(
            try SDKConfigBuilder()
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
    
    func testSucceedBuildWithCustomCardInfoProvider() {
        XCTAssertNoThrow(
            try SDKConfigBuilder()
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .cardInfoProvider(
                    provider: RemoteCardInfoProvider(
                        url: "https://mrbin.io/bins/display",
                        urlBin: "https://mrbin.io/bins/"
                    )
                )
                .build()
        )
    }
    
    func testBuildWithoutKeyProviderShouldThrowException() {
        XCTAssertThrowsError(try SDKConfigBuilder().build())
    }
    
    func testBuildTwoDifferentKeyProviderShouldThrowException() {
        XCTAssertThrowsError(
            try SDKConfigBuilder()
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .keyProvider(provider: RemoteKeyProvider(url: "https://dev.bpcbt.com/payment/se/keys.do"))
                .build()
        )
    }
    
    func testBuildWithTwoDifferentKeyProviderSwapOrderShouldThrowException() {
        XCTAssertThrowsError(
            try SDKConfigBuilder()
                .keyProvider(provider: RemoteKeyProvider(url: "https://dev.bpcbt.com/payment/se/keys.do"))
                .keyProviderUrl(providerUrl: "https://dev.bpcbt.com/payment/se/keys.do")
                .build()
        )
    }
}
