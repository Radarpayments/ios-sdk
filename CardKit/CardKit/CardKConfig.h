//
//  CardKConfig.h
//  CardKit
//
//  Created by Alex Korotkov on 10/1/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "CardKTheme.h"
#import "CardKBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKConfig : NSObject

@property (strong, nonatomic) CardKTheme *theme;
@property (nullable, strong, nonatomic) NSString *language;

@property (class, readonly, strong, nonatomic) CardKConfig *shared;

/*! Require CVC field*/
@property BOOL bindingCVCRequired;

/*! Startup mode */
@property BOOL isTestMod;

/*! Publick key */
@property NSString *pubKey;

@property NSString *rootCertificate;

/*! Identifier of order */
@property (nullable) NSString *mdOrder;

/*! Binding list */
@property NSArray<CardKBinding *> *bindings;

/*! Binding list */
@property BOOL isEditBindingListMode;

/*! URL to request test key */
@property NSString *testURL;

/*! URL to request prod key */
@property NSString *prodURL;

@property NSString *mrBinURL;

@property NSString *mrBinApiURL;

@property NSString *bindingsSectionTitle;

@property (nullable) NSString *seTokenTimestamp;

+ (void) fetchKeys:(NSString *)url;

+ (NSString *) timestampForDate:(NSDate *) date;

+ (NSString *) getVersion;
@end

NS_ASSUME_NONNULL_END
