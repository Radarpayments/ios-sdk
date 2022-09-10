//
//  SampleAppUITests.m
//  SampleAppUITests
//
//  Created by Alex Korotkov on 5/17/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SampleAppUITests : XCTestCase

@end

@implementation SampleAppUITests {
  XCUIApplication *_app;
  NSString *_cvcString;
  NSString *_buttonTitleString;
}

- (void)setUp {
  self.continueAfterFailure = NO;
  _cvcString =  @"CVC";
  _buttonTitleString =  @"Submit payment";

  _app = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.rbs.demo"];
  [_app launch];
}

- (void)tearDown {
}

- (void)openCellWithEditMode {
  [_app.cells.staticTexts[@"Light theme with edit mode"] tap];
  [_app.cells.staticTexts[@"All payment methods"] tap];
}

- (void)openCellWithBindingsCVCField {
  [_app.cells.staticTexts[@"Light theme with bindings"] tap];
  [_app.cells.staticTexts[@"All payment methods"] tap];
}

- (void)_fillCVCField {
  [_app.secureTextFields[_cvcString] tap];
  [_app.secureTextFields[_cvcString] typeText:@"123"];
}

- (void)_submit {
  [_app.buttons[_buttonTitleString] tap];
}

- (void)_pressOnFirstCard {
  XCUIElement *cell = [[[_app.tables elementBoundByIndex:1] cells] elementBoundByIndex:0];
  
  [cell tap];
}

- (void)_removeFirstCard {
  [[[[_app.tables elementBoundByIndex:1] buttons] elementBoundByIndex:0] tap];
}

- (NSInteger)_countBindings {
  return  [[[_app.tables elementBoundByIndex:1] buttons] count];
}
- (void)_pressEditTab {
  [_app.buttons[@"Edit"] tap];
}

- (void)_pressOnDeleteButton {
  sleep(2);
  
  [_app.buttons[@"Delete"] tap];
}

- (void)testChooseBindingWithoutCVCGetSeToken {
  [self openCellWithEditMode];

  [self _pressOnFirstCard];
  
  [self _submit];

  XCTAssertTrue([_app.alerts.element.label isEqualToString:@"SeToken"]);
}

- (void)testRemoveOneBinding {
  [self openCellWithEditMode];
  
  [_app.buttons[@"Edit"] tap];
  
  [self _removeFirstCard];
  sleep(2);
  
  [_app.buttons[@"Delete"] tap];
  
  [_app.buttons[@"Save"] tap];
  
  XCTAssertTrue([_app.buttons[@"Edit"] isEnabled]);
}

- (void)testRemoveAllBindingsOnEditMode {
  [self openCellWithEditMode];
  
  [self _pressEditTab];

  [self _removeFirstCard];
  
  [self _pressOnDeleteButton];
  
  [self _removeFirstCard];
  
  [self _pressOnDeleteButton];
  
  [_app.buttons[@"Save"] tap];
  
  XCTAssertFalse([_app.buttons[@"Edit"] isEnabled]);
}


- (void)testChooseBindingFillCVCAndGenerateSeToken {
  [self openCellWithBindingsCVCField];
  
  [self _pressOnFirstCard];
  
  [self _fillCVCField];
  
  [self _submit];

  XCTAssertTrue([_app.alerts.element.label isEqualToString:@"SeToken"]);
}

@end
