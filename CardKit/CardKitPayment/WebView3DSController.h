//  3DSWebViewController.h
//  CardKit
//
//  Created by Alex Korotkov on 17.06.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "CardKPaymentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebView3DSController: UIViewController<WKNavigationDelegate>

@property NSString *acsUrl;
@property NSString *mdOrder;
@property NSString *paReq;
@property NSString *termUrl;
@property (weak, nonatomic) id<CardKPaymentDelegate> cardKPaymentDelegate;

@end

NS_ASSUME_NONNULL_END
