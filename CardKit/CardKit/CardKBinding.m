//
//  UIViewController+CardKBankItem.m
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKBinding.h"
#import "PaymentSystemProvider.h"
#import "CardKConfig.h"

#import "CardKTextField.h"
#import "CardKFooterView.h"
#import "CardKValidation.h"
#import "CardKBankLogoView.h"
#import "RSA.h"

@implementation CardKBinding {
  UIImageView * _paymentSystemImageView;
  NSBundle *_bundle;
  UILabel *_cardNumberLabel;
  UILabel *_expireDateLabel;
  UIImage *_image;
  CardKFooterView *_secureCodeFooterView;
  CardKTextField *_secureCodeTextField;
  NSMutableArray *_secureCodeErrors;
  NSString *_lastAnouncment;
  NSBundle *_languageBundle;
  BOOL _showCVCField;
  NSString *_paymentSystem;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKBinding class]];
     
     NSString *language = CardKConfig.shared.language;

     _secureCodeErrors = [[NSMutableArray alloc] init];
    
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }

    _paymentSystemImageView = [[UIImageView alloc] init];
    _secureCodeTextField = [[CardKTextField alloc] init];
    _secureCodeTextField.tag = 30006;
    
    _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
    _secureCodeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CVC", nil, _languageBundle, @"CVC placeholder");
    _secureCodeTextField.secureTextEntry = YES;
    _secureCodeTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"cvc", nil, _languageBundle, @"CVC accessibility");
    _secureCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_secureCodeTextField addTarget:self action:@selector(_clearSecureCodeErrors) forControlEvents:UIControlEventEditingDidBegin];
    [_secureCodeTextField addTarget:self action:@selector(_clearSecureCodeErrors) forControlEvents:UIControlEventValueChanged];
    
    _expireDateLabel = [[UILabel alloc] init];
    _cardNumberLabel = [[UILabel alloc] init];
    
    [self addSubview:_paymentSystemImageView];
    [self addSubview:_cardNumberLabel];
    [self addSubview:_expireDateLabel];
  }
  return self;
}

- (void)setShowCVCField:(BOOL)showCVCField {
  _showCVCField = showCVCField;
  if (CardKConfig.shared.bindingCVCRequired && showCVCField) {
   [self addSubview:_secureCodeTextField];
  }
}

- (BOOL)showCVCField {
  return _showCVCField;
}

- (void)focusSecureCode {
  if (CardKConfig.shared.bindingCVCRequired) {
    [_secureCodeTextField becomeFirstResponder];
  }
}

- (void)setImagePath:(UIImage *)imagePath {
  
}
- (UIImage *)imagePath {
  NSString *imageName = [PaymentSystemProvider imageNameByPaymentSystem: _paymentSystem compatibleWithTraitCollection: self.traitCollection];
  return [PaymentSystemProvider namedImage:imageName inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
}

- (void)setPaymentSystem:(NSString *)paymentSystem {
  _paymentSystem = paymentSystem;
  _paymentSystemImageView.image = self.imagePath;
  
}

- (NSString *)paymentSystem {
  return _paymentSystem;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _expireDateLabel.text = _expireDate;
  
  UIFont *font = [self _font];
  _cardNumberLabel.font = font;
  _expireDateLabel.font = font;

 [self replaceTextWithCircleBullet];
  
  CGRect bounds = self.bounds;
  NSInteger leftExpireDate = bounds.size.width - _expireDateLabel.intrinsicContentSize.width - 20;

  _paymentSystemImageView.frame = CGRectMake(0, 0, 35, 26);
  _paymentSystemImageView.center = CGPointMake(35/2, bounds.size.height / 2);
  _cardNumberLabel.frame = CGRectMake(CGRectGetMaxX(_paymentSystemImageView.frame) + 15, 0, _cardNumberLabel.intrinsicContentSize.width, bounds.size.height);

  _expireDateLabel.frame = CGRectMake(leftExpireDate, 0, _expireDateLabel.intrinsicContentSize.width, bounds.size.height);

  _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX(_expireDateLabel.frame) - 3, 0, _secureCodeTextField.intrinsicContentSize.width, bounds.size.height);
  
  CardKTheme *theme = CardKConfig.shared.theme;
  [_cardNumberLabel setTextColor: theme.colorLabel];
  [_expireDateLabel setTextColor: theme.colorLabel];
}

- (void) replaceTextWithCircleBullet {
  NSInteger fontSize = 18;

  NSString *bullet = @"\u2022";
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(X|\\*)" options:NSRegularExpressionCaseInsensitive error:nil];
  NSString *displayText = [regex stringByReplacingMatchesInString:_cardNumber options:0 range:NSMakeRange(0, [_cardNumber length]) withTemplate:bullet];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayText];

  NSRange firstBullet = [displayText rangeOfString:bullet];
  NSRange lastBullet = [displayText rangeOfString:bullet options:NSBackwardsSearch];
  NSRange bulletsRange = NSMakeRange(firstBullet.location,  lastBullet.location - firstBullet.location + 1);
  
  [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo-bold" size:fontSize]} range:bulletsRange];
  [attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:bulletsRange];

  _cardNumberLabel.attributedText = attributedString;
  [_cardNumberLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
}

- (UIFont *)_font {
  if (self.superview.frame.size.width == 320) {
    return [UIFont fontWithName:@"Menlo" size: 16];
  }
  
  return [UIFont fontWithName:@"Menlo" size: 17];
}


- (void)_refreshErrors {
  _secureCodeFooterView.errorMessages = _secureCodeErrors;
  [self _announceError];
}
- (void)_announceError {
  NSString *errorMessage = [_secureCodeErrors firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

- (void)_clearSecureCodeErrors {
  [_secureCodeErrors removeAllObjects];
  _secureCodeTextField.showError = NO;
  [self _refreshErrors];
}

- (void)_validateSecureCode {
  BOOL isValid = YES;
  NSString *secureCode = _secureCodeTextField.text;
  NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _languageBundle, @"incorrectCvc");
  [self _clearSecureCodeErrors];
  
  if (![CardKValidation isValidSecureCode:secureCode]) {
    [_secureCodeErrors addObject:incorrectCvc];
    isValid = NO;
  }
  
  _secureCodeTextField.showError = !isValid;
}

- (void)validate {
  [self _clearSecureCodeErrors];
  [self _validateSecureCode];
}

- (NSArray *)errorMessages {
  return [_secureCodeErrors copy];
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  _secureCodeErrors = [errorMessages mutableCopy];
}

- (void)setSecureCode:(NSString *)secureCode {
  _secureCodeTextField.text = secureCode;
}

- (NSString *)secureCode {
  return _secureCodeTextField.text;
}
@end
