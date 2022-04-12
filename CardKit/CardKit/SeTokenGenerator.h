//
//  NSObject+SeTokenGenerator.h
//  CardKit
//
//  Created by Alex Korotkov on 9/21/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardKBinding.h"
#import "CardKCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SeTokenGenerator:NSObject

+ (NSString *) generateSeTokenWithBinding:(CardKBinding *) cardKBinding;
+ (NSString *) generateSeTokenWithCardView:(CardKCardView *) cardView;

@end

NS_ASSUME_NONNULL_END
