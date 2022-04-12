//
//  BankLogoView.h
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKBankLogoView : UIView

@property (nullable, strong) NSString *title;
- (void)showNumber:(NSString *)number;
- (void)fetchBankInfo: (NSString *)url cardNumber: (NSString *) cardNumber;
@end

NS_ASSUME_NONNULL_END
