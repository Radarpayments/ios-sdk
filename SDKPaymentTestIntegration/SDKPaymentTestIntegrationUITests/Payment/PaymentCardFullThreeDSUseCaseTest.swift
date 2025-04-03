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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS
        ))
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS
        ))
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
        awaitAssert { XCTAssertTrue(webViewScreen.clickOnSuccess()) }
        
        awaitAssert { XCTAssertEqual("false", mainScreen.resultText) }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)

        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckoutSession())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
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
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
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
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnSuccess())
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSNoUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
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
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSNoUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
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
        awaitAssert { XCTAssertTrue(webViewScreen.clickOnSuccess()) }
        awaitAssert { XCTAssertTrue(webViewScreen.clickOnReturnToMerchant()) }
        
        awaitAssert { XCTAssertEqual("false", mainScreen.resultText) }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSNoUse3DS2SDKAndRemoveBindingCard() {
        let clientId = testClientIdHelper.getNewTestClientId()
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFull3DS
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDS1Screen = ThreeDS1Screen(app: app)
        
        awaitAssert { XCTAssertTrue(threeDS1Screen.clickOnSuccess()) }
        awaitAssert { XCTAssertEqual("true", mainScreen.resultText) }
        
        let labelForSavedBindingItem = TestCardHelper.getLabelForSavedBindingItemFrom(
            testCard: TestCardHelper.successFull3DS
        )
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        var sessionStatus = try! testOrderHelper.getSessionStatus(mdOrder: orderId)
        
        let bindingItemLabel = sessionStatus.bindingItems.first?.label
        awaitAssert { XCTAssertEqual(bindingItemLabel, labelForSavedBindingItem) }
        
        XCTAssertTrue(mainScreen.clickOnCheckout())
        awaitAssert { XCTAssertTrue(paymentBottomSheet.clickOnAllPaymentMethods()) }
        
        let cardListScreen = CardListScreen(app: app)
        let labelForSavedCard = TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successFull3DS)
        
        awaitAssert { XCTAssertTrue(cardListScreen.swipeOnSavedCard(labelForSavedCard)) }
        awaitAssert { XCTAssertTrue(cardListScreen.tapToDelete()) }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        sessionStatus = try! testOrderHelper.getSessionStatus(mdOrder: orderId)
        
        awaitAssert {
            XCTAssertNil(sessionStatus.bindingItems.first(where: { $0.label == labelForSavedBindingItem }))
        }
    }
}
