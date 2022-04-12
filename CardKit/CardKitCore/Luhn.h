//
//  Luhn.h
//  CardKit
//
//  Created by Alex Korotkov on 8/27/19.
//  Copyright © 2019 Alex Korotkov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OLCreditCardType) {
  OLCreditCardTypeAmex,
  OLCreditCardTypeVisa,
  OLCreditCardTypeMastercard,
  OLCreditCardTypeDiscover,
  OLCreditCardTypeDinersClub,
  OLCreditCardTypeJCB,
  OLCreditCardTypeUnsupported,
  OLCreditCardTypeInvalid
};

@interface Luhn : NSObject

+ (OLCreditCardType) typeFromString:(NSString *) string;
+ (BOOL) validateString:(NSString *) string forType:(OLCreditCardType) type;
+ (BOOL) validateString:(NSString *) string;

@end

@interface NSString (Luhn)

- (BOOL) isValidCreditCardNumber;
- (OLCreditCardType) creditCardType;

@end
