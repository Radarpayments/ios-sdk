//
//  NSObject+ARes.h
//  CardKit
//
//  Created by Alex Korotkov on 4/8/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARes: NSObject
@property NSString *transStatus;
@property NSString *acsSignedContent;
@property NSString *acsReferenceNumber;
@property NSString *acsTransID;
@property NSString *threeDSServerTransID;
@end

NS_ASSUME_NONNULL_END
