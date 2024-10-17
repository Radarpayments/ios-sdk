//
//  PaymentThreeDSLogUseCaseTest.swift
//  SDKPaymentTestIntegrationUITests
//

import Foundation
import XCTest

final class PaymentThreeDSLogUseCaseTest: BaseTestCase {
    
    func testShouldReturnErrorPaymentWithNewCardFullThreeDSUse3DS2SDKWithLog() {
        let _ = registerOrderAndLaunchApp(use3DS2SDK: true, needsToLog: true)
        
        let mainScreen = TestMainScreen(app: app)
        XCTAssertTrue(mainScreen.clickOnCheckout())
        
        let paymentBottomSheet = PaymentBottomSheetScreen(app: app)
        XCTAssertTrue(paymentBottomSheet.clickOnAddNewCard())
        
        let newCardScreen = NewCardScreen(app: app)
        XCTAssertTrue(newCardScreen.fillOutForm(with: TestCardHelper.successFull3DS))
        XCTAssertTrue(newCardScreen.clickOnActionButton())
        
        var threeDSScreen = ThreeDSS2creen(app: app)
        XCTAssertTrue(threeDSScreen.typeSMSCode("000000"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        Thread.sleep(forTimeInterval: 3)
        XCTAssertTrue(threeDSScreen.typeSMSCode("000000"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        Thread.sleep(forTimeInterval: 3)
        XCTAssertTrue(threeDSScreen.typeSMSCode("000000"))
        XCTAssertTrue(threeDSScreen.clickOnConfirmButton())
        
        awaitAssert {
            XCTAssertEqual("false", mainScreen.resultText)
        }
        
        Thread.sleep(forTimeInterval: 6)
    }
}
