//
//  NSObject+CardKPaymentFlow.h
//  CardKit
//
//  Created by Alex Korotkov on 3/26/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CardKit/CardKViewController.h>

#import "CardKPaymentError.h"

@protocol CardKPaymentManagerDelegate <NSObject>
- (void)didFinishPaymentFlow:(NSDictionary *) paymentInfo;
- (void)didErrorPaymentFlow:(CardKPaymentError *) paymentError;
- (void)didCancelPaymentFlow;
- (void)scanCardRequest:(CardKViewController *)controller;
@end

@interface CardKPaymentManager: NSObject
  @property (weak, nonatomic) id<CardKPaymentManagerDelegate> cardKPaymentDelegate;

  @property CardKPaymentView* cardKPaymentView;
  @property NSString* url;
  @property UIColor* primaryColor;
  @property UIColor* textDoneButtonColor;
  @property BOOL allowedCardScaner;
  @property NSString *headerLabel;
  @property NSString *directoryServerId;
  @property NSString *mdOrder;
  @property BOOL use3ds2sdk;
  @property (readonly) UINavigationController *sdkNavigationController;

- (void) presentViewController:(UINavigationController *)navController;

@end
