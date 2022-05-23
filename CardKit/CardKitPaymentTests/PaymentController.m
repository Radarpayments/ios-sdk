//
//  PaymentController.m
//  CardKitPaymentTests
//
//  Created by Alex Korotkov on 18.05.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKKindPaymentViewController.h"
#import "CardKConfig.h"
#import "CardKBindingViewController.h"
#import "CardKCardView.h"
#import "CardKSwitchView.h"
#import "PaymentController.h"

#import "CardKPaymentSessionStatus.h"
#import "CardKPaymentError.h"

@interface CardKKindPaymentViewControllerTest: CardKKindPaymentViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end



@interface CardKPaymentController (Test)
  - (void)_sePayment;
  - (void)_sendError;

  - (void)_sePaymentStep2;
  - (void)_sendRedirectError;
  - (void)_moveChoosePaymentMethodController;
  - (void)didCompleteWithTransactionStatus:(NSString *) transactionStatus;
  - (void)_getFinishSessionStatusRequest;
  - (void)_getFinishedPaymentInfo;
  - (void)didCancel;
  - (void)_unbindСardAnon:(CardKBinding *) binding;
  - (void) _sendErrorWithCardPaymentError:(CardKPaymentError *) cardKPaymentError;

  - (void)_initSDK:(CardKCardView *) cardView cardOwner:(NSString *) cardOwner seToken:(NSString *) seToken callback: (void (^)(NSDictionary *)) handler;
  - (void) _runChallange:(NSDictionary *) responseDictionary;

  - (void)_getSessionStatusRequest;

  - (NSArray<CardKBinding *> *) _convertBindingItemsToCardKBinding:(NSArray<NSDictionary *> *) bindingItems;

  - (void) _processBindingFormRequest:(CardKBindingViewController *) choosedCard callback: (void (^)(NSDictionary *)) handler;
  - (void) _processBindingFormRequestStep2:(CardKBindingViewController *) choosedCard callback: (void (^)(NSDictionary *)) handler;
@end

@implementation PaymentController: CardKPaymentController
  - (void) _getSessionStatusRequest {
    [super _getSessionStatusRequest];
  }

  - (void)_sendError {
    [super _sendError];
  
    if (self.sendErrorExpectation != nil) {
      [self.sendErrorExpectation fulfill];
    }
  }

- (void)_sendRedirectError {
    [super _sendRedirectError];
    if (self.sendRedirectErrorExpectation != nil) {
      [self.sendRedirectErrorExpectation fulfill];
    }
  }

  - (void)_initSDK:(CardKCardView *) cardView cardOwner:(NSString *) cardOwner seToken:(NSString *) seToken callback: (void (^)(NSDictionary *)) handler {
    
    [super _initSDK:(CardKCardView *) cardView cardOwner:(NSString *) cardOwner seToken:(NSString *) seToken callback: (void (^)(NSDictionary *)) handler];
  }

  - (void) _runChallange:(NSDictionary *) responseDictionary {
    [super _runChallange:(NSDictionary *) responseDictionary];
    
    if (self.runChallangeExpectation != nil) {
      [self.runChallangeExpectation fulfill];
    }
  
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC));
    
    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
      [self _fillForm];
    });
  }

  - (void) _fillForm {
    [_delegate fillForm];
  }

  - (void)_moveChoosePaymentMethodController {
    [super _moveChoosePaymentMethodController];
    
    double delayInSeconds = 3.0;
 
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
      if (self->_unbindCard) {
        [self _runUnbindFlow];
      } else if (self->_doUseNewCard) {
        [self _runNewCardFlow];
      } else {
        [self _runBindingFlow];
      }
      
      if (self.moveChoosePaymentMethodControllerExpectation != nil) {
        [self.moveChoosePaymentMethodControllerExpectation fulfill];
      }
    });
  }

  - (void) _runNewCardFlow {
    NSInteger newCardButtonTag = 20000;
    NSInteger cardNumberTextFieldTag = 30000;
    NSInteger expireDateTextFieldTag = 30001;
    NSInteger secureCodeTextFieldTag = 30002;
    NSInteger cardOwnerTextFieldTag = 30003;
    NSInteger switchViewTag = 30004;
    NSInteger payButtonTag = 30005;
    
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    UIButton *confirmButton = (UIButton *)[window.rootViewController.view viewWithTag:newCardButtonTag];
    
    [confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    double delayInSeconds = 2.0;

    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
      UIWindow *window = UIApplication.sharedApplication.windows[0];
      
      UITextField *cardNumberTextField = (UITextField *)[window.rootViewController.view viewWithTag:cardNumberTextFieldTag];
      
      [cardNumberTextField setText:@"5555555555555599"];
      
      UITextField *expireDateTextField = (UITextField *)[window.rootViewController.view viewWithTag:expireDateTextFieldTag];
      
      [expireDateTextField setText:@"1224"];
      
      
      UITextField *secureCodeTextField = (UITextField *)[window.rootViewController.view viewWithTag:secureCodeTextFieldTag];

      if (self.bindingSecureCode != nil) {
        [secureCodeTextField setText: self.bindingSecureCode];
        self.bindingSecureCode = nil;
      } else {
        [secureCodeTextField setText: @"123"];
      }
      
      UITextField *cardOwnerTextField = (UITextField *)[window.rootViewController.view viewWithTag:cardOwnerTextFieldTag];
      
      [cardOwnerTextField setText:@"Alex Korotkov"];
      
      CardKSwitchView *switchView = (CardKSwitchView *)[window.rootViewController.view viewWithTag:switchViewTag];
      
      switchView.isSaveBinding = YES;
      
      UIButton *payButton = (UIButton *)[window.rootViewController.view viewWithTag:payButtonTag];

      [payButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
  }

  - (void) _runBindingFlow {
    NSInteger secureCodeTextFieldTag = 30006;
    NSInteger payButtonTag = 30007;
    
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    
    UINavigationController *navController = (UINavigationController *)window.rootViewController;
    
    PaymentController *PaymentController = navController.viewControllers.firstObject;
    
    CardKKindPaymentViewController *kindPaymentViewController =  PaymentController.childViewControllers.firstObject;
    
    UITableView *tableView = (UITableView *)[navController.view viewWithTag:40001];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [kindPaymentViewController tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    double delayInSeconds = 3.0;

    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
      UIWindow *window = UIApplication.sharedApplication.windows[0];
      
      if (CardKConfig.shared.bindingCVCRequired) {
        UITextField *secureCodeTextField = (UITextField *)[window.rootViewController.view viewWithTag:secureCodeTextFieldTag];

        if (self.bindingSecureCode != nil) {
          [secureCodeTextField setText: self.bindingSecureCode];
          self.bindingSecureCode = nil;
        } else {
          [secureCodeTextField setText: @"123"];
        }
        
      }
      
      UIButton *payButton = (UIButton *)[window.rootViewController.view viewWithTag:payButtonTag];

      [payButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
  }

  - (void)_runUnbindFlow {
    UIWindow *window = UIApplication.sharedApplication.windows[0];
    
    UINavigationController *navController = (UINavigationController *)window.rootViewController;
    
    PaymentController *PaymentController = navController.viewControllers.firstObject;
    
    CardKKindPaymentViewController *kindPaymentViewController =  PaymentController.childViewControllers.firstObject;
    
    UITableView *tableView = (UITableView *)[navController.view viewWithTag:40001];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];

    [kindPaymentViewController tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
  }

  - (void)_unbindСardAnon:(CardKBinding *) binding {
    [super _unbindСardAnon:binding];

    if (self.unbindCardExpectation != nil) {
      [self.unbindCardExpectation fulfill];
    }
  }

  - (void)didCompleteWithTransactionStatus:(NSString *) transactionStatus{
    [super didCompleteWithTransactionStatus:transactionStatus];

    if (self.didCompleteWithTransactionStatusExpectation != nil) {
      [self.didCompleteWithTransactionStatusExpectation fulfill];
    }
  }

  - (void)_getFinishSessionStatusRequest {
    [super _getFinishSessionStatusRequest];

    if (self.getFinishSessionStatusRequestExpectation != nil) {
      [self.getFinishSessionStatusRequestExpectation fulfill];
    }
  }

  - (void)_getFinishedPaymentInfo {
    [super _getFinishedPaymentInfo];

    if (self.getFinishedPaymentInfoExpectation != nil) {
      [self.getFinishedPaymentInfoExpectation fulfill];
    }
  }

  - (void) _processBindingFormRequest:(CardKBindingViewController *) choosedCard callback: (void (^)(NSDictionary *)) handler {
    [super _processBindingFormRequest:choosedCard callback:handler];
    
    if (self.processBindingFormRequestExpectation != nil) {
      [self.processBindingFormRequestExpectation fulfill];
    }
  }

  - (void) _processBindingFormRequestStep2:(CardKBindingViewController *) choosedCard callback: (void (^)(NSDictionary *)) handler {
    [super _processBindingFormRequestStep2:choosedCard callback:handler];
    
    if (self.processBindingFormRequestStep2Expectation != nil) {
      [self.processBindingFormRequestStep2Expectation fulfill];
    }
  }

  - (void)didCancel {
    [super didCancel];
    
    [self.didCancelExpectation fulfill];
  }

  - (void) _sendErrorWithCardPaymentError:(CardKPaymentError *) cardKPaymentError {
    [super _sendErrorWithCardPaymentError: cardKPaymentError];
    
    if (self.sendErrorWithCardPaymentErrorExpectation != nil) {
      [self.sendErrorWithCardPaymentErrorExpectation fulfill];
    }
  }

  - (NSArray<CardKBinding *> *) _convertBindingItemsToCardKBinding:(NSArray<NSDictionary *> *) bindingItems {
    NSArray<CardKBinding *> *cardKBindings = [super _convertBindingItemsToCardKBinding:bindingItems];
    return  cardKBindings;
  }
@end
