//
//  CardNetworkResolverTest.swift
//  SDKPaymentTests
//

import XCTest
@testable import SDKPayment

final class CardNetworkResolverTest: XCTestCase {

    func testResolvesVisa() {
        XCTAssertEqual(CardNetworkResolver.resolve("4111111111111111"), .visa)
        XCTAssertEqual(CardNetworkResolver.resolve("4"), .visa)
        XCTAssertEqual(CardNetworkResolver.resolve("4539 1488 0343 6467"), .visa)
    }

    func testResolvesMastercard() {
        XCTAssertEqual(CardNetworkResolver.resolve("5100000000000000"), .mastercard)
        XCTAssertEqual(CardNetworkResolver.resolve("5599999999999999"), .mastercard)
        XCTAssertEqual(CardNetworkResolver.resolve("2221000000000000"), .mastercard)
        XCTAssertEqual(CardNetworkResolver.resolve("2720999999999999"), .mastercard)
        XCTAssertEqual(CardNetworkResolver.resolve("2220000000000000"), .unknown)
        XCTAssertEqual(CardNetworkResolver.resolve("2721000000000000"), .unknown)
    }

    func testResolvesAmex() {
        XCTAssertEqual(CardNetworkResolver.resolve("340000000000000"), .amex)
        XCTAssertEqual(CardNetworkResolver.resolve("370000000000000"), .amex)
    }

    func testMirIsNotRecognised() {
        XCTAssertEqual(CardNetworkResolver.resolve("2200000000000000"), .unknown)
        XCTAssertEqual(CardNetworkResolver.resolve("2204999999999999"), .unknown)
        XCTAssertEqual(CardNetworkResolver.resolve("220000**0000"), .unknown)
        XCTAssertNil(AssetsResolver().resolveByPan(pan: "2200000000000000"))
    }

    func testResolvesUnionPay() {
        XCTAssertEqual(CardNetworkResolver.resolve("6200000000000000"), .unionpay)
        XCTAssertEqual(CardNetworkResolver.resolve("6221260000000000"), .unionpay)
    }

    func testResolvesJcb() {
        XCTAssertEqual(CardNetworkResolver.resolve("3528000000000000"), .jcb)
        XCTAssertEqual(CardNetworkResolver.resolve("3589999999999999"), .jcb)
        XCTAssertEqual(CardNetworkResolver.resolve("3527000000000000"), .unknown)
    }

    func testResolvesDiners() {
        XCTAssertEqual(CardNetworkResolver.resolve("36000000000000"), .diners)
        XCTAssertEqual(CardNetworkResolver.resolve("30500000000000"), .diners)
        XCTAssertEqual(CardNetworkResolver.resolve("3800000000000000"), .diners)
        XCTAssertEqual(CardNetworkResolver.resolve("3060000000000000"), .unknown)
    }

    func testResolvesDiscover() {
        XCTAssertEqual(CardNetworkResolver.resolve("6011000000000000"), .discover)
        XCTAssertEqual(CardNetworkResolver.resolve("6440000000000000"), .discover)
        XCTAssertEqual(CardNetworkResolver.resolve("6500000000000000"), .discover)
    }

    func testResolvesMaestro() {
        XCTAssertEqual(CardNetworkResolver.resolve("5018000000000000"), .maestro)
        XCTAssertEqual(CardNetworkResolver.resolve("5600000000000000"), .maestro)
        XCTAssertEqual(CardNetworkResolver.resolve("6304000000000000"), .maestro)
        XCTAssertEqual(CardNetworkResolver.resolve("6761000000000000"), .maestro)
    }

    func testResolvesUnknown() {
        XCTAssertEqual(CardNetworkResolver.resolve(""), .unknown)
        XCTAssertEqual(CardNetworkResolver.resolve("1"), .unknown)
        XCTAssertEqual(CardNetworkResolver.resolve("9999999999999999"), .unknown)
    }

    func testIgnoresSeparatorsAndMask() {
        XCTAssertEqual(CardNetworkResolver.resolve("4111-1111-1111-1111"), .visa)
        XCTAssertEqual(CardNetworkResolver.resolve("  5111 2222 3333 4444 "), .mastercard)
        XCTAssertEqual(CardNetworkResolver.resolve("555555**5599"), .mastercard)
    }

    func testLogoAssetNames() {
        XCTAssertEqual(AssetsResolver().resolveByPan(pan: "4111", preferLight: true), "visa-light")
        XCTAssertEqual(AssetsResolver().resolveByPan(pan: "6200"), "unionpay-dark")
        XCTAssertNil(AssetsResolver().resolveByPan(pan: "36000000000000"))
    }
}
