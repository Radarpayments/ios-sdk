//
//  NSObject+CardKPaymentSessionStatus.m
//  CardKit
//
//  Created by Alex Korotkov on 4/1/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import "CardKPaymentSessionStatus.h"

@implementation CardKPaymentSessionStatus
- (BOOL) useApplePay {
    return [self.merchantOptions indexOfObject: @"APPLEPAY"] != NSNotFound;
}
@end
