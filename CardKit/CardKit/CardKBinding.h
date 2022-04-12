//
//  UIViewController+CardKBankItem.h
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKBinding: UIView

@property NSString *bindingId;
@property NSString *paymentSystem;
@property NSString *cardNumber;
@property NSString *expireDate;
@property BOOL showCVCField;
@property UIImage *imagePath;

@property (strong) NSArray *errorMessages;
@property (strong) NSString *secureCode;
-(void)validate;
-(void)focusSecureCode;

@end

NS_ASSUME_NONNULL_END
