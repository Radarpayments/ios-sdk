//
//  SDKCoreTest.swift
//  SDKCoreTests
//
// 
//

import XCTest
@testable import SDKCore

final class SDKCoreTest: XCTestCase {

    private var sdkCore: SdkCore!

    private let testPubKey =
    "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAij/G3JVV3TqYCFZTPmwi4JduQMsZ2HcFLBBA9fYAvApv3FtA+zKdUGgKh/OPbtpsxe1C57gIaRclbzMoafTb0eOdj+jqSEJMlVJYSiZ8Hn6g67evhu9wXh5ZKBQ1RUpqL36LbhYnIrP+TEGR/VyjbC6QTfaktcRfa8zRqJczHFsyWxnlfwKLfqKz5wSqXkShcrwcfRJCyDRjZX6OFUECHsWVK3WMcOV3WZREwbCkh/o5R5Vl6xoyLvSqVEKQiHupJcZu9UEOJiP3yNCn9YPgyFs2vrCeg6qxDPFnCfetcDCLjjLenGF7VyZzBJ9G2NP3k/mNVtD8Kl7lpiurwY7EZwIDAQAB-----END PUBLIC KEY-----"

    override func setUp() {
        super.setUp()

        sdkCore = SdkCore()
    }

    func testShouldGenerateWithCard() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)
        
        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateWithCardWithoutCardHolder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: nil,
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)
        
        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateWithCardWithInvalidSymbolsInCardHolder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "4554Pav",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)
        
        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.CARDHOLDER])
    }
    
    func testShouldGenerateWithCardWithMaxLengthInCardHolder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: String(repeating: "G", count: 31),
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithEmptyMdOrder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.MD_ORDER])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithEmptyPan() {
        let params = CardParams(
            pan: "",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithEmptyCVC() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithEmptyExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.EXPIRY])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithEmptyPubKey() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: ""
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithInvalidPan() {
        let params = CardParams(
            pan: "5INVALID19268PAN14792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.PAN])
    }
    
    func testShouldReturnErrorWhileGenerateWithCardWithInvalidCVC() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "1AA",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )

        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateWithCardWithInvalidExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "DDD",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.EXPIRY])
    }
    
    func testShouldNotReturnErrorWhileGenerateWithCardDateExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/35",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testsHouldReturnErrorWhileGenerateWithCardWithInvalidPubKey() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: "INVALIDPUBKEY"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }

    func testShouldGenerateWithBinding() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateWithBindingWithoutCVC() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldReturnErrorGenerateWithBindingWithEmptyMdOrder() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123",
            mdOrder: ""
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.MD_ORDER])
    }

    func testShouldReturnErrorGenerateWithBindingWithEmptyBindingID() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "",
            cvc: "123",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.BINDING_ID])
    }

    func testShouldReturnErrorGenerateWithBindingWithEmptyPubKey() {
        let params = BindingParams(
            pubKey: "",
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorGenerateWithBindingWithInvalidCVC() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "aaD",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorGenerateWithBindingWithInvalidPubKey() {
        let params = BindingParams(
            pubKey: "INVALIDPUBKEY",
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }

    func testShouldGenerateInstanceWithCard() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateInstanceWithCardWithoutCardHolder() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: nil,
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateInstanceWithCardWithInvalidSymbolsInCardHolder() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "4554Pav",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldGenerateInstanceWithCardWithMaxLengthInCardHolder() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: String(repeating: "G", count: 31),
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyPan() {
        let params = CardParamsInstant(
            pan: "",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyCVC() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyExpiry() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.EXPIRY])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyPubKey() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: ""
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidPan() {
        let params = CardParamsInstant(
            pan: "5INVALID19268PAN14792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidCVC() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "1AA",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidExpiry() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "DDD",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.EXPIRY])
    }

    func testShouldNotReturnErrorWhileGenerateInstanceWithCardWithOutDateExpiry() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/15",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testShouldNotReturnErrorWhileGenerateInstanceWithCardWithMaxOutDateExpiry() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/35",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidPubKey() {
        let params = CardParamsInstant(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: "INVALIDPUBKEY"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .cardParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }

    func testShouldGenerateInstantWithBindingParamsInstant() {
        let params = BindingParamsInstant(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testShouldGenerateInstantWithBindingParamsInstantWithoutCVC() {
        let params = BindingParamsInstant(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testShouldReturnErrorGenerateInstantWithBindingParamsInstantWithEmptyBindingID() {
        let params = BindingParamsInstant(
            pubKey: testPubKey,
            bindingId: "",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.BINDING_ID])
    }

    func testShouldReturnErrorGenerateInstantWithBindingParamsInstantWithEmptyPubKey() {
        let params = BindingParamsInstant(
            pubKey: "",
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorGenerateInstantWithBindingParamsInstantWithInvalidCVC() {
        let params = BindingParamsInstant(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "aaD"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorGenerateInstantWithBindingParamsInstantWithInvalidPubKey() {
        let params = BindingParamsInstant(
            pubKey: "INVALIDPUBKEY",
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .bindingParamsInstant(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }
    
    func testShouldGenerateWithNewPaymentMethod() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateWithNewPaymentMethodWithoutCardHolder() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: nil,
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateWithNewPaymentMethodWithInvalidSymbolsInCardHolder() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "4554Pav",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldGenerateWithNewPaymentMethodWithMaxLengthInCardHolder() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: String(repeating: "G", count: 31),
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithEmptyPan() {
        let params = NewPaymentMethodParams(
            pan: "",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithEmptyCVC() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithEmptyExpiry() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.EXPIRY])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithEmptyPubKey() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: ""
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithInvalidPan() {
        let params = NewPaymentMethodParams(
            pan: "5INVALID19268PAN14792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithInvalidCVC() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "1AA",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithInvalidExpiry() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "DDD",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.EXPIRY])
    }

    func testShouldNotReturnErrorWhileGenerateWithNewPaymentMethodWithOutDateExpiry() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/15",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testShouldNotReturnErrorWhileGenerateWithNewPaymentMethodWithMaxOutDateExpiry() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/35",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testShouldReturnErrorWhileGenerateWithNewPaymentMethodWithInvalidPubKey() {
        let params = NewPaymentMethodParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: "INVALIDPUBKEY"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .newPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }
    
    func testShouldGenerateWithStoredPaymentMethod() {
        let params = StoredPaymentMethodParams(
            pubKey: testPubKey,
            storePaymentMethodId: "pm_QRiwYPoAGtbRrETy1uP6RovMnsF2W3aA2xbeRhG8F4Sf6b9vY",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testShouldGenerateWithStoredPaymentMethodWithoutCVC() {
        let params = StoredPaymentMethodParams(
            pubKey: testPubKey,
            storePaymentMethodId: "pm_QRiwYPoAGtbRrETy1uP6RovMnsF2W3aA2xbeRhG8F4Sf6b9vY"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testShouldReturnErrorGenerateWithStoredPaymentMethodWithEmptyBindingID() {
        let params = StoredPaymentMethodParams(
            pubKey: testPubKey,
            storePaymentMethodId: "",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.STORED_PAYMENT_METHOD_ID])
    }

    func testShouldReturnErrorGenerateWithStoredPaymentMethodWithEmptyPubKey() {
        let params = StoredPaymentMethodParams(
            pubKey: "",
            storePaymentMethodId: "pm_QRiwYPoAGtbRrETy1uP6RovMnsF2W3aA2xbeRhG8F4Sf6b9vY",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorGenerateWithStoredPaymentMethodWithInvalidCVC() {
        let params = StoredPaymentMethodParams(
            pubKey: testPubKey,
            storePaymentMethodId: "pm_QRiwYPoAGtbRrETy1uP6RovMnsF2W3aA2xbeRhG8F4Sf6b9vY",
            cvc: "aaD"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorGenerateWithStoredPaymentMethodWithInvalidPubKey() {
        let params = StoredPaymentMethodParams(
            pubKey: "INVALIDPUBKEY",
            storePaymentMethodId: "pm_QRiwYPoAGtbRrETy1uP6RovMnsF2W3aA2xbeRhG8F4Sf6b9vY",
            cvc: "123"
        )
        
        let config = SDKCoreConfig(paymentMethodParams: .storedPaymentMethodParams(params: params))
        let result = sdkCore.generateWithConfig(config: config)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnBindingIdFromStoredPaymentMethodIdString() {
        let clearStoredPaymentMethodId = "pm_m8sc17tRcbsZMpG4esfdDdD5pAMXsxrJgeseAcS1KmefqY7y3"
        let result = BindingUtils().extractValue(from: clearStoredPaymentMethodId)
        XCTAssertEqual(result, "d707897c-188c-45ca-8665-487e614e42bb")
    }
    
    func testShouldReturnEmptyStringFromStoredPaymentMethodIdStringWithIncorrectPrefix1() {
        let incorrectString1 = "pmm8sc17tRcbsZMpG4esfdDdD5pAMXsxrJgeseAcS1KmefqY7y3"
        let result1 = BindingUtils().extractValue(from: incorrectString1)
        XCTAssertEqual(result1, "")
    }
    
    func testShouldReturnEmptyStringFromStoredPaymentMethodIdStringWithIncorrectPrefix2() {
        let incorrectString2 = "p_m8sc17tRcbsZMpG4esfdDdD5pAMXsxrJgeseAcS1KmefqY7y3"
        let result2 = BindingUtils().extractValue(from: incorrectString2)
        XCTAssertEqual(result2, "")
    }
    
    func testShouldReturnEmptyStringFromStoredPaymentMethodIdStringWithIncorrectPrefix3() {
        let incorrectString3 = "m_m8sc17tRcbsZMpG4esfdDdD5pAMXsxrJgeseAcS1KmefqY7y3"
        let result3 = BindingUtils().extractValue(from: incorrectString3)
        XCTAssertEqual(result3, "")
    }
    
    func testShouldReturnEmptyStringFromStoredPaymentMethodIdStringWithIncorrectPrefix4() {
        let incorrectString4 = "pm_8sc17tRcbsZMpG4esfdDdD5pAMXsxrJgeseAcS1KmefqY7y3"
        let result4 = BindingUtils().extractValue(from: incorrectString4)
        XCTAssertEqual(result4, "")
    }
    
    func testShouldReturnEmptyStringFromIncorrectStoredPaymentMethodId() {
        let incorrectStoredPaymentMethodId = "pm_m8sc17RcbsZMpG4esfdDdD5pAMXsxrJgeseAcS1KmefqY7y3"
        let result1 = BindingUtils().extractValue(from: incorrectStoredPaymentMethodId)
        XCTAssertEqual(result1, "")
    }
    
    func testShouldReturnBindingIdFromStoredPaymentMethodIdWithMagicNewLines() {
        let incorrectStoredPaymentMethodId = "pm_FNzdHRMmfDoDSJDJK2P91DkEa4K7TSXkmeqpQ1Yk1iKAivwTRUQh"
        let result1 = BindingUtils().extractValue(from: incorrectStoredPaymentMethodId)
        XCTAssertEqual(result1, "a4266a22-b558-46b4-82c1-9e4a50f6a679")
    }
}
