//
//  NSObject+SeTokenGenerator.m
//  CardKit
//
//  Created by Alex Korotkov on 9/21/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "SeTokenGenerator.h"
#import "CardKConfig.h"
#import "RSA.h"
#import "CardKBinding.h"
#import "CardKCardView.h"
#import "CKCToken.h"

@implementation SeTokenGenerator

+ (NSString *) getTimeStamp {
  return CardKConfig.shared.seTokenTimestamp ? CardKConfig.shared.seTokenTimestamp : [CKCToken timestampForDate:[NSDate date]];
}

+ (NSString *) generateSeTokenWithBinding:(CardKBinding *) cardKBinding; {
  NSString *timeStamp = [self getTimeStamp];
    NSString *uuid = [[NSUUID UUID] UUIDString];

    NSString *cardData = @"";
  
    if (CardKConfig.shared.mdOrder != nil) {
      cardData = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", timeStamp, uuid, cardKBinding.secureCode, CardKConfig.shared.mdOrder, cardKBinding.bindingId];
    } else {
      cardData = [NSString stringWithFormat:@"%@/%@/%@/%@", timeStamp, uuid, cardKBinding.secureCode, cardKBinding.bindingId];
    }
  
    NSString *seToken = [RSA encryptString:cardData publicKey: CardKConfig.shared.pubKey];
  
    return seToken;
}

+ (NSString *) generateSeTokenWithCardView:(CardKCardView *) cardView {
    NSString *timeStamp = [self getTimeStamp];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *cardNumber = cardView.number;
    NSString *secureCode = cardView.secureCode;
    NSString *fullYear = cardView.getFullYearFromExpirationDate;
    NSString *month = cardView.getMonthFromExpirationDate;
    NSString *expirationDate = [NSString stringWithFormat:@"%@%@", fullYear, month];

    NSString *cardData = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", timeStamp, uuid, cardNumber, secureCode, expirationDate];
  
    if (CardKConfig.shared.mdOrder != nil) {
      cardData = [NSString stringWithFormat:@"%@/%@", cardData, CardKConfig.shared.mdOrder];
    } else {
      cardData = [NSString stringWithFormat:@"%@//", cardData];
    }
  
    NSString *seToken = [RSA encryptString:cardData publicKey: CardKConfig.shared.pubKey];
    
    return seToken;
}


@end
