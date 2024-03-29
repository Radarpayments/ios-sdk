//
//  UIViewController+CardKBankItem.m
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKBinding.h"
#import "PaymentSystemProvider.h"
#import "CardKConfig.h"

#import "CardKTextField.h"
#import "CardKValidation.h"
#import "CardKBankLogoView.h"
#import <CardKitCore/CardKitCore.h>

@implementation CardKBinding
- (NSString *)formatedExpireDate {
  return [_expireDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
