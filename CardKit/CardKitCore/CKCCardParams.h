//
//  NSObject+CKCCardParams.h
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKCCardParams: NSObject
@property NSString * pan;
@property NSString * cvc;
@property NSString * expiryMMYY;
@property (nullable) NSString * cardholder;
@property NSString * mdOrder;
@property NSString * pubKey;
@property (nullable) NSString * seTokenTimestamp;
@end

NS_ASSUME_NONNULL_END
