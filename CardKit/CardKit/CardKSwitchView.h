//
//  NSObject+CardKSwitchView.h
//  CardKit
//
//  Created by Alex Korotkov on 5/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKSwitchView : UIView

@property NSString *title;
- (UISwitch *) getSwitch;

@property (nonatomic) BOOL isSaveBinding;

@end

NS_ASSUME_NONNULL_END
