//
//  CardKCardNumberTextField.h
//  CardKit
//
//  Created by Alex Korotkov on 21.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKCardNumberTextField : UIControl

@property (strong) NSString *number;
@property (strong) NSString *bindingId;
@property (strong) NSArray *errorMessages;
@property BOOL allowedCardScaner;
@property (strong, readonly) UITapGestureRecognizer *scanCardTapRecognizer;
- (void)validate;
- (void)resetLeftImage;
- (void)setLeftIconImageName:(NSString *) imageName;

@end

NS_ASSUME_NONNULL_END
