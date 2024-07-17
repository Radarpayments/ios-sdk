//
//  PaymentCardFrictionlessThreeDSUseCaseTest.swift
//  SDKPaymentIntegrationUITests
//
//
//

import Foundation
import XCTest
import SDKPayment

final class PaymentCardFrictionlessThreeDSUseCaseTest: BaseTestCase {
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSUse3DS2SDK() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFrictionless3DS2))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSUse3DS2SDKWithInvalidCVC() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
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
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSUse3DS2SDKWithInvalidExpiry() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
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
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFrictionless3DS2))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithInvalidCVC() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithInvalidExpiry() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessFailThreeDSUse3DS2SDK() {
        let orderId = registerOrderAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.failFrictionless3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessFailThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.failFrictionless3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }

    func testShouldSaveNewCardFrictionlessThreeDSNoUse3DS2SDK() {
        let clientId = testClientIdHelper.getNewTestClientId()
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFrictionless3DS2))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        let sessionStatus = try! testOrderHelper.getSessionStatus(mdOrder: orderId)

        awaitAssert {
            XCTAssertEqual(
                sessionStatus.bindingItems.first?.label,
                TestCardHelper.getLabelForSavedBindingItemFrom(
                    testCard: TestCardHelper.successFrictionless3DS2
                )
            )
        }
    }

    func testShouldSaveNewCardFrictionlessThreeDSUse3Ds2() {
        let clientId = testClientIdHelper.getNewTestClientId()
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())

        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFrictionless3DS2))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: true)
        let sessionStatus = try! testOrderHelper.getSessionStatus(mdOrder: orderId)
        
        awaitAssert {
            XCTAssertEqual(
                sessionStatus.bindingItems.first?.label,
                TestCardHelper.getLabelForSavedBindingItemFrom(
                    testCard: TestCardHelper.successFrictionless3DS2)
            )
        }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFrictionless3DS2))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("123456"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
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
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
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
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFrictionless3DS2))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithInvalidCVCWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            overrideCvc: "000"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithInvalidExpiryWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            overrideExpiry: "10/35"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessFailThreeDSUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.failFrictionless3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnErrorPaymentWithNewCardFrictionlessFailThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.failFrictionless3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
}
