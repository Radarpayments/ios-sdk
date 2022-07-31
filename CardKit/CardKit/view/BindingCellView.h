//
//  BindingCellView.h
//  CardKit
//
//  Created by Alex Korotkov on 16.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CardKBinding.h"
NS_ASSUME_NONNULL_BEGIN

@interface BindingCellView: UIView

@property CardKBinding *binding;

@property (strong) NSArray *errorMessages;
-(void)validate;
-(void)focusSecureCode;

@property BOOL showShortCardNumber;
@property BOOL showCVCField;
- (UIImage *) imagePath;

@end

NS_ASSUME_NONNULL_END
