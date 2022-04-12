//
//  CardKFooterView.m
//  CardKit
//
//  Created by Alex Korotkov on 9/13/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKFooterView.h"
#import "CardKTheme.h"
#import "CardKConfig.h"

@interface CardKFooterView ()

@end

@implementation CardKFooterView {
  NSArray *_errorMessages;
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CardKTheme *theme = CardKConfig.shared.theme;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = [_label.font fontWithSize:12];
    _label.textColor = theme.colorErrorLabel;
    [self addSubview:_label];
  }
  return self;
}

- (NSArray *)errorMessages {
  return _errorMessages;
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  [_label setText:[errorMessages firstObject]];
  _errorMessages = errorMessages;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _label.frame = CGRectInset(self.bounds, 0, 0);
}

@end
