//
//  NSObject+RequestParams.h
//  CardKit
//
//  Created by Alex Korotkov on 4/8/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestParams: NSObject

@property NSString *threeDSServerTransId;
@property NSString *threeDSSDKKey;

@property NSString *threeDSSDKEncData;
@property NSString *threeDSSDKEphemPubKey;
@property NSString *threeDSSDKAppId;
@property NSString *threeDSSDKTransId;

@property (class, readonly, strong, nonatomic) RequestParams *shared;

@end

NS_ASSUME_NONNULL_END
