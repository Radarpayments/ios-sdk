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

  theme.imageAppearance = @"light";
  theme.colorLabel = [UIColor colorWithRed: 0.07 green: 0.07 blue: 0.07 alpha: 1.00];
  theme.colorPlaceholder = [UIColor colorWithRed: 0.42 green: 0.42 blue: 0.42 alpha: 1.00];
  theme.colorErrorLabel = [UIColor colorWithRed: 0.85 green: 0.09 blue: 0.09 alpha: 1.00];
  theme.colorTableBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorCellBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorSeparatar = [UIColor colorWithRed: 0.86 green: 0.86 blue: 0.86 alpha: 1.00];
  theme.colorButtonText = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorButtonBackground = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 1.00];
  theme.colorInactiveButtonBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 0.24];
  theme.colorActiveBorderTextView = [UIColor colorWithRed: 0.07 green: 0.07 blue: 0.07 alpha: 1.00];
  theme.colorInactiveBorderTextView = [UIColor colorWithRed: 0.86 green: 0.86 blue: 0.86 alpha: 1.00];
  theme.colorLogoBackground = [UIColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1.00];
  
  theme.colorBottomSheetBackground = [UIColor colorWithRed: 0.98 green: 0.98 blue: 0.98 alpha: 1.00];

  
  return theme;
}

+ (CardKTheme *)darkTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];

  theme.imageAppearance = @"dark";
  theme.colorLabel = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorPlaceholder = [UIColor colorWithRed: 0.42 green: 0.42 blue: 0.42 alpha: 1.00];
  theme.colorErrorLabel = [UIColor colorWithRed: 0.85 green: 0.09 blue: 0.09 alpha: 1.00];
  theme.colorTableBackground = [UIColor colorWithRed: 0.07 green: 0.07 blue: 0.07 alpha: 1.00];
  theme.colorCellBackground = [UIColor colorWithRed: 0.07 green: 0.07 blue: 0.07 alpha: 1.00];
  theme.colorSeparatar = [UIColor colorWithRed: 0.35 green: 0.35 blue: 0.36 alpha: 1.00];
  theme.colorButtonText = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 1.00];
  theme.colorButtonBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorInactiveButtonBackground = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 0.24];
  theme.colorActiveBorderTextView = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1.00];
  theme.colorInactiveBorderTextView = [UIColor colorWithRed: 0.86 green: 0.86 blue: 0.86 alpha: 1.00];
  theme.colorLogoBackground = [UIColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1.00];
  
  theme.colorBottomSheetBackground = [UIColor colorWithRed: 0.11 green: 0.11 blue: 0.12 alpha: 1.00];

  
  return theme;
}

+ (CardKTheme *)lightTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];
    
  theme.imageAppearance = @"light";
  theme.colorLabel = [UIColor colorWithRed: 0.07 green: 0.07 blue: 0.07 alpha: 1.00];
  theme.colorPlaceholder = [UIColor colorWithRed: 0.42 green: 0.42 blue: 0.42 alpha: 1.00];
  theme.colorErrorLabel = [UIColor colorWithRed: 0.85 green: 0.09 blue: 0.09 alpha: 1.00];
  theme.colorTableBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorCellBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorSeparatar = [UIColor colorWithRed: 0.86 green: 0.86 blue: 0.86 alpha: 1.00];
  theme.colorButtonText = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 1.00];
  theme.colorButtonBackground = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 1.00];
  theme.colorInactiveButtonBackground = [UIColor colorWithRed: 1.00 green: 1.00 blue: 1.00 alpha: 0.24];
  theme.colorActiveBorderTextView = [UIColor colorWithRed: 0.07 green: 0.07 blue: 0.07 alpha: 1.00];
  theme.colorInactiveBorderTextView = [UIColor colorWithRed: 0.86 green: 0.86 blue: 0.86 alpha: 1.00];
  theme.colorLogoBackground = [UIColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1.00];
  
  theme.colorBottomSheetBackground = [UIColor colorWithRed: 0.98 green: 0.98 blue: 0.98 alpha: 1.00];

  
  return theme;
}

+ (CardKTheme *)systemTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];
 
 theme.colorLabel = [theme colorWithColorNamed:@"systemColorLabel"];
  theme.colorPlaceholder = [UIColor colorWithRed: 0.42 green: 0.42 blue: 0.42 alpha: 1.00];
  theme.colorErrorLabel = [UIColor colorWithRed: 0.85 green: 0.09 blue: 0.09 alpha: 1.00];
  theme.colorTableBackground = [theme colorWithColorNamed:@"systemColorTableBackground"];
  theme.colorCellBackground = [theme colorWithColorNamed:@"systemColorTableBackground"];
  theme.colorSeparatar = [theme colorWithColorNamed:@"systemColorSeparatar"];
  theme.colorButtonText = [theme colorWithColorNamed:@"systemColorButtonText"];
  theme.colorButtonBackground = [theme colorWithColorNamed:@"systemColorButtonBackground"];
  theme.colorInactiveButtonBackground = [UIColor colorWithRed: 0.00 green: 0.00 blue: 0.00 alpha: 0.20];
  theme.colorActiveBorderTextView = [theme colorWithColorNamed:@"systemActiveBorderTextView"];
  theme.colorInactiveBorderTextView = [UIColor colorWithRed: 0.86 green: 0.86 blue: 0.86 alpha: 1.00];
  theme.colorLogoBackground = [UIColor colorWithRed: 0.95 green: 0.95 blue: 0.95 alpha: 1.00];
  
  theme.colorBottomSheetBackground = [theme colorWithColorNamed:@"systemBottomSheetBackground"];

  return theme;
}

- (UIColor *) colorWithColorNamed:(NSString*) colorNamed {
//  NSBundle *bundle = [[NSBundle alloc] initWithPath:@"Colors.xcassets"];
  NSBundle *bundle = [NSBundle bundleForClass:[CardKTheme class]];
  return [UIColor colorNamed:colorNamed inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
