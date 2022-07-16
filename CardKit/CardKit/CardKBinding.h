//
//  UIViewController+CardKBankItem.h
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKBinding: NSObject

@property NSString *bindingId;
@property NSString *paymentSystem;
@property NSString *cardNumber;
@property NSString *expireDate;
@property UIImage *imagePath;
@property (strong) NSString *secureCode;

@end

NS_ASSUME_NONNULL_END
