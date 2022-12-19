//
//  CardKPaymentSessionStatus.m
//  CardKitPaymentTests
//
//  Created by Alex Korotkov on 28.11.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CardKPaymentSessionStatus.h"

@interface CardKPaymentSessionStatusTest: XCTestCase {
    
}
@end

@implementation CardKPaymentSessionStatusTest {
    CardKPaymentSessionStatus * cardKPaymentSessionStatus;
}

- (void)setUp {
    cardKPaymentSessionStatus = [[CardKPaymentSessionStatus alloc] init];

}

- (void)tearDown {
}

- (void)testUseApplayPayInMerchantOptions {
    cardKPaymentSessionStatus.merchantOptions = @[@"AMEX",
                                                  @"MASTERCARD_TDS",
                                                  @"JCB",
                                                  @"VISA",
                                                  @"VISA_TDS",
                                                  @"APPLEPAY",
                                                  @"GOOGLEPAY"];
    XCTAssertTrue([cardKPaymentSessionStatus useApplePay]);
}

- (void)testDontUseApplayPayInMerchantOptions {
    cardKPaymentSessionStatus.merchantOptions = @[@"AMEX",
                                                  @"MASTERCARD_TDS",
                                                  @"JCB",
                                                  @"VISA",
                                                  @"VISA_TDS",
                                                  @"GOOGLEPAY"];
    XCTAssertFalse([cardKPaymentSessionStatus useApplePay]);
}
@end
