//
//  CardKCardNumberTextField.m
//  CardKit
//
//  Created by Alex Korotkov on 21.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CardKitCore/CardKitCore.h>

#import "CardKCardNumberTextField.h"
#import "CardKTextField.h"
#import "PaymentSystemProvider.h"
#import "CardKConfig.h"
#import "CardKValidation.h"
#import "CardKBinding.h"

@implementation CardKCardNumberTextField {
  CardKTextField *_numberTextField;
  NSMutableArray *_errorMessagesArray;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  BOOL _allowedCardScaner;
  NSString *_leftIconImageName;
  UIViewAnimationOptions _leftIconAnimationOptions;
  UIImageView *_paymentSystemImageView;
  UIImageView *_scanImageView;
  CardKBinding *_binding;
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
  self.leftIconImageName = [PaymentSystemProvider imageNameNoBgByCardNumber:@""];
  
  
  
  _scanImageView = [[UIImageView alloc] init];
  _scanImageView.contentMode = UIViewContentModeCenter;
  [_scanImageView setTintColor: theme.colorLabel];
  
  _numberTextField = [[CardKTextField alloc] init];
  
  _numberTextField.tag = 30000;
  _numberTextField.pattern = CardKTextFieldPatternCardNumber;
  _numberTextField.placeholder = NSLocalizedStringFromTableInBundle(@"cardNumber", nil, _languageBundle, @"Card number placeholder");
  _numberTextField.accessibilityLabel = nil;
  
  
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
  
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [_numberTextField setLeftView:_paymentSystemImageView];
  [_numberTextField setRightView:_scanImageView];
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
  [imageView setImage:image];
  imageView.frame =  CGRectMake(0, 0, image.size.width, image.size.height);
  CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
  frame.origin.x = 0;

  [UIView animateWithDuration:0.3 animations:^{
    imageView.layer.opacity = 1;
    imageView.frame = frame;
  }];
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
  
  if (!allowedCardScaner) {
    return;
  }

  _scanImageView.image = [PaymentSystemProvider namedImage:@"scan-card" inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
    
  _scanCardTapRecognizer = [[UITapGestureRecognizer alloc] init];
  [_scanImageView addGestureRecognizer:_scanCardTapRecognizer];
  _scanImageView.userInteractionEnabled = YES;
  _numberTextField.rightViewRecognizer = _scanCardTapRecognizer;
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
  _numberTextField.errorMessage = @"";
}

- (BOOL)_validateCardNumber {
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
  _numberTextField.errorMessage = _errorMessagesArray.firstObject;
  
  return isValid;
}


- (BOOL)validate {
  return [self _validateCardNumber];
}

- (void)_showPaymentSystemProviderIcon {
  NSString *number = self.number ?: @"";
  if (_allowedCardScaner && number.length == 0) {
    number = nil;
  }

  self.leftIconImageName = [PaymentSystemProvider imageNameNoBgByCardNumber:number];
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
  
  [self _clearErrors:sender];

  if (field.showError) {
    field.showError = false;
    [self cleanErrors];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }

}

- (void)_editingDidEnd:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  
  [self _clearErrors:sender];

  if (field.showError) {
    field.showError = false;
    [self cleanErrors];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }

}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  CGFloat height = bounds.size.height;

  CGFloat width = bounds.size.width;
  _numberTextField.frame = CGRectMake(0, 0, width, height);
    
  if (_allowedCardScaner) {
    _scanImageView.center = CGPointMake(20, 20);
  }
}

- (BOOL)resignFirstResponder {
  [_numberTextField resignFirstResponder];
  return YES;
}

- (void)setBinding:(CardKBinding *)binding {
  _binding = binding;
  _numberTextField.secureTextEntry = YES;
  _numberTextField.text = binding.cardNumber;
  _numberTextField.enabled = NO;
}

- (CardKBinding *)binding {
  return _binding;
}

- (BOOL)becomeFirstResponder {
  return [_numberTextField becomeFirstResponder];
}

@end

