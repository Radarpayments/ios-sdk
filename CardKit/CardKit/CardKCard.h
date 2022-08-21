//
//  CardKCard.h
//  CardKit
//
//  Created by Alex Korotkov on 03.08.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKCard: NSObject

@property NSString *cardNumber;
@property NSString *expireDate;
@property (strong) NSString *secureCode;

@end

NS_ASSUME_NONNULL_END
