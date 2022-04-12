//
//  NSObject+CardKValidation.h
//  CardKit
//
//  Created by Alex Korotkov on 5/25/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKValidation: NSObject

+ (BOOL) isValidSecureCode:(NSString *) secureCode;
+ (BOOL) allDigitsInString:(NSString *) str;

@end

NS_ASSUME_NONNULL_END
