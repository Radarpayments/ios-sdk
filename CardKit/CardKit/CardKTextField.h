//
//  CardKTextField.h
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *CardKTextFieldPatternCardNumber;
extern NSString *CardKTextFieldPatternExpirationDate;
extern NSString *CardKTextFieldPatternSecureCode;

@interface UIView (Shake)

- (void) animateError;

@end

@interface CardKTextField : UIControl

@property (strong) NSString *text;
@property (strong) NSString *stripRegexp;
@property (strong) NSString *pattern;
@property (strong) NSString *placeholder;
@property (strong) NSString *format;
@property (strong, nullable) NSString *accessibilityLabel;
@property BOOL secureTextEntry;
@property UIKeyboardType keyboardType;
@property UIReturnKeyType returnKeyType;
@property(null_unspecified,nonatomic,copy) UITextContentType textContentType;
@property BOOL showError;

- (void)showCoverView;

@end

NS_ASSUME_NONNULL_END
