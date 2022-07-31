//
//  CardKAllPaymentMethodsController.h
//  CardKit
//
//  Created by Alex Korotkov on 17.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKViewController.h"
#import "CardKPaymentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKAllPaymentMethodsController: UITableViewController<CardKPaymentViewDelegate>

/*! Controller delegate */
@property (weak, nonatomic) id<CardKDelegate> cKitDelegate;

@end

NS_ASSUME_NONNULL_END
