//
//  CardKCardCell.h
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKCardView : UIControl

@property (strong) NSString *number;
@property (strong) NSString *expirationDate;
@property (strong) NSString *secureCode;
@property (strong) NSString *bindingId;
@property (strong) NSArray *errorMessages;
@property BOOL allowedCardScaner;
@property (strong, readonly) UITapGestureRecognizer *scanCardTapRecognizer;
-(nullable NSString *)getMonthFromExpirationDate;
-(nullable NSString *)getFullYearFromExpirationDate;
-(void)validate;
- (void)resetLeftImage;

@end

NS_ASSUME_NONNULL_END
