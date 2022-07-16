//
//  DividerView.m
//  CardKit
//
//  Created by Alex Korotkov on 15.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "DividerView.h"
#import "CardKConfig.h"

@implementation DividerView  {
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  CardKTheme *_theme;
  NSString *_title;
  UILabel *_titleLabel;
  UIView *_lineView;
  UIView *_titleContainerView;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    _theme = CardKConfig.shared.theme;

    _bundle = [NSBundle bundleForClass:[DividerView class]];

    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }
      
    _lineView = [[UIView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _titleContainerView = [[UIView alloc] init];
    
    [_titleContainerView addSubview:_titleLabel];
    [self addSubview: _lineView];
    [self addSubview: _titleContainerView];
  }
  
    return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize boundsSize = self.frame.size;

  [_titleLabel setTextColor: _theme.colorLabel];
  [_titleLabel sizeToFit];
  _titleContainerView.frame =  CGRectMake(0, 0, _titleLabel.frame.size.width + 20, _titleLabel.frame.size.height + 5);
  _titleContainerView.center = CGPointMake(boundsSize.width / 2, boundsSize.height / 2);
  _titleContainerView.backgroundColor = _theme.colorCellBackground;
  
  _titleLabel.center = CGPointMake(_titleContainerView.frame.size.width / 2, _titleContainerView.frame.size.height / 2 - 1);
  _titleLabel.textColor = _theme.colorSeparatar;
  _lineView.frame = CGRectMake(0, 0, boundsSize.width, 0.5);
  _lineView.backgroundColor = _theme.colorSeparatar;
  _lineView.center = CGPointMake(boundsSize.width / 2, boundsSize.height / 2);
}

- (void)setTitle:(NSString *)title {
  _titleLabel.text = title;
  _title = title;
}


- (NSString *)title {
  return _title;
}
@end

