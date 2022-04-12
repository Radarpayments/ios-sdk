//
//  NSObject+CKCTokenResult.m
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CKCTokenResult.h"


CKCField CKCFieldPan = @"pan";
CKCField CKCFieldCVC = @"cvc";
CKCField CKCFieldExpiryMMYY = @"expiryMMYY";
CKCField CKCFieldCardholder = @"cardholder";
CKCField CKCFieldBindingID = @"bindingID";
CKCField CKCFieldMdOrder = @"mdOrder";
CKCField CKCFieldPubKey = @"pubKey";

CKCError CKCErrorInvalidPubKey = @"invalid-pub-key";
CKCError CKCErrorRequired = @"required";
CKCError CKCErrorInvalidFormat = @"invalid-format";
CKCError CKCErrorInvalidLength = @"invalid-length";
CKCError CKCErrorInvalid = @"invalid";

@implementation CKCTokenResult: NSObject



@end
