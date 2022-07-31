//
//  CardKCardNumberTextField.h
//  CardKit
//
//  Created by Alex Korotkov on 21.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"
#import "CardKBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKCardNumberTextField : UIControl

@property (strong) NSString *number;
@property (nonatomic, strong) CardKBinding *binding;
@property (strong) NSArray *errorMessages;
@property BOOL allowedCardScaner;
@property (strong, readonly) UITapGestureRecognizer *scanCardTapRecognizer;
- (BOOL)validate;
- (void)resetLeftImage;
- (void)setLeftIconImageName:(NSString *) imageName;

@property (nonatomic, strong) CardKBinding *bindingId;

@end

NS_ASSUME_NONNULL_END
