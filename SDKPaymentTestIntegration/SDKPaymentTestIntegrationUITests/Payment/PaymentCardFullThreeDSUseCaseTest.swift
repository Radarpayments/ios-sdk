//
//  PaymentCardFullThreeDSUseCaseTest.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class PaymentCardFullThreeDSUseCaseTest: BaseTestCase {
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp()
        
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
        let _ = registerOrderAndLaunchApp()
        
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
        let _ = registerOrderAndLaunchApp()
        
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
    
    func testShouldReturnSuccessPaymentWithNewCardFullThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp()
        
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
        let sessionId = registerSessionAndLaunchApp()
        
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
        let sessionId = registerSessionAndLaunchApp()
        
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
        var orderId = registerOrderAndLaunchApp(clientId: clientId)
        
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
        
        orderId = registerOrderAndLaunchApp(clientId: clientId)
        var sessionStatus = try! testOrderHelper.getSessionStatus(mdOrder: orderId)
        
        let bindingItemLabel = sessionStatus.bindingItems.first?.label
        awaitAssert { XCTAssertEqual(bindingItemLabel, labelForSavedBindingItem) }
        
        XCTAssertTrue(mainScreen.clickOnCheckout())
        awaitAssert { XCTAssertTrue(paymentBottomSheet.clickOnAllPaymentMethods()) }
        
        let cardListScreen = CardListScreen(app: app)
        let labelForSavedCard = TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successFull3DS)
        
        awaitAssert { XCTAssertTrue(cardListScreen.swipeOnSavedCard(labelForSavedCard)) }
        awaitAssert { XCTAssertTrue(cardListScreen.tapToDelete()) }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId)
        sessionStatus = try! testOrderHelper.getSessionStatus(mdOrder: orderId)
        
        awaitAssert {
            XCTAssertNil(sessionStatus.bindingItems.first(where: { $0.label == labelForSavedBindingItem }))
        }
    }
}
