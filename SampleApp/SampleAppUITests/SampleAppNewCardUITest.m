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
  NSString *_newCardString;
  NSString *_cardNumberString;
  NSString *_expireDateString;
  NSString *_cvcString;
  NSString *_buttonTitleString;
}

- (void)setUp {
  self.continueAfterFailure = NO;
  _app = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.rbs.demo"];
  
  _newCardString =  @"Add new card";
  _cardNumberString = @"Card number";
  _expireDateString =  @"MM/YY";
  _cvcString =  @"CVC";
  _buttonTitleString =  @"Submit payment";
  _cardNumberString = @"Card number";

  [_app launch];
}

- (void)tearDown {
}

- (void)pressOnCell {
  [_app.cells.staticTexts[@"Light theme with bindings"].firstMatch tap];
}

- (void)testFillNewCardForm {
  [self pressOnCell];
  
  [_app.cells.staticTexts[_newCardString].firstMatch tap];

  [_app.textFields[_cardNumberString] tap];
  [_app.textFields[_cardNumberString] typeText:@"22222222222222222"];
  
  [_app.textFields[_expireDateString] tap];
  [_app.textFields[_expireDateString] typeText:@"1224"];
  
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@"123"];
  
  [_app.buttons[_buttonTitleString] tap];
  
  XCTAssertTrue([_app.alerts.element.label isEqualToString:@"SeToken"]);
}

- (void)testFillNewCardFormWithIncorrectLengthCardNumber {
  [self pressOnCell];
  
  [_app.cells.staticTexts[_newCardString].firstMatch tap];

  [_app.textFields[_cardNumberString] tap];
  [_app.textFields[_cardNumberString] typeText:@"1234"];
  
  [_app.textFields[_expireDateString] tap];
  [_app.textFields[_expireDateString] typeText:@"1224"];
  
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@"123"];
  
  [_app.buttons[_buttonTitleString] tap];
  
             
  XCTAssertTrue(_app.staticTexts[@"Card number length should be 16-19 digits"].exists);
}

- (void)testFillNewCardFormWithIncorrectCardNumber {
  [self pressOnCell];
  
  [_app.cells.staticTexts[_newCardString].firstMatch tap];

  [_app.textFields[_cardNumberString] tap];
  [_app.textFields[_cardNumberString] typeText:@"12211"];
//
  [_app.textFields[_expireDateString] tap];
  [_app.textFields[_expireDateString] typeText:@"1230"];
  
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@"123"];
  
  [_app.buttons[_buttonTitleString] tap];
  
  
  XCTAssertTrue(_app.staticTexts[@"Card number length should be 16-19 digits"].exists);
}

- (void)testFillNewCardFormWithIncorrectExpireDate {
  [self pressOnCell];
  
  [_app.cells.staticTexts[_newCardString].firstMatch tap];
  
  [_app.textFields[_cardNumberString] tap];
  [_app.textFields[_cardNumberString] typeText:@"22222222222222222"];
  
  [_app.textFields[_expireDateString] tap];
  [_app.textFields[_expireDateString] typeText:@"1220"];
  
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@"123"];
  
  [_app.buttons[_buttonTitleString] tap];
  
  XCTAssertTrue(_app.staticTexts[@"Card expiry date is incorrect"].exists);
}

- (void)testFillNewCardFormWithIncorrectCVC {
  [self pressOnCell];
  
  [_app.cells.staticTexts[_newCardString].firstMatch tap];
  
  [_app.textFields[_cardNumberString] tap];
  [_app.textFields[_cardNumberString] typeText:@"22222222222222222"];
  
  [_app.textFields[_expireDateString] tap];
  [_app.textFields[_expireDateString] typeText:@"1230"];
  
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@""];
  
  [_app.buttons[_buttonTitleString] tap];
  
  XCTAssertTrue(_app.staticTexts[@"CVC2/CVV2 is incorrect"].exists);
}


- (void)testFillNewCardAndMarkSaveCard {
  [self pressOnCell];
  
  [_app.cells.staticTexts[_newCardString].firstMatch tap];

  [_app.textFields[_cardNumberString] tap];
  [_app.textFields[_cardNumberString] typeText:@"22222222222222222"];
  
  [_app.textFields[_expireDateString] tap];
  [_app.textFields[_expireDateString] typeText:@"1224"];
  
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@"123"];
  
  [_app.switches.firstMatch tap];
  
  [_app.buttons[_buttonTitleString] tap];
 
  XCUIElement *element = [_app.alerts.element.staticTexts elementBoundByIndex:1];
  
  XCTAssertTrue([element.label containsString:@"allowSaveCard = true"]);
}


@end
