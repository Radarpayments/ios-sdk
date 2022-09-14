//
//  CardKButtonView.m
//  CardKit
//
//  Created by Alex Korotkov on 21.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardKButtonView.h"
#import "CardKConfig.h"

@implementation CardKButtonView
- (instancetype)init
{
    self = [super init];
    if (self) {
      [self setTitleColor:CardKConfig.shared.theme.colorButtonText forState:UIControlStateNormal];
      self.backgroundColor = CardKConfig.shared.theme.colorButtonBackground;
      
      self.layer.cornerRadius = 8;
    }
    return self;
}

- (void)didAddSubview:(UIView *)subview {

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
}
@end
