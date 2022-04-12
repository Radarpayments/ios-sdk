//
//  NSObject+CKCBindingParams.h
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKCBindingParams: NSObject
@property NSString * bindingID;
@property (nullable) NSString * cvc;
@property NSString * mdOrder;
@property NSString * pubKey;
@property (nullable) NSString * seTokenTimestamp;
@end

NS_ASSUME_NONNULL_END
