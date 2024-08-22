//
//  PaymentCardAttemptThreeDSUseCaseTest.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest
import SDKPayment

final class PaymentCardAttemptThreeDSUseCaseTest: BaseTestCase {
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSUse3DS2SDK() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)

        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                phoneNumber: "35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(
            newCardScreen.fillOutMandatoryFields(
                country: "Germany",
                state: "DE-BE",
                postalCode: "26133",
                city: "Berlin",
                addressLine1: "Billing Address Line 1",
                addressLine2: "Billing Address Line 2",
                addressLine3: "Billing Address Line 3"
            )
        )
        
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSUse3DS2SDKWithInvalidCVC() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successAttempt3DS,
            overrideCvc: "000",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSUse3DS2SDKWithInvalidExpiry() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                overrideExpiry: "10/35",
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())

        XCTAssertTrue(ThreeDS1Screen(app: app)
            .clickOnSuccess())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithInvalidCVC() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                overrideCvc: "000",
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())

        XCTAssertTrue(ThreeDS1Screen(app: app)
            .clickOnSuccess())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithInvalidExpiry() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                overrideExpiry: "10/35",
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        XCTAssertTrue(ThreeDS1Screen(app: app)
            .clickOnSuccess())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)

        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                overrideCvc: "000",
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                overrideExpiry: "10/35",
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(
            newCardScreen.fillOutForm(
                with: TestCardHelper.successAttempt3DS,
                phoneNumber: "+35799902871",
                email: "test@test.com"
            )
        )
        XCTAssertTrue(newCardScreen.clickOnActionButton())

        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successAttempt3DS,
            overrideCvc: "000",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())

        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successAttempt3DS,
            overrideExpiry: "10/35",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
}
