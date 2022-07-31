//
//  UITableViewController+CardKKindPaymentViewController.h
//  CardKit
//
//  Created by Alex Korotkov on 5/13/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKViewController.h"
#import "CardKPaymentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKKindPaymentViewController: UIViewController<CardKPaymentViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UITableViewDelegate, UITableViewDataSource>

/*! Controller delegate */
@property (weak, nonatomic) id<CardKDelegate> cKitDelegate;

/*! Render button vertical or horizontal */
@property BOOL verticalButtonsRendered;

@end

NS_ASSUME_NONNULL_END
