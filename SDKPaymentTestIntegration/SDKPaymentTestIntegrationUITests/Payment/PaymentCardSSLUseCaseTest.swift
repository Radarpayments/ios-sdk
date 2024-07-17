//
//  PaymentCardSSLUseCaseTest.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest

final class PaymentCardSSLUseCaseTest: BaseTestCase { 
    
    func testShouldReturnSuccessPaymentResultWithNewCardSSLWithUse3DS2SDK() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)

        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithUse3DS2SDKWithInvalidCVC() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithUse3DS2SDKWithInvalidExpiry() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentResultWithNewCardSSLWithUse3DS2SDKWithSaveCard() {
        let clientId = testClientIdHelper.getNewTestClientId()
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: true)
        
        var mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        var paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())

        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: true)
        mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())

        paymentBottomSheet = PaymentBottomSheetScreen(app: app)

        awaitAssert {
            XCTAssertTrue(
                paymentBottomSheet.clickOnCard(
                    TestCardHelper.getLabelForSavedCardFrom(
                        testCard: TestCardHelper.successSSL
                    )
                )
            )
        }
        
        let selectedCardScreen = SelectedCardScreen(app: app)
        XCTAssertTrue(selectedCardScreen.typeCardCVC(TestCardHelper.successSSL.cvc))
        XCTAssertTrue(selectedCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentResultWithNewCardSSLWithNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithInvalidCVC() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithInvalidExpiry() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithSaveCard() {
        let clientId = testClientIdHelper.getNewTestClientId()
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        var mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())

        var paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(
            paymentBottomSheet.clickOnCard(
                TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successSSL)
            )
        )
        
        let selectedCardScreen = SelectedCardScreen(app: app)
        XCTAssertTrue(selectedCardScreen.typeCardCVC(TestCardHelper.successSSL.cvc))
        XCTAssertTrue(selectedCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithSaveCardWithInvalidCVC() {
        let clientId = testClientIdHelper.getNewTestClientId()
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        var mainScreen = TestMainScreen(app: app)
        XCTAssertTrue( mainScreen.clickOnCheckout())

        var paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())

        paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(
            paymentBottomSheet.clickOnCard(
                TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successSSL)
            )
        )
        
        let selectedCardScreen = SelectedCardScreen(app: app)
        XCTAssertTrue(selectedCardScreen.typeCardCVC("000"))
        XCTAssertTrue(selectedCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentResultWithNewCardSSLWithUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)

        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentResultWithNewCardSSLWithNoUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
}
