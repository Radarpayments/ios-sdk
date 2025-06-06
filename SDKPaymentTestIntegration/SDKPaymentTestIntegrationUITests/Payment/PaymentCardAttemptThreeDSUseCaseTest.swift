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
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp()
        
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
        
        awaitAssert {
            XCTAssertTrue(
                ThreeDS1Screen(app: app)
                    .clickOnSuccess()
            )
        }
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithInvalidCVC() {
        let _ = registerOrderAndLaunchApp()
        
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
        let _ = registerOrderAndLaunchApp()
        
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
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp()
        
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
        let sessionId = registerSessionAndLaunchApp()
        
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
        let sessionId = registerSessionAndLaunchApp()
        
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
    
    func testShouldReturnSuccessPaymentWithNewCardAttemptThreeDSNoUse3DS2SDKWithPreFilledMandatoryFields() {
        let email = "test@test.com"
        let mobilePhone = "+35799902871"
        let billingPayerData = BillingPayerData(
            billingCountry: "Germany",
            billingState: "DE-BE",
            billingCity: "Berlin",
            billingPostalCode: "26133",
            billingAddressLine1: "Billing Address Line 1",
            billingAddressLine2: "Billing Address Line 2",
            billingAddressLine3: "Billing Address Line 3"
        )
        
        let orderId = registerOrderAndLaunchAppWithPreFilledBiilingData(
            email: email,
            mobilePhone: mobilePhone,
            billingPayerData: billingPayerData
        )
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.typeCardNumber(TestCardHelper.successAttempt3DS.pan))
        XCTAssertTrue(newCardScreen.typeCardExpiry(TestCardHelper.successAttempt3DS.expiry))
        XCTAssertTrue(newCardScreen.typeCardCVC(TestCardHelper.successAttempt3DS.cvc))
        
        XCTAssertEqual(newCardScreen.phoneNumberValue, mobilePhone)
        XCTAssertEqual(newCardScreen.emailValue, email)
        XCTAssertEqual(newCardScreen.countryValue, billingPayerData.billingCountry)
        XCTAssertEqual(newCardScreen.stateValue, billingPayerData.billingState)
        XCTAssertEqual(newCardScreen.postalCodeValue, billingPayerData.billingPostalCode)
        XCTAssertEqual(newCardScreen.cityValue, billingPayerData.billingCity)
        XCTAssertEqual(newCardScreen.addressLine1Value, billingPayerData.billingAddressLine1)
        XCTAssertEqual(newCardScreen.addressLine2Value, billingPayerData.billingAddressLine2)
        XCTAssertEqual(newCardScreen.addressLine3Value, billingPayerData.billingAddressLine3)
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertTrue(
                ThreeDS1Screen(app: app)
                    .clickOnSuccess()
            )
        }
        
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
}
