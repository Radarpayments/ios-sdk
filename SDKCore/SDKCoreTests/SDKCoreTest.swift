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

        let result = sdkCore.generateWithCard(params: params)
        
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

        let result = sdkCore.generateWithCard(params: params)
        
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
        
        let result = sdkCore.generateWithCard(params: params)
        
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

        let result = sdkCore.generateWithCard(params: params)
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

        let result = sdkCore.generateWithCard(params: params)

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

        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithCard(params: params)

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

        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithCard(params: params)

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

        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithCard(params: params)

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
        
        let result = sdkCore.generateWithBinding(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateWithBindingWithoutCVC() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            mdOrder: "39ce26e1-5fd0-4784-9e6c-25c9f2c2d09e"
        )
        
        let result = sdkCore.generateWithBinding(params: params)

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
        
        let result = sdkCore.generateWithBinding(params: params)

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
        
        let result = sdkCore.generateWithBinding(params: params)

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
        
        let result = sdkCore.generateWithBinding(params: params)

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
        
        let result = sdkCore.generateWithBinding(params: params)

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
        
        let result = sdkCore.generateWithBinding(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }

    func testShouldGenerateInstanceWithCard() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            mdOrder: "c400b41a-aa3d-43db-8727-ac4ca9e8f701",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateInstanceWithCardWithoutCardHolder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: nil,
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertEqual(result.errors, [ParamField: String]())
    }

    func testShouldGenerateInstanceWithCardWithInvalidSymbolsInCardHolder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "4554Pav",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldGenerateInstanceWithCardWithMaxLengthInCardHolder() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: String(repeating: "G", count: 31),
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CARDHOLDER])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyPan() {
        let params = CardParams(
            pan: "",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyCVC() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.EXPIRY])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithEmptyPubKey() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: ""
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidPan() {
        let params = CardParams(
            pan: "5INVALID19268PAN14792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.PAN])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidCVC() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "1AA",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "DDD",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalidFormat, result.errors[ParamField.EXPIRY])
    }

    func testShouldNotReturnErrorWhileGenerateInstanceWithCardWithOutDateExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/15",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testShouldNotReturnErrorWhileGenerateInstanceWithCardWithMaxOutDateExpiry() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/35",
            cardholder: "Joe Doe",
            pubKey: testPubKey
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testShouldReturnErrorWhileGenerateInstanceWithCardWithInvalidPubKey() {
        let params = CardParams(
            pan: "5391119268214792",
            cvc: "123",
            expiryMMYY: "12/25",
            cardholder: "Joe Doe",
            pubKey: "INVALIDPUBKEY"
        )
        
        let result = sdkCore.generateInstanceWithCard(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }

    func testShouldGenerateInstanceWithBinding() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123"
        )
        
        let result = sdkCore.generateInstanceWithBinding(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testShouldGenerateInstanceWithBindingWithoutCVC() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa"
        )
        
        let result = sdkCore.generateInstanceWithBinding(params: params)

        XCTAssertNotNil(result.token)
        XCTAssertTrue(result.errors.isEmpty)
    }
    
    func testShouldReturnErrorGenerateInstanceWithBindingWithEmptyBindingID() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "",
            cvc: "123"
        )
        
        let result = sdkCore.generateInstanceWithBinding(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.BINDING_ID])
    }

    func testShouldReturnErrorGenerateInstanceWithBindingWithEmptyPubKey() {
        let params = BindingParams(
            pubKey: "",
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123"
        )
        
        let result = sdkCore.generateInstanceWithBinding(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.required, result.errors[ParamField.PUB_KEY])
    }

    func testShouldReturnErrorGenerateInstanceWithBindingWithInvalidCVC() {
        let params = BindingParams(
            pubKey: testPubKey,
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "aaD"
        )
        
        let result = sdkCore.generateInstanceWithBinding(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.CVC])
    }

    func testShouldReturnErrorGenerateInstanceWithBindingWithInvalidPubKey() {
        let params = BindingParams(
            pubKey: "INVALIDPUBKEY",
            bindingId: "513b17f4-e32e-414f-8c74-936fd7027baa",
            cvc: "123"
        )
        
        let result = sdkCore.generateInstanceWithBinding(params: params)

        XCTAssertNil(result.token)
        XCTAssertFalse(result.errors.isEmpty)
        XCTAssertEqual(ValidationCodes.invalid, result.errors[ParamField.PUB_KEY])
    }
}
