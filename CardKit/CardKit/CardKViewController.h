//
//  CardKViewController.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "CardKTheme.h"
#import "CardKBinding.h"
#import "CardKCardView.h"

NS_ASSUME_NONNULL_BEGIN

@class CardKViewController;
@class CardKPaymentView;
@class CardKBindingViewController;
@class CardKApplePayButtonView;

@protocol CardKDelegate <NSObject>

- (void)didLoadController:(CardKViewController *) controller;


- (void)willShowPaymentView:(CardKApplePayButtonView *) paymentView;

- (void)cardKitViewControllerScanCardRequest:(CardKViewController *)controller;

- (void)cardKitViewController:(CardKViewController *)controller didCreateSeToken:(NSString *)seToken allowSaveBinding:(BOOL) allowSaveBinding isNewCard:(BOOL) isNewCard;

- (void)bindingViewController:(CardKBindingViewController *)controller didCreateSeToken:(NSString *)seToken allowSaveBinding:(BOOL) allowSaveBinding isNewCard:(BOOL) isNewCard;

@optional - (void)didRemoveBindings:(NSArray<CardKBinding *> *)removedBindings;

@optional - (void)cardKPaymentView:(CardKPaymentView *) paymentView didAuthorizePayment:(PKPayment *) pKPayment;

@end

@interface CardKViewController : UITableViewController

/*! Controller delegate */
@property (weak, nonatomic) id<CardKDelegate> cKitDelegate;

/*! Redefin button title */
@property (strong) NSString * purchaseButtonTitle;

/*! Allow usage card scaner */
@property BOOL allowedCardScaner;

/*! Allow save card */
@property BOOL allowSaveBinding;

/*! Initial checkbox state "save card" */
@property BOOL isSaveBinding;

/*!
@brief Assign card data
@param number Card number.
@param holderName Cardholder name.
@param date Expiration date.
@param cvc Card validation code.
*/
- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc bindingId:(nullable NSString *)bindingId;

/*!
@brief Get card data
*/
- (CardKCardView *)getCardKView;

/*!
@brief Get cardholder name
*/
- (NSString *)getCardOwner;

/*!
@brief Show scan card
@param view Instance class CardIOView.
@param animated Show card scaner with animation.
*/
- (void)showScanCardView:(UIView *)view animated:(BOOL)animated;

/*!
 @brief Definition first page
 @param cardKViewControllerDelegate Controller Delegate
 @param controller Controller instance CardKViewController
*/
+(UIViewController *) create:(id<CardKDelegate>)cardKViewControllerDelegate controller:(CardKViewController *) controller;

@end

NS_ASSUME_NONNULL_END
