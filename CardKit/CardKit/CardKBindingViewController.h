//
//  CardKBindingViewController.h
//  CardKit
//
//  Created by Alex Korotkov on 5/21/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKBinding.h"
#import "CardKBankLogoView.h"
#import "CardKViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKBindingViewController: UITableViewController

@property CardKBinding *cardKBinding;
@property CardKBankLogoView *bankLogoView;
@property (weak, nonatomic) id<CardKDelegate> cKitDelegate;

@end

NS_ASSUME_NONNULL_END

//- (void)_buttonPressed:(UIButton *)button {
//  if (![self _isFormValid]) {
//    [self _animateError];
//    _lastAnouncment = nil;
//    [self _announceError];
//    return;
//  }
//  
//  NSString *seToken = [SeTokenGenerator generateSeTokenWithBinding:_cardKBinding];
//
//  [_cKitDelegate bindingViewController:self didCreateSeToken:seToken allowSaveBinding:NO isNewCard: NO];
//}
