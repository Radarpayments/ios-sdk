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

@property NSString *userName;
@property NSString *password;
@property NSString *amount;
@property NSString *returnUrl;
@property NSString *failUrl;
@property NSString *email;

@property NSString *orderId;
@property NSString *seToken;
@property NSString *text;
@property NSString *threeDSSDK;
@property NSString *threeDSServerTransId;
@property NSString *threeDSSDKKey;
@property NSString *cliendId;

@property NSString *threeDSSDKEncData;
@property NSString *threeDSSDKEphemPubKey;
@property NSString *threeDSSDKAppId;
@property NSString *threeDSSDKTransId;

@property (class, readonly, strong, nonatomic) RequestParams *shared;

@end

NS_ASSUME_NONNULL_END
