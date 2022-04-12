//
//  NSObject+CKCToken.h
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKCTokenResult.h"
#import "CKCBindingParams.h"
#import "CKCCardParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface CKCToken: NSObject
- (instancetype) init NS_UNAVAILABLE;
+ (CKCTokenResult *) generateWithBinding: (CKCBindingParams *) params;
+ (CKCTokenResult *) generateWithCard: (CKCCardParams *) params;
+ (NSString *) timestampForDate:(NSDate *) date;
+ (NSString *) getVersion;
@end

NS_ASSUME_NONNULL_END
