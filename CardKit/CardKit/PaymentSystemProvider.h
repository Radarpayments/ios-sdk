//
//  PaymentSystemProvider.h
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentSystemProvider : UIView

+ (NSString *)imageNameByCardNumber:(nullable NSString *) number compatibleWithTraitCollection:(UITraitCollection *) traitCollection;
+ (NSString *)imageNameForCVCWithTraitCollection:(UITraitCollection *) traitCollection;
+ (UIImage *)namedImage:(NSString *)imageName inBundle:(NSBundle *) bundle compatibleWithTraitCollection:(UITraitCollection *) traitCollection;
+ (NSString *)imageNameByPaymentSystem:(NSString *) paymentSysten compatibleWithTraitCollection:(UITraitCollection *) traitCollection;
@end

NS_ASSUME_NONNULL_END
