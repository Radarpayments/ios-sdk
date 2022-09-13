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

- (void) _processBindingFormRequest;
- (void) _processBindingFormRequestStep2;
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

- (UIViewController *) _activeViewController {
  UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
  UIViewController *navController = window.rootViewController;
  return navController.presentedViewController;
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
  NSInteger switchViewTag = 30004;
  NSInteger payButtonTag = 30005;
  
  UIViewController *viewController = [self _activeViewController];
  UITableView *tableView = (UITableView *)[viewController.view viewWithTag:40001];
  UITableViewCell *newCardcell = (UITableViewCell *)[viewController.view viewWithTag:newCardButtonTag];
  NSIndexPath *indexPath = [tableView indexPathForCell:newCardcell];
  
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
  [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  //    [confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  
  
  double delayInSeconds = 2.0;
  
  dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  
  dispatch_after(timer, dispatch_get_main_queue(), ^(void){
    UIViewController *viewController = [self _activeViewController];
    
    UITextField *cardNumberTextField = (UITextField *)[viewController.view viewWithTag:cardNumberTextFieldTag];
    
    [cardNumberTextField setText:@"5555555555555599"];
    
    UITextField *expireDateTextField = (UITextField *)[viewController.view viewWithTag:expireDateTextFieldTag];
    
    [expireDateTextField setText:@"1224"];
    
    
    UITextField *secureCodeTextField = (UITextField *)[viewController.view viewWithTag:secureCodeTextFieldTag];
    
    if (self.bindingSecureCode != nil) {
      [secureCodeTextField setText: self.bindingSecureCode];
      self.bindingSecureCode = nil;
    } else {
      [secureCodeTextField setText: @"123"];
    }
    
    CardKSwitchView *switchView = (CardKSwitchView *)[viewController.view viewWithTag:switchViewTag];
    
    switchView.isSaveBinding = YES;
    
    UIButton *payButton = (UIButton *)[viewController.view viewWithTag:payButtonTag];
    
    [payButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  });
}

- (void) _runBindingFlow {
  NSInteger secureCodeTextFieldTag = 30002;
  NSInteger payButtonTag = 30005;
  
  UIViewController *viewController = [self _activeViewController];
  
  UITableView *tableView = (UITableView *)[viewController.view viewWithTag:40001];
  
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
  
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
  [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  
  double delayInSeconds = 3.0;
  
  dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  
  dispatch_after(timer, dispatch_get_main_queue(), ^(void){
    UIViewController *viewController = [self _activeViewController];
    
    if (CardKConfig.shared.bindingCVCRequired) {
      UITextField *secureCodeTextField = (UITextField *)[viewController.view viewWithTag:secureCodeTextFieldTag];
      
      if (self.bindingSecureCode != nil) {
        [secureCodeTextField setText: self.bindingSecureCode];
        self.bindingSecureCode = nil;
      } else {
        [secureCodeTextField setText: @"123"];
      }
      
    }
    
    UIButton *payButton = (UIButton *)[viewController.view viewWithTag:payButtonTag];
    
    [payButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  });
}

- (void)_runUnbindFlow {
  NSInteger savedCardsTag = 40002;
  NSInteger editButtonTag = 20005;
  NSInteger bucketImage = 20006;
  NSInteger secureCodeTextFieldTag = 30002;
  NSInteger payButtonTag = 30005;
  
  
  UIViewController *viewController = [self _activeViewController];
  UITableView *tableView = (UITableView *)[viewController.view viewWithTag:40001];
  UITableViewCell *saveCardsCell = (UITableViewCell *)[viewController.view viewWithTag:savedCardsTag];
  NSIndexPath *indexPath = [tableView indexPathForCell:saveCardsCell];
  
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
  [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  
  
  double delayInSeconds = 3.0;
  
  dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  
  dispatch_after(timer, dispatch_get_main_queue(), ^(void){
    UIViewController *viewController = [self _activeViewController];
      
      UIViewController *allPayments = self.sdkNavigationController.viewControllers[1];
      
  
      UIBarButtonItem *editButton = (UIBarButtonItem *)allPayments.navigationItem.rightBarButtonItem;
    UIButton *bucketButton = (UIButton *)[viewController.view viewWithTag:bucketImage];
    [bucketButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
  });
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

- (void) _processBindingFormRequest {
  [super _processBindingFormRequest];
  
  if (self.processBindingFormRequestExpectation != nil) {
    [self.processBindingFormRequestExpectation fulfill];
  }
}

- (void) _processBindingFormRequestStep2 {
  [super _processBindingFormRequestStep2];
  
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
