//
//  CardKCVCTextField.m
//  CardKit
//
//  Created by Alex Korotkov on 22.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//


#import "CardKTextField.h"
#import "CardKConfig.h"
#import "CardKValidation.h"
#import "CardKCVCTextField.h"

@implementation CardKCVCTextField {
    CardKTextField *_secureCodeTextField;
    NSMutableArray *_errorMessagesArray;
    NSBundle *_bundle;
    NSBundle *_languageBundle;
    CardKBinding *_binding;
  }

  - (instancetype)init {
    
    self = [super init];
    
    if (self) {
      CardKTheme *theme = CardKConfig.shared.theme;
    
      _bundle = [NSBundle bundleForClass:[CardKCVCTextField class]];
    
      NSString *language = CardKConfig.shared.language;
      if (language != nil) {
        _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
      } else {
        _languageBundle = _bundle;
      }

      _errorMessagesArray = [[NSMutableArray alloc] init];


      _secureCodeTextField = [[CardKTextField alloc] init];
      _secureCodeTextField.tag = 30002;
      _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
      _secureCodeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CVC", nil, _languageBundle, @"CVC placeholder");
      _secureCodeTextField.secureTextEntry = YES;
      _secureCodeTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"cvc", nil, _languageBundle, @"CVC accessibility");
    
      for (CardKTextField *v in @[ _secureCodeTextField]) {
        [self addSubview:v];
        v.keyboardType = UIKeyboardTypeNumberPad;
        [v addTarget:self action:@selector(_switchToNext:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [v addTarget:self action:@selector(_clearErrors:) forControlEvents:UIControlEventValueChanged];
        [v addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
      }
      

      [_secureCodeTextField addTarget:self action:@selector(_relayout) forControlEvents: UIControlEventEditingDidEnd];
      [_secureCodeTextField addTarget:self action:@selector(_relayout) forControlEvents: UIControlEventEditingDidBegin];
      
      self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
  }


  - (NSArray *)errorMessages {
    return [_errorMessagesArray copy];
  }

  - (void)setErrorMessages:(NSArray *)errorMessages{
    _errorMessagesArray = [errorMessages mutableCopy];
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

  - (void)_clearSecureCodeErrors {
    NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _languageBundle, @"incorrectCvc");
    
    [_errorMessagesArray removeObject:incorrectCvc];
    _secureCodeTextField.errorMessage = @"";
  }

- (BOOL)_validateSecureCode {
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
    
    _secureCodeTextField.errorMessage = _errorMessagesArray.firstObject;
    
    return isValid;
  }

  - (BOOL)validate {
    return [self _validateSecureCode];
  }

  - (void)_switchToNext:(UIView *)sender {
      NSArray *fields = @[_secureCodeTextField];

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
    if (field == _secureCodeTextField) {
      [self _clearSecureCodeErrors];
    }
    field.showError = NO;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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

    _secureCodeTextField.frame = CGRectMake(0, 0, width, height);
  }

  - (BOOL)resignFirstResponder {
    [_secureCodeTextField resignFirstResponder];
    return YES;
  }

- (void)setBinding:(CardKBinding *)binding {
  _binding = binding;
  _secureCodeTextField.secureTextEntry = YES;
  _secureCodeTextField.text = @"xxx";
  _secureCodeTextField.enabled = NO;
}

- (CardKBinding *)binding {
  return _binding;
}
- (BOOL)becomeFirstResponder {
  return [_secureCodeTextField becomeFirstResponder];
}
  @end

