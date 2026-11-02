//
//  ApplePayCountryTest.swift
//  SDKPaymentTests
//

import XCTest
@testable import SDKPayment

final class ApplePayCountryTest: XCTestCase {

    private func merchantInfo(_ merchantCountry: String) throws -> MerchantInfo {
        try JSONDecoder().decode(MerchantInfo.self, from: Data("""
        {"merchantUrl":"https://m.com","merchantFullName":"M","merchantLogin":"login",
         "captchaMode":"NONE","custom":false\(merchantCountry)}
        """.utf8))
    }

    private func settings(countryCode: String? = nil) -> ApplePaySettings {
        ApplePaySettings(merchantId: "merchant.test", countryCode: countryCode, summaryItems: [])
    }

    func testMerchantCountryIsDecoded() throws {
        let info = try merchantInfo(#","merchantCountry":{"countryCode":"196","countryCodeAlpha2":"CY"}"#)

        XCTAssertEqual(info.merchantCountry?.countryCodeAlpha2, "CY")
    }

    func testMerchantCountryIsNilWhenAbsent() throws {
        XCTAssertNil(try merchantInfo("").merchantCountry)
    }

    func testCountryComesFromOrder() {
        XCTAssertEqual(settings().countryCode(merchantCountryCode: "CY"), "CY")
    }

    func testMerchantSettingOverridesOrderCountry() {
        XCTAssertEqual(settings(countryCode: "DE").countryCode(merchantCountryCode: "CY"), "DE")
    }

    func testCountryFallsBackToUs() {
        XCTAssertEqual(settings().countryCode(merchantCountryCode: nil), "US")
        XCTAssertEqual(settings().countryCode(merchantCountryCode: "196"), "US")
    }
}
