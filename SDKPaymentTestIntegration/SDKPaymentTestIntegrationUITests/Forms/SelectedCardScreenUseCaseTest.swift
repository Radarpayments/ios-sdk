//
//  SelectedCardScreenUseCaseTest.swift
//  SDKPaymentTestIntegrationUITests
//

import Foundation
import XCTest

final class SelectedCardScreenUseCaseTest: BaseTestCase {
    
    func testShouldSwitchToNextField() {
        let clientId = testClientIdHelper.getNewTestClientId()
        _ = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        var mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())

        var paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        _ = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(
            paymentBottomSheet.clickOnCard(
                TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successSSL)
            )
        )
        
        let selectedCardScreen = SelectedCardScreen(app: app)
        
        if selectedCardScreen.cardCvcNeedsToInput {
            XCTAssertTrue(newCardScreen.cardCvcIsFocused)
            XCTAssertTrue(app.keyboards.count > 0)

            XCTAssertTrue(newCardScreen.typeCardCVC(TestCardHelper.successFrictionless3DS2.cvc))
        }
        
        if selectedCardScreen.cardHolderIsExist {
            XCTAssertTrue(selectedCardScreen.cardHolderIsFocused)
            XCTAssertTrue(app.keyboards.count > 0)
            
            XCTAssertTrue(newCardScreen.typeCardHolder(TestCardHelper.successFrictionless3DS2.holder))
            app.keyboards.firstMatch.buttons["return"].tap()
        }

        XCTAssertTrue(newCardScreen.phoneNumberIsFocused)
    }
    
    func testShouldEndEditingAfterInputTextAndTapReturn() {
        let clientId = testClientIdHelper.getNewTestClientId()
        _ = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        
        var mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())

        var paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(
            with: TestCardHelper.successSSL,
            phoneNumber: "+35799902871",
            email: "test@test.com"
        ))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        awaitAssert {
            XCTAssertEqual("true", mainScreen.resultText)
        }
        
        _ = registerOrderAndLaunchApp(clientId: clientId, use3DS2SDK: false)
        mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(
            paymentBottomSheet.clickOnCard(
                TestCardHelper.getLabelForSavedCardFrom(testCard: TestCardHelper.successSSL)
            )
        )
        
        let selectedCardScreen = SelectedCardScreen(app: app)
        
        if selectedCardScreen.cardCvcNeedsToInput {
            XCTAssertTrue(newCardScreen.cardCvcIsFocused)
            XCTAssertTrue(app.keyboards.count > 0)

            XCTAssertTrue(newCardScreen.typeCardCVC(TestCardHelper.successFrictionless3DS2.cvc))
        }
        
        if selectedCardScreen.cardHolderIsExist {
            XCTAssertTrue(selectedCardScreen.cardHolderIsFocused)
            XCTAssertTrue(app.keyboards.count > 0)
            
            XCTAssertTrue(newCardScreen.typeCardHolder(TestCardHelper.successFrictionless3DS2.holder))
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
