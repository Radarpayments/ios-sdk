//
//  PaymentCommonUseCaseTest.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class PaymentCommonUseCaseTest: BaseTestCase {

    func testShouldReturnAlreadyPaymentException() {
        let orderId = try! testOrderHelper.preparePayedOrder()
        
        let paymentConfig = getDefaultPaymentConfig()
        let encodedPaymentConfig = testOrderHelper.encodeConfig(
             paymentConfig: paymentConfig
        )
        
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        app.launchEnvironment = [
            "paymentConfig": encodedPaymentConfig,
            "orderId": orderId
        ]
        app.launch()

        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnOrderNotExistException() {
        let orderId = UUID().uuidString
        let paymentConfig = getDefaultPaymentConfig()
        let encodedPaymentConfig = testOrderHelper.encodeConfig(
            paymentConfig: paymentConfig
        )
        
        app = XCUIApplication()
        app.launchArguments = ["-uiTesting"]
        app.launchEnvironment = [
            "paymentConfig": encodedPaymentConfig,
            "orderId": orderId
        ]
        app.launch()
        
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentExceptionWhenPressBackButtonAtCardForm() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.clickOnBackButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
}
