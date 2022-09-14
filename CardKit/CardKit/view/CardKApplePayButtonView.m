//
//  ApplePayButtonView.m
//  CardKit
//
//  Created by Alex Korotkov on 14.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "CardKApplePayButtonView.h"
#import "CardKConfig.h"
#import "CardKViewController.h"

@implementation CardKApplePayButtonView {
  PKPaymentButton *_applePayButton;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  id<CardKDelegate> _cKitDelegate;
  PKPaymentAuthorizationViewController *_viewController;
  NSDictionary *_paymentData;
  PKPayment *_pKPayment;
}

- (instancetype)initWithDelegate:(id<CardKDelegate>)cKitDelegate {
  self = [super init];
  if (self) {
    _paymentRequest = [[PKPaymentRequest alloc] init];

    _bundle = [NSBundle bundleForClass:[CardKApplePayButtonView class]];
     
     NSString *language = CardKConfig.shared.language;
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    [cKitDelegate willShowPaymentView:self];

    _cKitDelegate = cKitDelegate;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self _renderButtonsVertical];
}

- (void) _changeButtonColor {
  NSString *themeMode = CardKConfig.shared.theme.imageAppearance;
  PKPaymentButtonStyle style = PKPaymentButtonStyleBlack;
  
  if (themeMode && [themeMode  isEqual: @"light"]) {
    style = PKPaymentButtonStyleBlack;
  } else if (themeMode && [themeMode  isEqual: @"dark"]) {
    style = PKPaymentButtonStyleWhite;
  }
  
  if (@available(iOS 12.0, *) ) {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark && !themeMode) {
      style = PKPaymentButtonStyleWhite;
    }
  }
  
  _applePayButton = [[PKPaymentButton alloc] initWithPaymentButtonType: _paymentButtonType paymentButtonStyle: style];
  
  [_applePayButton addTarget:self action:@selector(_applePayButtonPressed:)
  forControlEvents:UIControlEventTouchUpInside];
  
  [self addSubview: _applePayButton];
}

- (void) _renderButtonsVertical {
  CGRect bounds = self.bounds;
  
  NSInteger width = bounds.size.width;
  NSInteger maxButtonWidth = 288;
  NSInteger minMargin = 20;

  NSInteger buttonHeight = 44;
  NSInteger buttonWidth = width;
    
    if (width >= maxButtonWidth) {
    buttonWidth = maxButtonWidth;
  }
  
  if (![PKPaymentAuthorizationViewController canMakePayments] || [[_merchantId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]  isEqual: @""]) {
    _applePayButton.hidden = YES;
    
    return;
  }
  
  _applePayButton.frame = CGRectMake(minMargin, 0, bounds.size.width - minMargin * 2, buttonHeight);
}

-(void)_applePayButtonPressed:(id)sender
{
  _viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: _paymentRequest];

  _viewController.delegate = (id <PKPaymentAuthorizationViewControllerDelegate>)self;

  if (self.cardKPaymentViewDelegate) {
    [self.cardKPaymentViewDelegate pressedApplePayButton: _viewController];
  } else {
    [_controller presentViewController:_viewController animated:YES completion:nil];
  }
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
  [_controller dismissViewControllerAnimated:YES completion:nil];
  [_cKitDelegate cardKPaymentView:self didAuthorizePayment:_pKPayment];
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
  
  NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:payment.token.paymentData options:kNilOptions error:nil];
  
  _pKPayment = payment;
  
  if (dict == nil) {
    completion(PKPaymentAuthorizationStatusFailure);
    return;
  }
  
  _paymentData = dict;
  completion(PKPaymentAuthorizationStatusSuccess);
}


- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  [self _changeButtonColor];
}
@end

