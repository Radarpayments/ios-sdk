//
//  CardKTheme.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKTheme : NSObject

/*! Text color */
@property (strong, nonatomic) UIColor *colorLabel;
/*! Placeholder color */
@property (strong, nonatomic) UIColor *colorPlaceholder;
/*! Error color */
@property (strong, nonatomic) UIColor *colorErrorLabel;
/*! Background color */
@property (strong, nonatomic) UIColor *colorTableBackground;
/*! Cell color */
@property (strong, nonatomic, nullable) UIColor *colorCellBackground;
/*! Cell border color */
@property (strong, nonatomic) UIColor *colorSeparatar;
/*! Color text button */
@property (strong, nonatomic) UIColor *colorButtonText;
/*! Background button */
@property (strong, nonatomic) UIColor *colorButtonBackground;
/*! Active TextField bottom line  */
@property (strong, nonatomic) UIColor *colorActiveBorderTextView;
/*! Inactive TextField bottom line  */
@property (strong, nonatomic) UIColor *colorInactiveBorderTextView;

@property (strong, nonatomic, nullable) NSString *imageAppearance;

/*! Bank logo background  */
@property (strong, nonatomic) UIColor *colorLogoBackground;

/* Inactive button background */
@property (strong, nonatomic) UIColor *colorInactiveButtonBackground;

/*!
@brief Default theme
@return CardKTheme
 */
+ (CardKTheme *)defaultTheme;
/*!
@brief Dark theme
@return CardKTheme
 */
+ (CardKTheme *)darkTheme;
/*!
@brief Light theme
@return CardKTheme
 */
+ (CardKTheme *)lightTheme;
/*!
@brief System theme only for iOS 13.0 +
@return CardKTheme
 */
+ (CardKTheme *)systemTheme API_AVAILABLE(ios(13.0));
/*!
@brief Set theme
 */
//+ (void)setTheme:(CardKTheme *)theme;
@end

NS_ASSUME_NONNULL_END
