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
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successSSL))
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
        
        XCTAssertTrue(app.keyboards.count == 0)
    }
}
