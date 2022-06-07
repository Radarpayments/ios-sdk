//
//  NSObject+CKCToken.m
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CKCToken.h"
#import "CKCTokenResult.h"
#import "CKCBindingParams.h"
#import "CKCCardParams.h"
#import "RSA.h"
#import "Luhn.h"

@implementation CKCToken: NSObject
+ (nullable NSString *)_getFullYearFromExpirationDate: (NSString *) time {
  NSString *text = [time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  NSRange slash = [text rangeOfString:@"/"];
  
  if ((text.length <= 4 && text.length >= 5) || (text.length == 5 && slash.location != 2)) {
    return nil;
  }

  NSString *year = [text substringFromIndex:2];

  if (text.length == 5) {
    year = [text substringFromIndex:3];
  }

  NSString *fullYearStr = [NSString stringWithFormat:@"20%@", year];
  
  NSInteger fullYear = [fullYearStr integerValue];
  
  NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
  
  if (fullYear < comps.year || fullYear >= comps.year + 10) {
    return nil;
  }
  
  return fullYearStr;
}

+ (nullable NSString *)_getMonthFromExpirationDate: (NSString *) time {
  NSString *text = [time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  if (text.length <= 4 && text.length >= 5) {
    return nil;
  }

  NSString *monthStr = [text substringToIndex:2];
  
  NSInteger month = [monthStr integerValue];
  if (month < 1 || month > 12) {
    return nil;
  }
  
  return monthStr;
}

+ (BOOL) _isValidCreditCardNumber: (NSString *) pan {
  return [Luhn validateString:pan];
}

+ (BOOL) _allDigitsInString:(NSString *)str {
  NSString *string = [str stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, str.length)];
  return [str isEqual:string];
}

+ (NSDictionary *)_validateCardNumber: (NSString *) cardNumber {
  NSInteger len = [cardNumber length];
  if (len == 0) {
    return @{@"field": CKCFieldPan, @"error": CKCErrorRequired};
  }

  if (len < 16 || len > 19) {
    return @{@"field": CKCFieldPan, @"error": CKCErrorInvalidLength};
  } else if (![self _allDigitsInString:cardNumber] || ![self _isValidCreditCardNumber: cardNumber]) {
    return @{@"field": CKCFieldPan, @"error": CKCErrorInvalidFormat};
  }

  return nil;
}

+ (NSDictionary *)_validateSecureCode: (NSString *) secureCode {
  if (secureCode.length == 0) {
    return @{@"field": CKCFieldCVC, @"error": CKCErrorRequired};
  }

  if ([secureCode length] != 3 || ![self _allDigitsInString:secureCode]) {
      return @{@"field": CKCFieldCVC, @"error": CKCErrorInvalidFormat};
  }
  
    return nil;
}

+ (NSDictionary *)_validateExpireDate:(NSString *) expireDate {
  if ([expireDate isEqual:@""] || expireDate == nil) {
    return @{@"field": CKCFieldExpiryMMYY, @"error": CKCErrorRequired};;
  }

  NSString * month = [self _getMonthFromExpirationDate: expireDate];
  NSString * year = [self _getFullYearFromExpirationDate: expireDate];

  if (month == nil || year == nil) {
    return @{@"field": CKCFieldExpiryMMYY, @"error": CKCErrorInvalidFormat};
  } else {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    comps.month = [month integerValue] + 1;
    comps.year = [year integerValue];
    
    NSDate *expDate = [calendar dateFromComponents:comps];
    
    if ([[NSDate date] compare:expDate] != NSOrderedAscending) {
      return @{@"field": CKCFieldExpiryMMYY, @"error": CKCErrorInvalidFormat};
    }
  }
  
  return nil;
}

+ (NSDictionary *)_validateOwner:(NSString *) cardOwner {
  if (cardOwner.length == 0) {
    return @{@"field": CKCFieldCardholder, @"error": CKCErrorRequired};
  }

  NSString *owner = [cardOwner stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSInteger len = owner.length;
  if (len == 0 || len > 40) {
    return @{@"field": CKCFieldCardholder, @"error": CKCErrorInvalidLength};
  } else {
    NSString *str = [owner stringByReplacingOccurrencesOfString:@"[^a-zA-Z' .]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, owner.length)];
    if (![str isEqual:owner]) {
      return @{@"field": CKCFieldCardholder, @"error": CKCErrorInvalidFormat};
    }
  }
  
  return nil;
}

+ (NSString *) timestampForDate:(NSDate *) date {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:enUSPOSIXLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  [dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
  
  return [dateFormatter stringFromDate:date];
}

+ (NSString *) _getTimestamp {
  return [self timestampForDate:[NSDate date]];
}

+ (CKCTokenResult *) generateWithBinding: (CKCBindingParams *) params  {
  NSMutableArray *errors = [[NSMutableArray alloc] init];

  if (params.bindingID.length == 0) {
    [errors addObject:@{@"field": CKCFieldBindingID, @"error": CKCErrorRequired}];
  }
  
  if (params.mdOrder.length == 0) {
    [errors addObject:@{@"field": CKCFieldMdOrder, @"error": CKCErrorRequired}];
  }
  
  if (params.pubKey.length == 0) {
    [errors addObject:@{@"field": CKCFieldPubKey, @"error": CKCErrorRequired}];
  }
  
  CKCTokenResult * tokenResult = [[CKCTokenResult alloc] init];
  tokenResult.token = nil;
  tokenResult.errors = errors;
  
  if (errors.count > 0) {
    return tokenResult;
  }
  
  NSDictionary *validatedSecureCode;

  if (params.cvc != nil) {
    validatedSecureCode = [self _validateSecureCode: params.cvc];
  } else {
    params.cvc = @"";
  }

  if (validatedSecureCode != nil) {
    [errors addObject:validatedSecureCode];
    tokenResult.errors = errors;

    return tokenResult;
  }

  NSString *timeStamp = params.seTokenTimestamp ? params.seTokenTimestamp : [self _getTimestamp];
  NSString *uuid = [[NSUUID UUID] UUIDString];
  NSString *cardData = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", timeStamp, uuid, params.cvc, params.mdOrder, params.bindingID];

  NSString *seToken = [RSA encryptString:cardData publicKey:params.pubKey];
  
  if (seToken.length == 0) {
    [errors addObject:@{@"field": CKCFieldPubKey, @"error": CKCErrorInvalid}];
    return tokenResult;
  }
  
  tokenResult.token = seToken;

  return tokenResult;
}

+ (CKCTokenResult *) generateWithCard: (CKCCardParams *) params  {
  NSMutableArray *errors = [[NSMutableArray alloc] init];
  
  if (params.pubKey.length == 0) {
    [errors addObject:@{@"field": CKCFieldPubKey, @"error": CKCErrorRequired}];
  }
  
  CKCTokenResult * tokenResult = [[CKCTokenResult alloc] init];
  tokenResult.token = nil;
  
  if (errors.count > 0) {
    tokenResult.errors = errors;
    return tokenResult;
  }
  
  NSDictionary *validatedSecureCode = [self _validateSecureCode: params.cvc];
  NSDictionary *validatedExpireDate = [self _validateExpireDate: params.expiryMMYY];
  NSDictionary *validatedCardNumber = [self _validateCardNumber: params.pan];
  NSDictionary *validatedCarHolder = [self _validateOwner: params.cardholder];

  if (validatedSecureCode != nil) {
    [errors addObject:validatedSecureCode];
  }
  
  if (validatedExpireDate != nil) {
    [errors addObject:validatedExpireDate];
  }
  
  if (validatedCardNumber != nil) {
    [errors addObject:validatedCardNumber];
  }
  
  if (validatedCarHolder != nil) {
    [errors addObject:validatedCarHolder];
  }
  
  if (errors.count > 0) {
    tokenResult.errors = errors;
    return tokenResult;
  }

  NSString *timeStamp = params.seTokenTimestamp ? params.seTokenTimestamp : [self _getTimestamp];
  NSString *uuid = [[NSUUID UUID] UUIDString];
  NSString *cardNumber = params.pan;
  NSString *secureCode = params.cvc;
  NSString *fullYear = [self _getFullYearFromExpirationDate: params.expiryMMYY];
  NSString *month = [self _getMonthFromExpirationDate: params.expiryMMYY];
  NSString *expirationDate = [NSString stringWithFormat:@"%@%@", fullYear, month];
  

  NSString *cardData = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", timeStamp, uuid, cardNumber, secureCode, expirationDate];

  if (params.mdOrder != nil) {
    cardData = [NSString stringWithFormat:@"%@/%@", cardData, params.mdOrder];
  } else {
    cardData = [NSString stringWithFormat:@"%@//", cardData];
  }

  NSString *seToken = [RSA encryptString:cardData publicKey: params.pubKey];
  
  if (seToken.length == 0) {
    [errors addObject:@{@"field": CKCFieldPubKey, @"error": CKCErrorInvalid}];
    tokenResult.errors = errors;

    return tokenResult;
  }
  
  tokenResult.token = seToken;

  return tokenResult;
}

+ (NSString *) getVersion {
  return [[[NSBundle bundleForClass: CKCToken.self] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end
