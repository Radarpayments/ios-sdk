//
//  CardKExpireDateTextField.m
//  CardKit
//
//  Created by Alex Korotkov on 22.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//


#import "CardKTextField.h"
#import "CardKConfig.h"
#import "CardKValidation.h"
#import "CardKExpireDateTextField.h"

NSInteger EXPIRE_YEARS_DIFF = 10;

@implementation CardKExpireDateTextField {
  CardKTextField *_expireDateTextField;
  NSMutableArray *_errorMessagesArray;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  CardKBinding *_binding;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    CardKTheme *theme = CardKConfig.shared.theme;
  
    _bundle = [NSBundle bundleForClass:[CardKExpireDateTextField class]];
  
    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }

    _errorMessagesArray = [[NSMutableArray alloc] init];


    
    _expireDateTextField = [[CardKTextField alloc] init];
    _expireDateTextField.tag = 30001;
    _expireDateTextField.pattern = CardKTextFieldPatternExpirationDate;
    _expireDateTextField.placeholder = NSLocalizedStringFromTableInBundle(@"MM/YY", nil, _languageBundle, @"Expiration date placeholder");
    _expireDateTextField.format = @"  /  ";
    _expireDateTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"expiry", nil, _languageBundle, @"Expiration date accessiblity label");
    
 
  
    for (CardKTextField *v in @[_expireDateTextField]) {
      [self addSubview:v];
      v.keyboardType = UIKeyboardTypeNumberPad;
      [v addTarget:self action:@selector(_switchToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
      [v addTarget:self action:@selector(_clearErrors:) forControlEvents:UIControlEventValueChanged];
      [v addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    
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


- (NSArray *)errorMessages {
  return [_errorMessagesArray copy];
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  _errorMessagesArray = [errorMessages mutableCopy];
}


- (NSString *)expirationDate {
  return [_expireDateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setExpirationDate:(NSString *)expirationDate {
  _expireDateTextField.text = expirationDate;
}


- (void)cleanErrors {
  [_errorMessagesArray removeAllObjects];
}

- (void)_clearExpireDateErrors {
  NSString *incorrectExpiry = NSLocalizedStringFromTableInBundle(@"incorrectExpiry", nil, _languageBundle, @"incorrectExpiry");
  [_errorMessagesArray removeObject:incorrectExpiry];
  _expireDateTextField.errorMessage = @"";
}

- (BOOL)_validateExpireDate {
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
  
  _expireDateTextField.errorMessage = _errorMessagesArray.firstObject;
  
  return isValid;
}

- (BOOL)validate {
  return [self _validateExpireDate];
}


- (void)_switchToNext:(UIView *)sender {
  NSArray *fields = @[_expireDateTextField];
  

  NSInteger index = [fields indexOfObject:sender];
  if (index == NSNotFound) {
   
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
}

- (void)_clearErrors: (UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;

 if (field == _expireDateTextField) {
    [self _clearExpireDateErrors];
  }
}

- (void)_editingDidBegin:(UIView *)sender {
  [self _clearErrors:sender];
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

  _expireDateTextField.frame = CGRectMake(0, 0, width, height);
}

- (BOOL)resignFirstResponder {
  [_expireDateTextField resignFirstResponder];
  return YES;
}

- (void)setBinding:(CardKBinding *)binding {
  _binding = binding;
  _expireDateTextField.secureTextEntry = YES;
  _expireDateTextField.enabled = NO;
  _expireDateTextField.text = @"xxxx";
}

- (CardKBinding *)binding {
  return _binding;
}

- (BOOL)becomeFirstResponder {
  return [_expireDateTextField becomeFirstResponder];
}

@end
