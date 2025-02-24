//
//  NewCardScreenUseCaseTest.swift
//  SDKPaymentTestIntegrationUITests

import Foundation
import XCTest

final class NewCardScreenUseCaseTest: BaseTestCase {
    
    func testShouldSwitchToNextField() {
        _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        
        XCTAssertTrue(newCardScreen.cardNumberIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardNumber(TestCardHelper.successFrictionless3DS2.pan))
        XCTAssertTrue(newCardScreen.cardExpiryIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardExpiry(TestCardHelper.successFrictionless3DS2.expiry))
        XCTAssertTrue(newCardScreen.cardCvcIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardCVC(TestCardHelper.successFrictionless3DS2.cvc))
        
        if newCardScreen.cardHolderIsExist {
            XCTAssertTrue(newCardScreen.cardHolderIsFocused)
            XCTAssertTrue(app.keyboards.count > 0)
            
            XCTAssertTrue(newCardScreen.typeCardHolder("TEST TEST"))
            app.keyboards.firstMatch.buttons["return"].tap()
        }

        XCTAssertTrue(newCardScreen.phoneNumberIsFocused)
    }
    
    func testShouldNotSwitchToExpiryField() {
        _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        
        XCTAssertTrue(newCardScreen.cardNumberIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardNumber(TestCardHelper.uncorrectNumberCard.pan))
        XCTAssertFalse(newCardScreen.cardExpiryIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
    }
    
    func testShouldEndEditingAfterInputTextAndTapReturn() {
        _ = registerOrderAndLaunchApp(use3DS2SDK: false)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        
        XCTAssertTrue(newCardScreen.cardNumberIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardNumber(TestCardHelper.successFrictionless3DS2.pan))
        XCTAssertTrue(newCardScreen.cardExpiryIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardExpiry(TestCardHelper.successFrictionless3DS2.expiry))
        XCTAssertTrue(newCardScreen.cardCvcIsFocused)
        XCTAssertTrue(app.keyboards.count > 0)
        
        XCTAssertTrue(newCardScreen.typeCardCVC(TestCardHelper.successFrictionless3DS2.cvc))
        
        if newCardScreen.cardHolderIsExist {
            XCTAssertTrue(newCardScreen.cardHolderIsFocused)
            XCTAssertTrue(app.keyboards.count > 0)
            
            XCTAssertTrue(newCardScreen.typeCardHolder("TEST TEST"))
            app.keyboards.firstMatch.buttons["return"].tap()
        }
        
        XCTAssertTrue(newCardScreen.phoneNumberIsFocused)
        XCTAssertTrue(newCardScreen.typePhoneNumber("+35799902871"))
        
        XCTAssertTrue(newCardScreen.typeEmail("test@test.com"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typeCountry("Germany"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typeState("DE-BE"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typePostalCode("26133"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typeCity("Berlin"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typeAddressLine1("Billing Address Line 1"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typeAddressLine2("Billing Address Line 2"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
        
        XCTAssertTrue(newCardScreen.typeAddressLine3("Billing Address Line 3"))
        app.keyboards.firstMatch.buttons["return"].tap()
        XCTAssertTrue(app.keyboards.count == 0)
    }
}
