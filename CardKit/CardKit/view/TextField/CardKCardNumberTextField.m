//
//  CardKCardNumberTextField.m
//  CardKit
//
//  Created by Alex Korotkov on 21.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardKCardNumberTextField.h"
#import "CardKTextField.h"
#import "PaymentSystemProvider.h"
#import "Luhn.h"
#import "CardKConfig.h"
#import "CardKValidation.h"

@implementation CardKCardNumberTextField {
  CardKTextField *_numberTextField;
  NSMutableArray *_errorMessagesArray;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  BOOL _allowedCardScaner;
  NSString *_leftIconImageName;
  UIViewAnimationOptions _leftIconAnimationOptions;
  UIImageView *_paymentSystemImageView;
}

- (instancetype)init {

self = [super init];

if (self) {
  CardKTheme *theme = CardKConfig.shared.theme;

  _bundle = [NSBundle bundleForClass:[CardKCardNumberTextField class]];

  NSString *language = CardKConfig.shared.language;
  if (language != nil) {
    _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
  } else {
    _languageBundle = _bundle;
  }

  _errorMessagesArray = [[NSMutableArray alloc] init];
  
  _paymentSystemImageView = [[UIImageView alloc] init];
  _paymentSystemImageView.contentMode = UIViewContentModeCenter;
  _leftIconAnimationOptions = UIViewAnimationOptionTransitionCrossDissolve;
  self.leftIconImageName = [PaymentSystemProvider imageNameByCardNumber:_allowedCardScaner ? nil : @"" compatibleWithTraitCollection: self.traitCollection];

  _scanCardTapRecognizer = [[UITapGestureRecognizer alloc] init];
  [_paymentSystemImageView addGestureRecognizer:_scanCardTapRecognizer];
  [_paymentSystemImageView setTintColor: theme.colorLabel];

  

  _numberTextField = [[CardKTextField alloc] init];
  
  _numberTextField.tag = 30000;
  _numberTextField.pattern = CardKTextFieldPatternCardNumber;
  _numberTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Card Number", nil, _languageBundle, @"Card number placeholder");
  _numberTextField.accessibilityLabel = nil;
  
  [_numberTextField setLeftView:_paymentSystemImageView];
  
  for (CardKTextField *v in @[_numberTextField]) {
    [self addSubview:v];
    v.keyboardType = UIKeyboardTypeNumberPad;
    [v addTarget:self action:@selector(_switchToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [v addTarget:self action:@selector(_clearErrors:) forControlEvents:UIControlEventValueChanged];
    [v addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [v addTarget:self action:@selector(_editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
  }
  
  _numberTextField.textContentType = UITextContentTypeCreditCardNumber;
  
  [_numberTextField addTarget:self action:@selector(_numberChanged) forControlEvents: UIControlEventValueChanged];
  [_numberTextField addTarget:self action:@selector(_relayout) forControlEvents: UIControlEventEditingDidEnd];
  [_numberTextField addTarget:self action:@selector(_relayout) forControlEvents: UIControlEventEditingDidBegin];
  
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

return self;
}


- (void)setLeftIconImageName:(NSString *)name {
  if ([_leftIconImageName isEqualToString:name]) {
    return;
  }
  _leftIconImageName = name;
  UIImage *image = [PaymentSystemProvider namedImage:_leftIconImageName inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
  UIImageView *imageView = _paymentSystemImageView;
  [UIView transitionWithView:imageView duration:0.3 options:_leftIconAnimationOptions animations:^{
    [imageView setImage:image];
  } completion:nil];
}

- (void)redetIconImageName:(NSString *)name {
  if ([_leftIconImageName isEqualToString:name]) {
    return;
  }
  _leftIconImageName = name;
  UIImageView *imageView = _paymentSystemImageView;
  UIImageView *uiImageview = [[UIImageView alloc] init];
  [UIView animateWithDuration:0.3 animations:^{
    imageView.frame = uiImageview.frame;
  } completion:nil];
}

- (NSArray *)errorMessages {
return [_errorMessagesArray copy];
}

- (void)setErrorMessages:(NSArray *)errorMessages{
_errorMessagesArray = [errorMessages mutableCopy];
}

- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _allowedCardScaner = allowedCardScaner;
  _paymentSystemImageView.userInteractionEnabled = allowedCardScaner;
  [self _showPaymentSystemProviderIcon];
}

- (BOOL)allowedCardScaner {
  return _allowedCardScaner;
}
- (NSString *)number {
  return [_numberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setNumber:(NSString *)number {
  _numberTextField.text = number;
}

- (void)cleanErrors {
  [_errorMessagesArray removeAllObjects];
}

- (void)_clearCardNumberErrors {
  NSString *incorrectLength = NSLocalizedStringFromTableInBundle(@"incorrectLength", nil, _languageBundle, @"Incorrect card length");
  NSString *incorrectCardNumber = NSLocalizedStringFromTableInBundle(@"incorrectCardNumber", nil, _languageBundle, @"Incorrect card number");

  [_errorMessagesArray removeObject:incorrectLength];
  [_errorMessagesArray removeObject:incorrectCardNumber];
}

- (void)_validateCardNumber {
  BOOL isValid = YES;
  NSString *cardNumber = [self number];
  NSString *incorrectLength = NSLocalizedStringFromTableInBundle(@"incorrectLength", nil, _languageBundle, @"Incorrect card length");
  NSString *incorrectCardNumber = NSLocalizedStringFromTableInBundle(@"incorrectCardNumber", nil, _languageBundle, @"Incorrect card number");

  [self _clearCardNumberErrors];

  NSInteger len = [cardNumber length];
  if (len < 16 || len > 19) {
    [_errorMessagesArray addObject:incorrectLength];
    isValid = NO;
  } else if (![CardKValidation allDigitsInString:cardNumber] || ![cardNumber isValidCreditCardNumber]) {
    [_errorMessagesArray addObject:incorrectCardNumber];
    isValid = NO;
  }

  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  _numberTextField.showError = !isValid;
}


- (void)validate {
  [self _validateCardNumber];
}

- (void)_showPaymentSystemProviderIcon {
NSString *number = self.number ?: @"";
if (_allowedCardScaner && number.length == 0) {
  number = nil;
}

self.leftIconImageName = [PaymentSystemProvider imageNameByCardNumber:number compatibleWithTraitCollection:self.traitCollection];
}

- (void)_numberChanged {
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  [self _showPaymentSystemProviderIcon];
}

- (void)_switchToNext:(UIView *)sender {
  [self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  [self _numberChanged];
}

- (void)_clearErrors: (UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  [self _clearCardNumberErrors];
  field.showError = NO;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)resetLeftImage {
  _leftIconAnimationOptions = UIViewAnimationOptionTransitionFlipFromBottom;
  [self _showPaymentSystemProviderIcon];
}

- (void)_editingDidBegin:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  
  [self redetIconImageName:@"mastercard"];
  [self _clearErrors:sender];

  if (field.showError) {
    field.showError = false;
    [self cleanErrors];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }

}

- (void)_editingDidEnd:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  
  [self setLeftIconImageName:@"mastercard"];
  [self _clearErrors:sender];

  if (field.showError) {
    field.showError = false;
    [self cleanErrors];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }

}

- (void)_relayout {
dispatch_async(dispatch_get_main_queue(), ^{
  [self setNeedsLayout];
  
  [UIView animateWithDuration:0.3 animations:^{
    [self layoutIfNeeded];
  }];
});
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  CGFloat height = bounds.size.height;

  CGFloat width = bounds.size.width;
  _numberTextField.frame = CGRectMake(0, 0, width, height);
}

- (BOOL)resignFirstResponder {
  [_numberTextField resignFirstResponder];
  return YES;
}

@end

