//
//  CardKTheme.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKTheme.h"
#import <UIKit/UIKit.h>

@implementation CardKTheme
+ (CardKTheme *)defaultTheme {
  
  CardKTheme *theme = [[CardKTheme alloc] init];

  theme.colorLabel = UIColor.blackColor;
  theme.colorPlaceholder = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = UIColor.groupTableViewBackgroundColor;
  theme.colorCellBackground = UIColor.whiteColor;
  theme.imageAppearance = @"dark";
  theme.colorButtonText = UIColor.systemBlueColor;

  return theme;
}

+ (CardKTheme *)darkTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];

  theme.colorLabel = UIColor.whiteColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorPlaceholder = [UIColor colorWithRed:0.39f green:0.39f blue:0.40f alpha:1.0f];
  theme.colorTableBackground = [UIColor blackColor];
  theme.colorCellBackground = [UIColor colorWithRed:0.11f green:0.11f blue:0.12f alpha:1.0f];
  theme.colorSeparatar = [UIColor colorWithRed:0.10f green:0.10f blue:0.11f alpha:1.0f];
  theme.imageAppearance = @"dark";
  theme.colorButtonText = UIColor.systemBlueColor;

  return theme;
}

+ (CardKTheme *)lightTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];
    
  theme.colorLabel = UIColor.blackColor;
  theme.colorPlaceholder = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = [UIColor colorWithRed:0.95f green:0.95f blue:0.97f alpha:1.0f];
  theme.colorCellBackground = UIColor.whiteColor;
  theme.colorSeparatar = [UIColor colorWithRed:0.24f green:0.24f blue:0.26f alpha:0.29f];
  theme.imageAppearance = @"light";
  theme.colorButtonText = UIColor.systemBlueColor;
  
  return theme;
}

+ (CardKTheme *)systemTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];
  theme.colorLabel = UIColor.labelColor;
  theme.colorPlaceholder = UIColor.placeholderTextColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = UIColor.groupTableViewBackgroundColor;
  theme.colorCellBackground = nil;
  theme.colorSeparatar = UIColor.separatorColor;
  theme.imageAppearance = nil;
  theme.colorButtonText = UIColor.systemBlueColor;

  return theme;
}


@end
