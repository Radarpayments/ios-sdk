//
//  BindingCellView.m
//  CardKit
//
//  Created by Alex Korotkov on 16.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import "BindingCellView.h"
#import "CardKBinding.h"
#import "PaymentSystemProvider.h"
#import "CardKConfig.h"

#import "CardKTextField.h"
#import "CardKValidation.h"
#import "CardKBankLogoView.h"
#import "RSA.h"

@implementation BindingCellView {
  UIImageView * _paymentSystemImageView;
  NSBundle *_bundle;
  UILabel *_cardNumberLabel;
  UILabel *_expireDateLabel;
  UIImage *_image;
  CardKTextField *_secureCodeTextField;
  NSMutableArray *_secureCodeErrors;
  NSString *_lastAnouncment;
  NSBundle *_languageBundle;
  BOOL _showCVCField;
  NSString *_paymentSystem;
  CardKBinding *_binding;
  CALayer *_bottomLine;
  UIView *_imageContainerView;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[BindingCellView class]];
     
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
    
    _expireDateLabel = [[UILabel alloc] init];
    _cardNumberLabel = [[UILabel alloc] init];
    
    _bottomLine = [[CALayer alloc] init];
    [self.layer addSublayer:_bottomLine];

    _imageContainerView = [[UIView alloc] init];
    [_imageContainerView addSubview:_paymentSystemImageView];
    
    [self addSubview:_imageContainerView];
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

//- (void)focusSecureCode {
//  if (CardKConfig.shared.bindingCVCRequired) {
//    [_secureCodeTextField becomeFirstResponder];
//  }
//}

- (void)setImagePath:(UIImage *)imagePath {
  
}
- (UIImage *)imagePath {
  NSString *imageName = [PaymentSystemProvider imageNameByPaymentSystem: _binding.paymentSystem compatibleWithTraitCollection: self.traitCollection];
  return [PaymentSystemProvider namedImage:imageName inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
}

- (void)setBinding:(CardKBinding *)binding {
  _binding = binding;
  _paymentSystem = binding.paymentSystem;
  _paymentSystemImageView.image = self.imagePath;
}

- (CardKBinding *)binding {
  return _binding;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _expireDateLabel.text = _binding.expireDate;

  UIFont *font = [self _font];
  _cardNumberLabel.font = font;
  _expireDateLabel.font = font;

  if (_showShortCardNumber) {
    [self _showShortCardNumber];
  } else {
   [self _showCardNumberWithCircleBullet];
  }

  CGRect bounds = self.bounds;


  _imageContainerView.frame = CGRectMake(0, 0, 36, 24);
  _imageContainerView.center = CGPointMake(36/2, bounds.size.height / 2);

  _paymentSystemImageView.frame = CGRectMake(0, 0, 36, 24);
  _paymentSystemImageView.center = CGPointMake(36/2, 24/2);
  
  NSInteger marginRight = CGRectGetMaxX(_paymentSystemImageView.frame) + 15;
  _cardNumberLabel.frame = CGRectMake(marginRight, 0, _cardNumberLabel.intrinsicContentSize.width, bounds.size.height);

  _expireDateLabel.frame = CGRectMake(CGRectGetMaxX(_cardNumberLabel.frame) + 10, 0, _expireDateLabel.intrinsicContentSize.width, bounds.size.height);
  

  _bottomLine.frame = CGRectMake(marginRight, self.frame.size.height - 1, self.frame.size.width - marginRight + 11, 0.5);
  
  CardKTheme *theme = CardKConfig.shared.theme;

  [_bottomLine setBackgroundColor: theme.colorSeparatar.CGColor];
  

  [_cardNumberLabel setTextColor: theme.colorLabel];
  [_expireDateLabel setTextColor: theme.colorLabel];
}

- (void) _showCardNumberWithCircleBullet {
  NSInteger fontSize = 18;

  NSString *bullet = @"\u2022";
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(X|\\*)" options:NSRegularExpressionCaseInsensitive error:nil];
  NSString *displayText = [regex stringByReplacingMatchesInString:_binding.cardNumber options:0 range:NSMakeRange(0, [_binding.cardNumber length]) withTemplate:bullet];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayText];

  NSRange firstBullet = [displayText rangeOfString:bullet];
  NSRange lastBullet = [displayText rangeOfString:bullet options:NSBackwardsSearch];
  NSRange bulletsRange = NSMakeRange(firstBullet.location,  lastBullet.location - firstBullet.location + 1);
  
  [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"SF Pro" size:fontSize]} range:bulletsRange];
  [attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:bulletsRange];

  _cardNumberLabel.attributedText = attributedString;
  [_cardNumberLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
}

- (void) _showShortCardNumber {
 NSString *last4Characters = [_binding.cardNumber substringWithRange:NSMakeRange([_binding.cardNumber length] - 4, 4)];
_cardNumberLabel.text = [[NSString alloc] initWithFormat:@"** %@", last4Characters];
 
}

- (UIFont *)_font {
  if (self.superview.frame.size.width == 320) {
    return [UIFont fontWithName:@"SF Pro" size: 15];
  }
  
  return [UIFont fontWithName:@"SF Pro" size: 15];
}

- (void)setSecureCode:(NSString *)secureCode {
  _secureCodeTextField.text = secureCode;
}

- (NSString *)secureCode {
  return _secureCodeTextField.text;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
}
@end

