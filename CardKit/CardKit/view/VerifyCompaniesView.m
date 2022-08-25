//
//  VerifyCompaniesView.m
//  CardKit
//
//  Created by Alex Korotkov on 02.08.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VerifyCompaniesView.h"
#import "CardKConfig.h"


@implementation VerifyCompaniesView{
    NSBundle *_bundle;
    NSBundle *_languageBundle;
    UIView *_imagesContainer;
    UIImageView *_visaImageView;
    UIImageView *_jsbImageView;
    UIImageView *_pciImageView;
    UIImageView *_mastercardImageView;
    UIImageView *_mirImageView;
  }
- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[VerifyCompaniesView class]];
     
     NSString *language = CardKConfig.shared.language;

     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
      
      _imagesContainer = [[UIView alloc] init];
      
    _visaImageView = [[UIImageView alloc] init];
    _jsbImageView = [[UIImageView alloc] init];
    _pciImageView = [[UIImageView alloc] init];
    _mastercardImageView = [[UIImageView alloc] init];
    _mirImageView = [[UIImageView alloc] init];
    
      NSArray *verifyCompanies = @[
        @{ @"view": _visaImageView, @"name": @"verify-visa"},
        @{ @"view": _jsbImageView, @"name": @"verify-jcb"},
        @{ @"view": _pciImageView, @"name": @"verify-pci"},
        @{ @"view": _mastercardImageView, @"name": @"verify-mastercard"},
        @{ @"view": _mirImageView, @"name": @"verify-mir"}
      ];
    
    for (NSDictionary *verifyCompany in verifyCompanies) {
        UIImageView *imageView = verifyCompany[@"view"];

        imageView.image = [UIImage imageNamed:verifyCompany[@"name"] inBundle:_bundle compatibleWithTraitCollection:nil];

        [_imagesContainer addSubview: imageView];
    }
    
    [self addSubview:_imagesContainer];
  }
  return self;
}

- (NSArray*) _images {
  return @[_visaImageView, _jsbImageView, _pciImageView, _mastercardImageView, _mirImageView];
}


- (void)layoutSubviews {
  [super layoutSubviews];
  
  NSInteger index = 0;
  
  for (UIImageView *_image in [self _images]) {
    NSInteger offset = _image.image.size.width;

    if (offset < 60) {
      offset = 60;
    }
    
    _image.frame = CGRectMake(index * offset, 0, _image.image.size.width, _image.image.size.height);
    index++;
  }
  
  
  NSInteger lastX = CGRectGetMaxX([[[self _images] lastObject] frame]);
  _imagesContainer.frame = CGRectMake(0, 0, lastX, self.bounds.size.height);
  _imagesContainer.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}
@end
