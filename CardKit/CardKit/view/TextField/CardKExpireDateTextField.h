//
//  CardKCVCTextField.h
//  CardKit
//
//  Created by Alex Korotkov on 22.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKExpireDateTextField: UIControl

@property (strong) NSString *expirationDate;
@property (strong) NSArray *errorMessages;
-(nullable NSString *)getMonthFromExpirationDate;
-(nullable NSString *)getFullYearFromExpirationDate;
-(BOOL)validate;
@end

NS_ASSUME_NONNULL_END
