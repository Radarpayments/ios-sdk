//
//  PaymentCardFullThreeDSUseCaseTest.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class PaymentCardFullThreeDSUseCaseTest: BaseTestCase {
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSUse3DS2SDK() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFull3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSUse3DS2SDKWithInvalidCVC() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSUse3DS2SDKWithInvalidExpiry() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFull3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSNoUse3DS2SDKWithInvalidCVC() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
         
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSNoUse3DS2SDKWithInvalidExpiry() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
}
