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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("true", mainScreen.resultText) }
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
            overrideCvc: "000",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("false", mainScreen.resultText) }
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
            overrideExpiry: "10/35",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("false", mainScreen.resultText) }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDK() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("true", mainScreen.resultText) }
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
            overrideCvc: "000",
            phoneNumber: "+35799902871",
            email: "test@test.com"
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
            overrideExpiry: "10/35",
            phoneNumber: "+35799902871",
            email: "test@test.com"
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.failFrictionless3DS
        ))
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.failFrictionless3DS
        ))
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("true", mainScreen.resultText) }
        
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("true", mainScreen.resultText) }
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
            overrideCvc: "000",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("false", mainScreen.resultText) }
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
            overrideExpiry: "10/35",
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert { XCTAssertEqual("false", mainScreen.resultText) }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithSessionId() {
        let sessionId = registerSessionAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        awaitAssert { XCTAssertTrue(webViewScreen.clickOnReturnToMerchant()) }
        
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
            overrideCvc: "000",
            phoneNumber: "+35799902871",
            email: "test@test.com"
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
            overrideExpiry: "10/35",
            phoneNumber: "+35799902871",
            email: "test@test.com"
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.failFrictionless3DS
        ))
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
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.failFrictionless3DS
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        let webViewScreen = ThreeDS1Screen(app: app)
        XCTAssertTrue(webViewScreen.clickOnReturnToMerchant())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentWithNewCardFrictionlessThreeDSNoUse3DS2SDKWithPreFilledMandatoryFields() {
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
            use3DS2SDK: false,
            email: email,
            mobilePhone: mobilePhone,
            billingPayerData: billingPayerData
        )
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.typeCardNumber(TestCardHelper.successFrictionless3DS2.pan))
        XCTAssertTrue(newCardScreen.typeCardExpiry(TestCardHelper.successFrictionless3DS2.expiry))
        XCTAssertTrue(newCardScreen.typeCardCVC(TestCardHelper.successFrictionless3DS2.cvc))
        
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
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
    
    func testShouldReturnSuccessPaymentWithSavedCardFrictionlessThreeDSNoUse3DS2SDKWithPreFilledMandatoryFields() {
        let clientId = testClientIdHelper.getNewTestClientId()
        
        var orderId = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        var mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        var paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successFrictionless3DS2,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
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
        
        orderId = registerOrderAndLaunchAppWithPreFilledBiilingData(
            clientId: clientId,
            use3DS2SDK: false,
            email: email,
            mobilePhone: mobilePhone,
            billingPayerData: billingPayerData
        )
        
        mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(
            paymentBottomSheet.clickOnCard(
                TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successFrictionless3DS2)
            )
        )
        
        let selectedCardScreen = SelectedCardScreen(app: app)
        XCTAssertTrue(selectedCardScreen.typeCardCVC(TestCardHelper.successSSL.cvc))
        
        XCTAssertEqual(selectedCardScreen.phoneNumberValue, mobilePhone)
        XCTAssertEqual(selectedCardScreen.emailValue, email)
        XCTAssertEqual(selectedCardScreen.countryValue, billingPayerData.billingCountry)
        XCTAssertEqual(selectedCardScreen.stateValue, billingPayerData.billingState)
        XCTAssertEqual(selectedCardScreen.postalCodeValue, billingPayerData.billingPostalCode)
        XCTAssertEqual(selectedCardScreen.cityValue, billingPayerData.billingCity)
        XCTAssertEqual(selectedCardScreen.addressLine1Value, billingPayerData.billingAddressLine1)
        XCTAssertEqual(selectedCardScreen.addressLine2Value, billingPayerData.billingAddressLine2)
        XCTAssertEqual(selectedCardScreen.addressLine3Value, billingPayerData.billingAddressLine3)

        XCTAssertTrue(selectedCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
    }
}
