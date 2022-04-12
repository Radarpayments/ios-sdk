//
//  UIView+CardKPaymentView.h
//  CardKit
//
//  Created by Alex Korotkov on 5/28/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "CardKViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CardKPaymentViewDelegate

@optional - (void)pressedCardPayButton;
@optional - (void)pressedApplePayButton:(PKPaymentAuthorizationViewController *) authController;

@end

@interface CardKPaymentView: UIView

/*!
 @brief Construct CardKPaymentView
 @param cKitDelegate delegate of controller
 */
- (instancetype)initWithDelegate:(id<CardKDelegate>)cKitDelegate;

/*! Controller  */
@property UIViewController *controller;

/*! MerchantId */
@property NSString *merchantId;

/*! Class instance PKPaymentRequest  */
@property PKPaymentRequest *paymentRequest;

/*! Apple Pay button type  */
@property PKPaymentButtonType paymentButtonType;

/*!  Apple Pay  button style */
@property PKPaymentButtonStyle paymentButtonStyle;

/*! Card Pay button */
@property UIButton *cardPaybutton;

/*! Render button vertical or horizontal */
@property BOOL verticalButtonsRendered;

/*! CardKPaymentView delegate */
@property (weak, nonatomic) id<CardKPaymentViewDelegate> cardKPaymentViewDelegate;

@end

NS_ASSUME_NONNULL_END
