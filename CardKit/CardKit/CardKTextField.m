//
//  CardKTextField.m
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKTextField.h"
#import "Luhn.h"
#import <AudioToolbox/AudioServices.h>
#import "CardKConfig.h"
#import "TextField.h"
NSString *CardKTextFieldPatternCardNumber = @"XXXXXXXXXXXXXXXX";
NSString *CardKTextFieldPatternExpirationDate = @"MMYY";
NSString *CardKTextFieldPatternSecureCode = @"XXX";

@interface CoverView : UIView

@end

@implementation CoverView {
  
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    CardKTheme *theme = CardKConfig.shared.theme;
    
    self.backgroundColor = theme.colorCellBackground;
    
    CAGradientLayer *mask = [[CAGradientLayer alloc] init];
    
    mask.startPoint = CGPointMake(0.0, 0.5);
    mask.endPoint = CGPointMake(1.0, 0.5);
    
    
    mask.colors = @[(id)UIColor.whiteColor.CGColor, (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor];
    mask.locations = @[@(0), @(1)];
    mask.frame = self.bounds;
    self.layer.mask = mask;

  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.layer.mask.frame = self.bounds;
}

@end

@interface CardKTextField () <UITextFieldDelegate>

@end

@implementation CardKTextField {
  UILabel *_measureLabel;
  UILabel *_patternLabel;
  UILabel *_formatLabel;
  TextField *_textField;
  UILabel *_errorMessageLabel;
  
  NSString *_pattern;
  BOOL _showError;
  CoverView *_coverView;
  CALayer *_bottomLine;
  UITapGestureRecognizer *_rightViewGesture;
  UIView *_rightImageView;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    CardKTheme *theme = CardKConfig.shared.theme;
    
    UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.autoresizingMask = mask;
    
    _patternLabel = [[UILabel alloc] init];
    _formatLabel = [[UILabel alloc] init];
    _textField = [[TextField alloc] init];
    _measureLabel = [[UILabel alloc] init];
    [_textField addTarget:self action:@selector(_editingChange:) forControlEvents:UIControlEventEditingChanged];
  
    UIFont *font = [self _font];
    _patternLabel.font = font;
    _textField.font = font;
    _formatLabel.font = font;
    _patternLabel.textColor = theme.colorPlaceholder;
    _formatLabel.textColor = theme.colorPlaceholder;
    _textField.textColor = theme.colorLabel;
    _measureLabel.font = font;
    
    _errorMessageLabel = [[UILabel alloc] init];
    _errorMessageLabel.font = [_errorMessageLabel.font fontWithSize:13];
    
    _errorMessageLabel.textColor = CardKConfig.shared.theme.colorErrorLabel;
    
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 10)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
//    [_textField addSubview:_patternLabel];
    [_textField addSubview:_formatLabel];
    [self addSubview:_textField];
    [self addSubview:_errorMessageLabel];
    
    _rightImageView = [[UIView alloc] init];
    _rightImageView.backgroundColor = theme.colorCellBackground;
    [self addSubview:_rightImageView];
    
    _textField.delegate = self;
    
    _bottomLine = [[CALayer alloc] init];
    [self.layer addSublayer:_bottomLine];
    _bottomLine.backgroundColor = theme.colorInactiveBorderTextView.CGColor;
    
    self.clipsToBounds = true;
  }
  
  return self;
}

- (void)showCoverView {
  _coverView = [[CoverView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
  
  [self addSubview:_coverView];
}

- (UIFont *)_font {
  return [UIFont fontWithName:@"Menlo" size:_patternLabel.font.pointSize];
}

- (nullable NSString *)accessibilityLabel {
  return _textField.accessibilityLabel;
}

- (void)setAccessibilityLabel:(nullable NSString *)accessibilityLabel {
  _textField.accessibilityLabel = accessibilityLabel;
}

- (NSString *)pattern {
  return _pattern;
}

- (void)setShowError:(BOOL)showError {
  CardKTheme *theme = CardKConfig.shared.theme;
  
  _showError = showError;
  
  if (!showError) {
    return;
  }

  _bottomLine.backgroundColor = theme.colorErrorLabel.CGColor;
}

- (BOOL)showError {
  return _showError;
}

- (void)setPattern:(NSString *)pattern {
  _pattern = pattern;
}


- (NSString *)placeholder {
  return _textField.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
  CardKTheme *theme = CardKConfig.shared.theme;
  _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{
    NSForegroundColorAttributeName: theme.colorPlaceholder,
    NSFontAttributeName: [self _font]
  }];
  [self setAccessibilityLabel:placeholder];
  _textField.placeholder = placeholder;
}

- (void)setFormat:(NSString *)format {
  _formatLabel.text = format;
}

- (NSString *)format {
  return _formatLabel.text;
}

- (BOOL)secureTextEntry {
  return _textField.secureTextEntry;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
  [_textField setSecureTextEntry:secureTextEntry];
}

- (UITextContentType)textContentType {
  return _textField.textContentType;
}

- (void)setTextContentType:(UITextContentType)textContentType {
  _textField.textContentType = textContentType;
}

- (UIKeyboardType)keyboardType {
  return _textField.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
  _textField.keyboardType = keyboardType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
  _textField.returnKeyType = returnKeyType;
}

- (UIReturnKeyType)returnKeyType {
  return _textField.returnKeyType;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  
  [self _makeActiveBottomLine];

  [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self _makeInactiveBottomLine];
  
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSUInteger currentLength = [textField.text length];
  NSUInteger replacementLength = [string length];
  NSUInteger rangeLength = range.length;
  NSUInteger newLength = currentLength - rangeLength + replacementLength;
  
  if (!_pattern) {
    if (_stripRegexp && string.length > 0) {
      NSString * str = [string stringByReplacingOccurrencesOfString:_stripRegexp withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
      if (![str isEqualToString:string]) {
        [self animateError];
        return NO;
      }
      return YES;
    }
    return YES;
  }
  
  
  if (string.length == 1) {
    if (!isnumber(string.UTF8String[0])) {
      [self animateError];
      return NO;
    }
    NSInteger num = [string integerValue];
    if (_pattern == CardKTextFieldPatternExpirationDate) {
      if (range.location == 0 && (num != 0 && num != 1)) {
        UITextField *textField = _textField;
        dispatch_async(dispatch_get_main_queue(), ^{
          textField.text = [NSString stringWithFormat:@"0%@", string];
          [self _editingChange:textField];
        });
        return YES;
      }
      if (range.location == 1 && ([_textField.text integerValue] == 1 && num > 2)) {
        [self animateError];
        return NO;
      }
    }
  } else if (_pattern && currentLength == 0 && string.length > 1) {
    string = [string stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, string.length)];
    UITextField *textField = _textField;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      textField.text = [NSString stringWithFormat:@"%@", string];
      [self _editingChange:textField];
    });
    return YES;
  }
  
  if (_pattern == CardKTextFieldPatternCardNumber) {
    return newLength <= 19;
  }
  return _pattern.length >= newLength;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
  });
  return YES;
}

- (CGSize)intrinsicContentSize {
  NSString *textToMeasure = _pattern;
  if (_textField.text.length > _pattern.length) {
    textToMeasure = _textField.text;
  }
  _measureLabel.text = textToMeasure;
  _measureLabel.attributedText = [self _formatValue:_measureLabel.attributedText];
  [_measureLabel sizeToFit];
  CGSize size = _measureLabel.bounds.size;
  size.width += _textField.leftView.frame.size.width + _textField.rightView.frame.size.width + 8;
  return size;
}

- (void)_editingChange:(UITextField *)textField {
  NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
  textField.attributedText = [self _formatValue:textField.attributedText];
  UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:targetCursorPosition];
  [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
  
  NSInteger len = textField.text.length;
  [_patternLabel setHidden: len == 0];
  
  NSMutableString *pattern = [_pattern mutableCopy];
  
  if ([_pattern isEqualToString:CardKTextFieldPatternExpirationDate]) {
    pattern = [_textField.placeholder mutableCopy];
    [pattern replaceOccurrencesOfString:@"/" withString:@"" options:kNilOptions range:NSMakeRange(0, pattern.length)];
    [pattern replaceOccurrencesOfString:@"." withString:@"" options:kNilOptions range:NSMakeRange(0, pattern.length)];
  }
  
  for (int i = 0; i < MIN(len, pattern.length); i++) {
    NSRange range = NSMakeRange(i, 1);
    NSString *s = [pattern substringWithRange:range];
    if ([s isEqualToString:@"/"] || [s isEqualToString:@" "]){
      continue;
    }
    [pattern replaceCharactersInRange:range withString:@" "];
  }
  _patternLabel.text = pattern;
  _patternLabel.attributedText = [self _formatValue:_patternLabel.attributedText];
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
  if (_pattern == CardKTextFieldPatternCardNumber) {
    if (len >= 16 && len <= 19 && [_textField.text isValidCreditCardNumber]) {
      [self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
    }
  } else if (_pattern && (len == _pattern.length)) {
    [self sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
  }
}

- (BOOL)becomeFirstResponder {
  self.showError = NO;
  return [_textField becomeFirstResponder];
}

- (NSAttributedString *)_formatValue: (NSAttributedString *)str {
  if ([_pattern isEqualToString:CardKTextFieldPatternCardNumber]) {
    return [self _formatCard: str];
  }
  
  if ([_pattern isEqualToString:CardKTextFieldPatternExpirationDate]) {
    return [self _formatExpireDate: str];
  }
  
  return str;
}

- (NSAttributedString *)_formatByPattern:(NSAttributedString *)strValue pattern:(NSArray<NSNumber *> *)segments {
  if (!strValue) {
    return strValue;
  }
  NSMutableAttributedString * str = [strValue mutableCopy];
  
  NSNumber *spacer = @(8);
  if (_pattern == CardKTextFieldPatternExpirationDate) {
    spacer = @(10.5);
  }
  
  NSUInteger index = 0;
  for (NSNumber *segmentLength in segments) {
      NSUInteger segmentIndex = 0;
      for (; index < str.length && segmentIndex < [segmentLength unsignedIntegerValue]; index++, segmentIndex++) {
          if (index + 1 != str.length && segmentIndex + 1 == [segmentLength unsignedIntegerValue]) {
              [str addAttribute:NSKernAttributeName value:spacer
                                       range:NSMakeRange(index, 1)];
          } else {
              [str addAttribute:NSKernAttributeName value:@(0)
                                       range:NSMakeRange(index, 1)];
          }
      }
  }
  
  return str;
}

- (NSAttributedString *)_formatCard:(NSAttributedString *)strValue {
  return [self _formatByPattern:strValue pattern:@[@(4),@(4),@(4),@(4),@(3)]];
}

- (NSAttributedString *)_formatExpireDate:(NSAttributedString *)strValue {
  return [self _formatByPattern:strValue pattern:@[@(2),@(2)]];
}

- (NSString *)text {
  return _textField.text;
}

- (void)setText:(NSString * _Nonnull)text {
  _textField.text = text;
  _textField.attributedText = [self _formatValue:_textField.attributedText];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (UIView *)leftView {
  return _textField.leftView;
}

- (void)setLeftView:(UIView *)leftView {
  _textField.leftView = leftView;
  _textField.leftViewMode = UITextFieldViewModeAlways;
  
  [self _renderLabels];
}

- (UIView *)rightView {
  return _rightImageView;
}

- (void)setRightView:(UIView *)rightView {
  [_rightImageView addSubview:rightView];
}


- (void)setRightViewRecognizer:(UITapGestureRecognizer *)rightViewRecognizer {
  [_rightImageView addGestureRecognizer:rightViewRecognizer];
  
  _rightViewGesture = rightViewRecognizer;
}

- (UITapGestureRecognizer *)rightViewRecognizer {
  return _rightViewGesture;
}

- (BOOL)resignFirstResponder {
  return [_textField resignFirstResponder];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize boundsSize = self.bounds.size;
  CGSize intrinsicContentSize = [self _getIntrinsicContentSize];
  
  CGFloat textFieldWidth = intrinsicContentSize.width;
  CGFloat delta = boundsSize.width - intrinsicContentSize.width;
  
  if (delta > -2) {
    delta = 0;
    textFieldWidth = boundsSize.width;
  }
  
  _textField.frame = CGRectMake(delta, 0, textFieldWidth, 40);

  _bottomLine.frame = CGRectMake(0, CGRectGetMaxY(_textField.frame) + 1, boundsSize.width, 1);
  
  [self _renderLabels];
  
  _errorMessageLabel.frame = CGRectMake(0, CGRectGetMaxY(_bottomLine.frame) + 10, boundsSize.width, 15);

  [_coverView setHidden:NO];
  
  _rightImageView.frame = CGRectMake(CGRectGetMaxX(_textField.frame) - 40, 0, 40, 40);

}

- (void) _makeActiveBottomLine {
  CGSize boundsSize = self.bounds.size;
  _bottomLine.backgroundColor = CardKConfig.shared.theme.colorActiveBorderTextView.CGColor;
  _bottomLine.frame = CGRectMake(0, CGRectGetMaxY(_textField.frame) + 2, boundsSize.width, 2);
}

- (void) _makeInactiveBottomLine {
  CGSize boundsSize = self.bounds.size;
  _bottomLine.backgroundColor = CardKConfig.shared.theme.colorInactiveBorderTextView.CGColor;
  _bottomLine.frame = CGRectMake(0, CGRectGetMaxY(_textField.frame) + 1, boundsSize.width, 1);
}

- (void)setErrorMessage:(NSString *)errorMessage {
  _errorMessageLabel.text = errorMessage;
}

- (NSString *)errorMessage {
  return _errorMessageLabel.text;
}

- (CGSize) _getIntrinsicContentSize {
  CGSize intrinsicContentSize = self.intrinsicContentSize;
  
  if (_textField.text.length == 0) {
    intrinsicContentSize = self.bounds.size;
  }
  
  return intrinsicContentSize;
}

- (void) _renderLabels {
  CGSize boundsSize = self.bounds.size;
  CGFloat textFieldWidth = [self _getIntrinsicContentSize].width;
  
  CGFloat x = CGRectGetMaxX(_textField.leftView.bounds);
  
  CGFloat width = textFieldWidth - x - _textField.leftView.bounds.size.width;
  for (UIView *v in @[_formatLabel, _patternLabel]) {
    v.frame = CGRectMake(x, 0, width, _textField.frame.size.height);
  }
  
  _coverView.frame = CGRectMake(0, 10, 6, boundsSize.height - 20);
}

@end

@implementation UIView (Shake)

- (void) animateError {
  CABasicAnimation *animation =
                           [CABasicAnimation animationWithKeyPath:@"position"];
  [animation setDuration:0.05];
  [animation setRepeatCount:1];
  [animation setAutoreverses:YES];
  [animation setFromValue:[NSValue valueWithCGPoint:
                 CGPointMake([self center].x - 8.0f, [self center].y)]];
  [animation setToValue:[NSValue valueWithCGPoint:
                 CGPointMake([self center].x + 8.0f, [self center].y)]];
  [animation setRemovedOnCompletion:YES];
  [[self layer] addAnimation:animation forKey:@"position"];
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
