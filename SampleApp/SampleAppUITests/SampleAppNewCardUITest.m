//
//  SampleAppNewCardUITest.m
//  SampleAppUITests
//
//  Created by Alex Korotkov on 5/17/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SampleAppNewCardUITest : XCTestCase

@end

@implementation SampleAppNewCardUITest {
  XCUIApplication *_app;
}

- (void)setUp {
  self.continueAfterFailure = NO;

  _app = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.rbs.demo"];
  [_app launch];
}

- (void)tearDown {
}

- (void)pressOnCell {
  [_app.cells.staticTexts[@"Open Light with bindings"].firstMatch tap];
}

- (void)testFillNewCardForm {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"22222222222222222"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];
  
  [_app.buttons[@"Custom purchase button"] tap];
  
  XCTAssertTrue([_app.alerts.element.label isEqualToString:@"SeToken"]);
}

- (void)testFillNewCardFormWithIncorrectLengthCardNumber {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"1234"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];
  
  [_app.buttons[@"Custom purchase button"] tap];
  
  XCTAssertTrue(_app.staticTexts[@"Card number length should be 16-19 digits"].exists);
}

- (void)testFillNewCardFormWithIncorrectCardNumber {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"1234567891011121334"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];
  
  [_app.buttons[@"Custom purchase button"] tap];
  
  XCTAssertTrue(_app.staticTexts[@"The card number is incorrect"].exists);
}

- (void)testFillNewCardFormWithIncorrectExpireDate {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"22222222222222222"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1220"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];
  
  [_app.buttons[@"Custom purchase button"] tap];
  
  XCTAssertTrue(_app.staticTexts[@"Card expiry date is incorrect"].exists);
}

- (void)testFillNewCardFormWithIncorrectCVC {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"22222222222222222"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@""];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];
  
  [_app.buttons[@"Custom purchase button"] tap];
  
  XCTAssertTrue(_app.staticTexts[@"CVC2/CVV2 is incorrect"].exists);
}

- (void)testFillNewCardFormWithIncorrectCardholder {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"22222222222222222"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@""];
  
  [_app.buttons[@"Custom purchase button"] tap];
  
  XCTAssertTrue(_app.staticTexts[@"The card holder is incorrect"].exists);
}

- (void)testFillNewCardAndMarkSaveCard {
  [self pressOnCell];
  
  [_app.buttons[@"New card"] tap];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"22222222222222222"];
  
  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];
  
  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];
  
  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];
  
  [_app.switches.firstMatch tap];
  
  [_app.buttons[@"Custom purchase button"] tap];
 
  XCUIElement *element = [_app.alerts.element.staticTexts elementBoundByIndex:1];
  
  XCTAssertTrue([element.label containsString:@"allowSaveCard = true"]);
}

- (void) testStaticTextWichAreSetInClientApp {
  [self pressOnCell];
    
  BOOL isExistBindingSectionText = _app.staticTexts[@"Your cards"].exists;
  BOOL isExistNewCardButtonText = _app.buttons[@"New card"].exists;
  
  [_app.buttons[@"New card"] tap];
  
  BOOL isExistPurchaseButtonText = _app.buttons[@"Custom purchase button"].exists;
  
  XCTAssertTrue(isExistBindingSectionText);
  XCTAssertTrue(isExistNewCardButtonText);
  XCTAssertTrue(isExistPurchaseButtonText);
}

- (void) testOnExistSaveCardSwitch {
  [_app.cells.staticTexts[@"The New Card form without save card"] tap];
  
  XCTAssertFalse(_app.staticTexts[@"Save card"].exists);
}

- (void) testOnExistCardholderTextField {
  [_app.cells.staticTexts[@"The New Card form without card holder"] tap];
  
  XCTAssertTrue(_app.switches.firstMatch.value);
  XCTAssertFalse(_app.staticTexts[@"Cardholder"].exists);
}


@end
