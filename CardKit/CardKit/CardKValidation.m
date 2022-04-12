//
//  NSObject+CardKValidation.m
//  CardKit
//
//  Created by Alex Korotkov on 5/25/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKValidation.h"

@implementation CardKValidation: NSObject

+ (BOOL) isValidSecureCode: (NSString *) secureCode {
  if ([secureCode length] != 3 || ![self allDigitsInString:secureCode]) {
    return NO;
  }
  
  return YES;
}

+ (BOOL) allDigitsInString:(NSString *)str {
  NSString *string = [str stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
  return [str isEqual:string];
}

@end
