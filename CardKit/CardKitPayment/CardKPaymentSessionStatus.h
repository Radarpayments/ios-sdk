//
//  NSObject+CardKPaymentSessionStatus.h
//  CardKit
//
//  Created by Alex Korotkov on 4/1/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CardKit/CardKBinding.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKPaymentSessionStatus: NSObject

@property NSArray<CardKBinding *> *bindingItems;
@property BOOL bindingEnabled;
@property BOOL cvcNotRequired;
@property NSString *redirect;

@end

NS_ASSUME_NONNULL_END
