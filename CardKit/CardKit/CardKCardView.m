//
//  CardKCardCell.m
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKCardView.h"
#import "CardKTextField.h"
#import "PaymentSystemProvider.h"
#import "Luhn.h"
#import "CardKConfig.h"
#import "CardKValidation.h"

NSInteger EXPIRE_YEARS_DIFF = 10;

@implementation CardKCardView {
  UIImageView *_paymentSystemImageView;
  
  CardKTextField *_numberTextField;
  CardKTextField *_expireDateTextField;
  CardKTextField *_secureCodeTextField;
  CardKTextField *_focusedField;
  NSMutableArray *_errorMessagesArray;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  BOOL _allowedCardScaner;
  NSString *_leftIconImageName;
  UIViewAnimationOptions _leftIconAnimationOptions;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    CardKTheme *theme = CardKConfig.shared.theme;
  
    _bundle = [NSBundle bundleForClass:[CardKCardView class]];
  
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

    [self addSubview:_paymentSystemImageView];

    _numberTextField = [[CardKTextField alloc] init];
    
    _numberTextField.tag = 30000;
    _numberTextField.pattern = CardKTextFieldPatternCardNumber;
    _numberTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Card Number", nil, _languageBundle, @"Card number placeholder");
    _numberTextField.accessibilityLabel = nil;
    [_numberTextField showCoverView];
    
    _expireDateTextField = [[CardKTextField alloc] init];
    _expireDateTextField.tag = 30001;
    _expireDateTextField.pattern = CardKTextFieldPatternExpirationDate;
    _expireDateTextField.placeholder = NSLocalizedStringFromTableInBundle(@"MM/YY", nil, _languageBundle, @"Expiration date placeholder");
    _expireDateTextField.format = @"  /  ";
    _expireDateTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"expiry", nil, _languageBundle, @"Expiration date accessiblity label");
    
    _secureCodeTextField = [[CardKTextField alloc] init];
    _secureCodeTextField.tag = 30002;
    _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
    _secureCodeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CVC", nil, _languageBundle, @"CVC placeholder");
    _secureCodeTextField.secureTextEntry = YES;
    _secureCodeTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"cvc", nil, _languageBundle, @"CVC accessibility");
  
    for (CardKTextField *v in @[_numberTextField, _expireDateTextField, _secureCodeTextField]) {
      [self addSubview:v];
      v.keyboardType = UIKeyboardTypeNumberPad;
      [v addTarget:self action:@selector(_switchToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
      [v addTarget:self action:@selector(_clearErrors:) forControlEvents:UIControlEventValueChanged];
      [v addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    _numberTextField.textContentType = UITextContentTypeCreditCardNumber;
    
    [_numberTextField addTarget:self action:@selector(_numberChanged) forControlEvents: UIControlEventValueChanged];
    [_numberTextField addTarget:self action:@selector(_relayout) forControlEvents: UIControlEventEditingDidEnd];
    [_numberTextField addTarget:self action:@selector(_relayout) forControlEvents: UIControlEventEditingDidBegin];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  
  return self;
}

- (nullable NSString *)getFullYearFromExpirationDate {
  NSString *text = [_expireDateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (text.length != 4) {
    return nil;
  }
  NSString *year = [text substringFromIndex:2];
  NSString *fullYearStr = [NSString stringWithFormat:@"20%@", year];
  
  NSInteger fullYear = [fullYearStr integerValue];
  
  NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
  
  if (fullYear < comps.year || fullYear >= comps.year + EXPIRE_YEARS_DIFF) {
    return nil;
  }
  
  return fullYearStr;
}

- (nullable NSString *)getMonthFromExpirationDate {
  NSString *text = [_expireDateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (text.length != 4) {
    return nil;
  }
  NSString *monthStr = [text substringToIndex:2];
  
  NSInteger month = [monthStr integerValue];
  if (month < 1 || month > 12) {
    return nil;
  }
  
  return monthStr;
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

- (NSString *)expirationDate {
  return [_expireDateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setExpirationDate:(NSString *)expirationDate {
  _expireDateTextField.text = expirationDate;
}

- (NSString *)secureCode {
  return [_secureCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setSecureCode:(NSString *)secureCode {
  _secureCodeTextField.text = secureCode;
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

- (void)_clearExpireDateErrors {
  NSString *incorrectExpiry = NSLocalizedStringFromTableInBundle(@"incorrectExpiry", nil, _languageBundle, @"incorrectExpiry");
  [_errorMessagesArray removeObject:incorrectExpiry];
}

- (void)_validateExpireDate {
  BOOL isValid = YES;
  NSString *incorrectExpiry = NSLocalizedStringFromTableInBundle(@"incorrectExpiry", nil, _languageBundle, @"incorrectExpiry");
  [self _clearExpireDateErrors];

  NSString * month = [self getMonthFromExpirationDate];
  NSString * year = [self getFullYearFromExpirationDate];
  if (month == nil || year == nil) {
    [_errorMessagesArray addObject:incorrectExpiry];
    isValid = NO;
  } else {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = 1;
    comps.month = [month integerValue] + 1;
    comps.year = [year integerValue];
    
    NSDate *expDate = [calendar dateFromComponents:comps];
    
    if ([[NSDate date] compare:expDate] != NSOrderedAscending) {
      [_errorMessagesArray addObject:incorrectExpiry];
      isValid = NO;
    }
  }
  
  _expireDateTextField.showError = !isValid;
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (void)_clearSecureCodeErrors {
  NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _languageBundle, @"incorrectCvc");
  
  [_errorMessagesArray removeObject:incorrectCvc];
}

- (void)_validateSecureCode {
  BOOL isValid = YES;
  NSString *secureCode = [self secureCode];
  NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _languageBundle, @"incorrectCvc");
  [self _clearSecureCodeErrors];
  
  if (![CardKValidation isValidSecureCode:secureCode]) {
    [_errorMessagesArray addObject:incorrectCvc];
    isValid = NO;
  }
  
  _secureCodeTextField.showError = !isValid;
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (void)validate {
  [self _validateCardNumber];
  [self _validateExpireDate];
  [self _validateSecureCode];
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
  NSArray *fields = @[_numberTextField, _expireDateTextField, _secureCodeTextField];
  
  [self _showPaymentSystemProviderIcon];

  NSInteger index = [fields indexOfObject:sender];
  if (index == NSNotFound) {
    if (sender == _numberTextField) {
      
    }
    return;
  }
  
  index += 1;
  if (index < fields.count) {
    [fields[index] becomeFirstResponder];
  } else {
    [self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
  }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  [self _numberChanged];
}

- (void)_clearErrors: (UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;

  if (field == _numberTextField) {
    [self _clearCardNumberErrors];
  } else if (field == _expireDateTextField) {
    [self _clearExpireDateErrors];
  } else if (field == _secureCodeTextField) {
    [self _clearSecureCodeErrors];
    self.leftIconImageName = [PaymentSystemProvider imageNameForCVCWithTraitCollection:self.traitCollection];
  }
  field.showError = NO;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)resetLeftImage {
  _focusedField = nil;
  _leftIconAnimationOptions = UIViewAnimationOptionTransitionFlipFromBottom;
  [self _showPaymentSystemProviderIcon];
}

- (void)_editingDidBegin:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;

  [self _clearErrors:sender];
  
  if (field == _secureCodeTextField) {
    if (_focusedField == _numberTextField || _focusedField == _expireDateTextField) {
      _leftIconAnimationOptions = UIViewAnimationOptionTransitionFlipFromLeft;
    } else if (_focusedField == nil) {
      _leftIconAnimationOptions = UIViewAnimationOptionTransitionFlipFromTop;
    } else {
      _leftIconAnimationOptions = UIViewAnimationOptionTransitionCrossDissolve;
    }
    self.leftIconImageName = [PaymentSystemProvider imageNameForCVCWithTraitCollection:self.traitCollection];
  } else {
    if (_focusedField == _secureCodeTextField) {
      _leftIconAnimationOptions = UIViewAnimationOptionTransitionFlipFromRight;
    } else {
      _leftIconAnimationOptions = UIViewAnimationOptionTransitionCrossDissolve;
    }
    [self _showPaymentSystemProviderIcon];
  }

  if (field.showError) {
    field.showError = false;
    [self cleanErrors];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }

  if (field == _focusedField) {
    return;
  }

  _focusedField = field;
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
  CGRect bounds = self.bounds;
  CGFloat height = bounds.size.height;
  
  CGFloat width = bounds.size.width - 10;
  CGFloat imageWidth = 50;
  
  if (_focusedField == _numberTextField) {
    _numberTextField.frame = CGRectMake(imageWidth, 0, _numberTextField.intrinsicContentSize.width, height);
    _expireDateTextField.frame = CGRectMake(CGRectGetMaxX(_numberTextField.frame),
                                            0,
                                            _expireDateTextField.intrinsicContentSize.width,
                                            bounds.size.height
                                            );
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX( _expireDateTextField.frame), 0, _secureCodeTextField.intrinsicContentSize.width, height);
  } else {
    CGFloat numberWidth = _numberTextField.intrinsicContentSize.width;
    CGFloat secCodeWidth = _secureCodeTextField.intrinsicContentSize.width;
    CGFloat expireDateWidth = _expireDateTextField.intrinsicContentSize.width;
    
    CGFloat leftSpace = width - imageWidth - secCodeWidth - expireDateWidth;
    if (leftSpace < numberWidth) {
      numberWidth = leftSpace;
    }
    
    _numberTextField.frame = CGRectMake(imageWidth, 0, numberWidth, height);
    _expireDateTextField.frame = CGRectMake(CGRectGetMaxX(_numberTextField.frame), 0, expireDateWidth, height);
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX(_expireDateTextField.frame), 0, secCodeWidth, height);
  }
  
  _paymentSystemImageView.frame = CGRectMake(-10, 0, imageWidth, bounds.size.height);
  
  [super layoutSubviews];
}

- (BOOL)resignFirstResponder {
  [_numberTextField resignFirstResponder];
  [_expireDateTextField resignFirstResponder];
  [_secureCodeTextField resignFirstResponder];
  return YES;
}

@end
