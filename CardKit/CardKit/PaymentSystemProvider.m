//
//  PaymentSystemProvider.m
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "PaymentSystemProvider.h"
#import "CardKConfig.h"

BOOL __checkNumberPattern(NSString *pattern, NSString *cardNumber) {
  NSError *error = NULL;
  
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
  
  if (error) {
    return NO;
  }
  
  NSUInteger matches = [regex numberOfMatchesInString:cardNumber
                                              options:kNilOptions
                                                range:NSMakeRange(0, [cardNumber length])];
  
  if (matches && matches > 0) {
    return YES;
  }
  
  return NO;
}

BOOL __isJCB(NSString * cardNumber) {
  if ((cardNumber && [cardNumber  isEqual: @""]) || [cardNumber length] < 4) {
    return false;
  }
  
  NSString *cardNumberPrefix = [cardNumber substringToIndex:4];
  NSInteger cardNumberInt = [cardNumberPrefix integerValue];
  
  NSInteger start[] = {3528, 3088, 3096, 3112, 3158, 3337};
  NSInteger end[] = {3589, 3094, 3102, 3120, 3159, 3349};
  
  for (NSInteger i = 0; i < (sizeof start) / (sizeof start[0]); i++) {
    if (start[i] <= cardNumberInt && cardNumberInt <= end[i]) {
      return true;
    }
  }
  
  return false;
}

NSString * __systemNameByCardNumber(NSString *number) {
  if ([number hasPrefix: @"4"]) {
    return @"visa";
  } else if ([number hasPrefix: @"220"]) {
    return @"mir";
  } else if (__checkNumberPattern(@"^(5[1-5]|2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7([01][0-9]|20)))", number)) {
    return @"mastercard";
  } else if (__checkNumberPattern(@"^(50|5[6-8]|6)", number)) {
    return @"maestro";
  } else if (__checkNumberPattern(@"^(34|37)", number)) {
    return @"amex";
  } else if (__isJCB(number)) {
    return @"jsb";
  }
  
  return @"unknown";
}

NSString * __getImageAppearanceWithTraitCollection(UITraitCollection *traitCollection) {
  if (@available(iOS 12.0, *)) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
      return @"dark";
    } else {
      return @"light";
    }
  } else {
    return @"light";
  }
}

@implementation PaymentSystemProvider

+ (NSString *)imageNameByCardNumber:(nullable NSString *) number compatibleWithTraitCollection:(UITraitCollection *) traitCollection {
  if (number == nil) {
    return @"scan-card";
  }
  
  NSString *systemName = __systemNameByCardNumber(number);
  NSString *imageAppearance = CardKConfig.shared.theme.imageAppearance;
  
  if (imageAppearance == nil) {
    imageAppearance = __getImageAppearanceWithTraitCollection(traitCollection);
  }
  
  NSString *imageName = [NSString stringWithFormat:@"%@-%@", systemName, imageAppearance];
  return imageName;
}

+ (NSString *)imageNameByPaymentSystem:(NSString *) paymentSysten compatibleWithTraitCollection:(UITraitCollection *) traitCollection {
  NSString *systemName = [paymentSysten lowercaseString];
  NSString *imageAppearance = CardKConfig.shared.theme.imageAppearance;
  
  if (imageAppearance == nil) {
    imageAppearance = __getImageAppearanceWithTraitCollection(traitCollection);
  }
  
  NSString *imageName = [NSString stringWithFormat:@"%@-%@", systemName, imageAppearance];
  return imageName;
}

+ (UIImage *)namedImage:(NSString *)imageName inBundle: (NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *) traitCollection {
  
  UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
  if (image) {
    return image;
  }
  
  return [UIImage imageNamed:imageName inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:traitCollection];
}

+ (NSString *)imageNameForCVCWithTraitCollection:(UITraitCollection *) traitCollection {
  NSString *imageAppearance = CardKConfig.shared.theme.imageAppearance;
  
  if (imageAppearance == nil) {
    imageAppearance = __getImageAppearanceWithTraitCollection(traitCollection);
  }
  
  NSString *imageName = [NSString stringWithFormat:@"%@-%@", @"cvc", imageAppearance];
  return imageName;
}

@end

