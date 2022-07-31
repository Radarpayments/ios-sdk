//
//  ApplePayButtonView.h
//  CardKit
//
//  Created by Alex Korotkov on 14.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "CardKViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CardKApplePayButtonViewDelegate

@optional - (void)pressedApplePayButton:(PKPaymentAuthorizationViewController *) authController;

@end

@interface CardKApplePayButtonView: UIView

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

/*! CardKPaymentView delegate */
@property (weak, nonatomic) id<CardKApplePayButtonViewDelegate> cardKPaymentViewDelegate;

@end

NS_ASSUME_NONNULL_END
