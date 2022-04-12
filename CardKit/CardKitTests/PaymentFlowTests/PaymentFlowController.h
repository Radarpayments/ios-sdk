//
//  PaymentFlowController.h
//  CardKit
//
//  Created by Alex Korotkov on 4/5/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CardKit.h"
#import "CardKPaymentSessionStatus.h"
#import "ConfirmChoosedCard.h"

@protocol PaymentFlowControllerDelegate

- (void)fillForm;

@end


@interface PaymentFlowController: CardKPaymentFlowController
  @property (weak, nonatomic, nullable) id<PaymentFlowControllerDelegate> delegate;
  @property (weak, nonatomic, nullable) id<CardKDelegate> cKitDelegate;
  @property BOOL doUseNewCard;
  @property BOOL unbindCard;
  @property (nullable) NSString *bindingSecureCode;

  @property (nullable) XCTestExpectation* sendErrorExpectation;

  @property (nullable) XCTestExpectation* sendRedirectErrorExpectation;

  @property (nullable) XCTestExpectation* moveChoosePaymentMethodControllerExpectation;

  @property (nullable) XCTestExpectation* didCompleteWithTransactionStatusExpectation;

  @property (nullable) XCTestExpectation* getFinishSessionStatusRequestExpectation;

  @property (nullable) XCTestExpectation* getFinishedPaymentInfoExpectation;

  @property (nullable) XCTestExpectation* processBindingFormRequestExpectation;

  @property (nullable) XCTestExpectation* processBindingFormRequestStep2Expectation;

  @property (nullable) XCTestExpectation* didCancelExpectation;

  @property (nullable) XCTestExpectation* runChallangeExpectation;

  @property (nullable) XCTestExpectation* unbindCardExpectation;

  @property (nullable) XCTestExpectation* sendErrorWithCardPaymentErrorExpectation;

  - (void)_initSDK:(CardKCardView *_Nonnull) cardView cardOwner:(NSString *_Nonnull) cardOwner seToken:(NSString *_Nonnull) seToken callback: (void (^_Nonnull)(NSDictionary *_Nonnull)) handler;

  - (void)_getSessionStatusRequest;

  - (NSArray<CardKBinding *> *_Nonnull) _convertBindingItemsToCardKBinding:(NSArray<NSDictionary *> *_Nonnull) bindingItems;
@end
