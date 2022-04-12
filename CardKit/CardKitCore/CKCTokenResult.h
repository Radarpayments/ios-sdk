//
//  NSObject+CKCTokenResult.h
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NSString *const CKCError NS_TYPED_ENUM;
typedef NSString *const CKCField NS_TYPED_ENUM;

extern CKCError _Nonnull const CKCErrorInvalidPubKey;
extern CKCError _Nonnull const CKCErrorRequired;
extern CKCError _Nonnull const CKCErrorInvalidFormat;
extern CKCError _Nonnull const CKCErrorInvalidLength;
extern CKCError _Nonnull const CKCErrorInvalid;

extern CKCField _Nonnull const CKCFieldPan;
extern CKCField _Nonnull const CKCFieldCVC;
extern CKCField _Nonnull const CKCFieldExpiryMMYY;
extern CKCField _Nonnull const CKCFieldCardholder;
extern CKCField _Nonnull const CKCFieldBindingID;
extern CKCField _Nonnull const CKCFieldMdOrder;
extern CKCField _Nonnull const CKCFieldPubKey;

NS_ASSUME_NONNULL_BEGIN

@interface CKCTokenResult: NSObject
@property (nullable) NSString * token;
@property (nullable) NSArray<NSDictionary *> * errors;
@end

NS_ASSUME_NONNULL_END
