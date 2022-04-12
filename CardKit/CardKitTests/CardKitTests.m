//
//  CardKitTests.m
//  CardKitTests
//
//  Created by Alex Korotkov on 4/5/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardKValidation.h"
@interface CardKitTests : XCTestCase

@end

@implementation CardKitTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testIsValidateSecureCodeWhenStringIsShort {
  XCTAssertFalse([CardKValidation isValidSecureCode:@"1"]);
}

- (void)testIsValidateSecureCodeWhenStringIsCorrect {
  XCTAssertTrue([CardKValidation isValidSecureCode:@"123"]);
}

- (void)testIsValidateSecureCodeWhenStringIsLong {
  XCTAssertFalse([CardKValidation isValidSecureCode:@"1234"]);
}

- (void)testIsValidateSecureCodeWhenStringHasLetters {
  XCTAssertFalse([CardKValidation isValidSecureCode:@"1a2"]);
}

- (void)testAllDigitsInStringWhenStringHasLetters {
  XCTAssertFalse([CardKValidation isValidSecureCode:@"1a2"]);
}

- (void)testAllDigitsInString {
  XCTAssertTrue([CardKValidation isValidSecureCode:@"123"]);
}

@end
