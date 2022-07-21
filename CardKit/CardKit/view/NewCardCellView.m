//
//  NewCardCellView.m
//  CardKit
//
//  Created by Alex Korotkov on 17.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import "NewCardCellView.h"
#import "CardKConfig.h"

@implementation NewCardCellView {
  UIImageView * _newCardImageView;
  NSBundle *_bundle;
  UILabel *_newCardLabel;
  UIImage *_image;
  NSBundle *_languageBundle;
  UIView *_imageContainerView;
}


- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[NewCardCellView class]];
     
     NSString *language = CardKConfig.shared.language;

     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }

    _newCardLabel = [[UILabel alloc] init];
    
    _image = [self imagePath];
    
    _newCardImageView = [[UIImageView alloc] init];
    _newCardImageView.image = _image;
    
    _newCardLabel.text = [self label];
    _newCardLabel.textColor = CardKConfig.shared.theme.colorLabel;
    
    
    _imageContainerView = [[UIView alloc] init];
    [_imageContainerView addSubview:_newCardImageView];
    
    [self addSubview:_imageContainerView];
    [self addSubview:_newCardLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGRect bounds = self.bounds;
  
  _imageContainerView.frame = CGRectMake(0, 0, 36, 24);
  _imageContainerView.center = CGPointMake(35/2, bounds.size.height / 2);
  
  _newCardImageView.frame = CGRectMake(0, 0, 36, 24);
  _newCardImageView.center = CGPointMake(36/2, 24/2);
  
  _newCardLabel.frame = CGRectMake(CGRectGetMaxX(_newCardImageView.frame) + 15, 0, 100, bounds.size.height);

  CardKTheme *theme = CardKConfig.shared.theme;
  [_newCardLabel setTextColor: theme.colorLabel];
}

- (UIImage *)imagePath {
  return [UIImage imageNamed:@"add-card" inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
}

- (NSString *)label {
  return NSLocalizedStringFromTableInBundle(@"NewCard", nil, _languageBundle, @"Add new card");
}

@end
