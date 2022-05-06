//
//  SampleApp3DSSDKTest.m
//  SampleAppUITests
//
//  Created by Alex Korotkov on 5/17/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SampleApp3DSSDKTest : XCTestCase

@end

@implementation SampleApp3DSSDKTest {
  XCUIApplication *_app;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
}

- (void)setUp {
  self.continueAfterFailure = NO;

  _app = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.anjlab.SampleApp"];
  [_app launch];
  
  _bundle = [NSBundle bundleForClass:[SampleApp3DSSDKTest class]];

  NSString *language = _app.accessibilityLanguage;
  
  if (language != nil) {
    _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
  } else {
    _languageBundle = _bundle;
  }
}

- (void)tearDown {
}

- (void) _runFlowWithBindingWithCVC:(NSString *) cvc {
  [[_app.buttons elementBoundByIndex:1] tap];
  
  [self _tapWaitingElement:_app.cells.firstMatch];

  XCUIElement *cellWithBindingInfo = [_app.cells elementBoundByIndex:0];

  [cellWithBindingInfo tap];
  [cellWithBindingInfo typeText:cvc];

  XCUIElement *cell = [_app.cells elementBoundByIndex:1];

  [cell tap];
}

- (void) _runFlowWithBinding {
  [[_app.buttons elementBoundByIndex:1] tap];

  [self _tapWaitingElement:_app.cells.firstMatch];

  XCUIElement *cellWithBindingInfo = [_app.cells elementBoundByIndex:0];

  [cellWithBindingInfo tap];
  [cellWithBindingInfo typeText:@"123"];

  XCUIElement *cell = [_app.cells elementBoundByIndex:1];

  [cell tap];
}

- (void) _fillNewCardForm {
  [self _tapWaitingElement:_app.buttons[@"New card"]];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"5777777777777775"];

  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];

  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"123"];

  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];

  [_app.buttons.allElementsBoundByIndex.lastObject tap];
}

- (void) _fillNewCardFormWithIncorrectCVC {
  [self _tapWaitingElement:_app.buttons[@"New card"]];

  [_app.textFields[@"Number"] tap];
  [_app.textFields[@"Number"] typeText:@"5777777777777775"];

  [_app.textFields[@"MM/YY"] tap];
  [_app.textFields[@"MM/YY"] typeText:@"1224"];

  [_app.secureTextFields[@"CVC"] tap];
  [_app.secureTextFields[@"CVC"] typeText:@"666"];

  [_app.textFields[@"NAME"].firstMatch tap];
  [_app.textFields[@"NAME"] typeText:@"ALEX KOROTKOV"];

  [_app.buttons.allElementsBoundByIndex.lastObject tap];
}

- (void) _openKindPaymentController {
  [self _tapWaitingElement:[_app.buttons elementBoundByIndex:1]];
}

- (void) _tapOnCellWithOnePasscodeFlow {
  [_app.cells.staticTexts[@"One time passcode (amount: 2000)"] tap];
}

- (void) _openPassCodeFlowWithNewCard {
  [self _tapOnCellWithOnePasscodeFlow];
  [self _openKindPaymentController];
  [self _fillNewCardForm];
}

- (void) _runFlowWithCheckBoxsWithNewCard {
  [_app.cells.allElementsBoundByAccessibilityElement[13] tap];
  [self _openKindPaymentController];
  [self _fillNewCardForm];
}

- (void) _runFlowWithRadioButtonsWithNewCard {
  [_app.cells.staticTexts[@"Single select (amount: 111)"] tap];
  [self _openKindPaymentController];
  [self _fillNewCardForm];
}

- (void) _openPassCodeFlowWithIncorrectNewCard {
  [self _tapOnCellWithOnePasscodeFlow];
  [self _openKindPaymentController];
  [self _fillNewCardFormWithIncorrectCVC];
}

- (void) _runPassCodeFlow {
  [self _tapOnCellWithOnePasscodeFlow];
  [self _runFlowWithBinding];
}

- (void) _runFlowWithCheckBoxs {
  [_app swipeUp];
  [_app.cells.staticTexts[@"Multi-Select (amount: 222)"] tap];
  [self _runFlowWithBinding];
}

- (void) _runFlowWithRadioButtons {
  [_app swipeUp];
  [_app.cells.staticTexts[@"Single Select (amount: 111)"] tap];
  [self _runFlowWithBinding];
}

- (void) _runPassCodeFlowWithIncorrectCVC {
  [self _tapOnCellWithOnePasscodeFlow];
  [self _runFlowWithBindingWithCVC: @"666"];
}

- (void) _pressConfirmButton {
  [self _tapWaitingElement:_app.buttons[@"Confirm"]];
}

- (void) _pressResendSMSButton {
  [_app.buttons[@"Send SMS again"] tap];
}

- (void) _fillTextFieldCorrectCode {
  XCUIElement *textField = [_app.textFields elementBoundByIndex:0];
 
  if ([textField waitForExistenceWithTimeout:150]) {
    [textField tap];

    [textField typeText:@"123456"];
  };
}

- (void) _fillTextFieldIncorrectCode {
  XCUIElement *textField = [_app.textFields elementBoundByIndex:0];
  
  if ([textField waitForExistenceWithTimeout:150]) {
    [textField tap];

    [textField typeText:@"1234"];
  };
}

- (void) _fillTextFieldResentCode {
  XCUIElement *textField = [_app.textFields elementBoundByIndex:0];
  
  if ([textField waitForExistenceWithTimeout:150]) {
    [textField tap];

    [textField typeText:@"111111"];
  };
}

- (void) _sleep:(NSTimeInterval) timeInterval {
  [NSThread sleepForTimeInterval:timeInterval];
}

- (void) _tapWaitingElement:(XCUIElement *) element {
  if ([element waitForExistenceWithTimeout:100]) {
    [element tap];
  };
}

- (NSString *) _alertLable {
  return _app.alerts.element.label;
}

- (void) _checkAlertLabel:(NSString *) alert {
  if ([_app.alerts.element waitForExistenceWithTimeout:150]) {
    XCTAssertTrue([_app.alerts.element.label isEqualToString:alert]);
  };
}

- (NSString *) _textDescrition {
  return [_app.staticTexts elementBoundByIndex:3].label;
}

- (void) testRunThreeDSSDKFlowWithBinding {
  [self _runPassCodeFlow];
  
  [self _fillTextFieldCorrectCode];
  
  [self _pressConfirmButton];
 
  [self _checkAlertLabel:@"Success"];
}

- (void) testRunThreeDSSDKFlowWithBindingWithIncorrectCVC {
  [self _runPassCodeFlowWithIncorrectCVC];
  
  [self _fillTextFieldCorrectCode];
  
  [self _pressConfirmButton];
  
  [self _checkAlertLabel:@"Error"];
}

- (void) testRunThreeDSSDKFlowWithBindingWithIncorrectSMSCode {
  [self _runPassCodeFlow];
  
  [self _fillTextFieldIncorrectCode];
  
  NSString *textDescritionBeforeError = [self _textDescrition];
  
  [self _pressConfirmButton];
 
  [self _sleep:5];
  
  XCTAssertFalse([textDescritionBeforeError isEqualToString:[self _textDescrition]]);
}

- (void) testRunThreeDSSDKFlowWithBindingWithFillIncorrectCodeUntilCancelFlow {
  [self _runPassCodeFlow];
  
  for (NSInteger i = 0; i < 3; i++) {
    [self _fillTextFieldIncorrectCode];
    [self _pressConfirmButton];
    [self _sleep:5];
  }
  
  [self _checkAlertLabel:@"Cancel"];
}

- (void) testRunResendMessageFlow {
  [self _runPassCodeFlow];
  
  [self _fillTextFieldIncorrectCode];
  
  [self _pressResendSMSButton];
  
  [self _sleep:5];

  [self _fillTextFieldResentCode];
  
  [self _pressConfirmButton];

  [self _checkAlertLabel:@"Success"];
}

- (void) testRunSingleSelectFlowWithBinding{
  [self _runFlowWithRadioButtons];

  [self _tapWaitingElement:[_app.otherElements elementBoundByIndex:10]];

  [self _pressConfirmButton];
  
  [self _checkAlertLabel:@"Success"];
}

- (void) testRunSingleSelectFlowWithBindingNoSelectButtons{
  [self _runFlowWithRadioButtons];

  [self _pressConfirmButton];
  
  [self _checkAlertLabel:@"Success"];
}

- (void) testRunMultiSelectFlowWithBinding{
  [self _runFlowWithCheckBoxs];

  [self _tapWaitingElement:[_app.otherElements elementBoundByIndex:10]];

  [self _pressConfirmButton];

  [self _checkAlertLabel:@"Success"];
}

- (void) testRunMultiSelectFlowWithBindingNoSelectCheckBoxs{
  [self _runFlowWithCheckBoxs];

  [self _pressConfirmButton];

  [self _checkAlertLabel:@"Success"];
}

- (void)testFillNewCardForm {
  [self _openPassCodeFlowWithNewCard];
  
  [self _fillTextFieldCorrectCode];
  
  [self _pressConfirmButton];
  
  [self _checkAlertLabel:@"Success"];
}

- (void)testFillNewCardFormWithIncorrectCVC {
  [self _openPassCodeFlowWithIncorrectNewCard];
  
  [self _fillTextFieldCorrectCode];

  [self _pressConfirmButton];

  [self _checkAlertLabel:@"Error"];
}

@end
