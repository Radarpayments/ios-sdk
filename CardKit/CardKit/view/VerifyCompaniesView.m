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
      
    NSArray *verifyCompanies = @[@"verify-visa", @"verify-jsb", @"verify-pci", @"verify-mastercard", @"verify-mir"];
    
    for (NSString *verifyCompany in verifyCompanies) {
        UIImageView * uiImage = [[UIImageView alloc] init];
        uiImage.image = [UIImage imageNamed:verifyCompany];
        
        [_imagesContainer addSubview: uiImage];
    }
      
      [self addSubview:_imagesContainer];
  }
  return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imagesContainer.frame = CGRectMake(0, 0, self.bounds.size.width, 62);
}
@end
