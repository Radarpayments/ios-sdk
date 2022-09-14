//
//  CardKUIImage.m
//  CardKit
//
//  Created by Alex Korotkov on 31.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardKitImageProvider.h"
#import "CardKConfig.h"

@implementation CardKitImageProvider


+ (NSString *) getImageAppearanceWithTraitCollection:(UITraitCollection *) traitCollection {
  if (@available(iOS 12.0, *)) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
      return @"dark";
    } else {
      return @"light";
    }
  } else {
    return @"light";
  }
}

+ (UIImage *)namedImage:(NSString *)imageName inBundle: (NSBundle *)bundle compatibleWithTraitCollection:(UITraitCollection *) traitCollection {
  NSString *imageAppearance = CardKConfig.shared.theme.imageAppearance;

  if (imageAppearance == nil) {
    imageAppearance = [CardKitImageProvider getImageAppearanceWithTraitCollection: traitCollection];
  }

  NSString *imageNameWithAppearance = [NSString stringWithFormat:@"%@-%@", imageName, imageAppearance];
  
  UIImage *image = [UIImage imageNamed:imageNameWithAppearance inBundle:bundle compatibleWithTraitCollection:nil];
  
  if (image) {
    return image;
  }
    
  return [UIImage imageNamed:imageName inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:traitCollection];
}

@end
