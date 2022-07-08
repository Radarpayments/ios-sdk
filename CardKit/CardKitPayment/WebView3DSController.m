//
//  3DSWebViewController.m
//  CardKitPayment
//
//  Created by Alex Korotkov on 17.06.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "WebView3DSController.h"

@implementation WebView3DSController {
  WKWebView *_wkWebView;
  NSTimer *_noActionTimer;
}
- (instancetype)init {
    _wkWebView = [[WKWebView alloc] init];
    [self.view addSubview:_wkWebView];
    _wkWebView.navigationDelegate = self;
    
    _noActionTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(_finishWithTimeOut:) userInfo: nil repeats:NO];
    return self;
}


- (void)viewDidLayoutSubviews {
    NSString * html = [self _getHtmlString];
    [_wkWebView loadHTMLString: html baseURL: nil];
    
    _wkWebView.frame = self.view.bounds;
}


- (NSString *) _getHtmlString {
    NSString *html = [[NSString alloc] initWithFormat:@"<html>"
    "<head><title>ACS Redirect</title></head>"
    "<body onload=\"document.forms['acs'].submit()\">"
    "ACS Redirect"
    "<form id=\"acs\" method=\"post\" action=\"%@\">"
        "<input type=\"hidden\" id=\"MD\" name=\"MD\" value=\"%@\"/>"
        "<input type=\"hidden\" id=\"PaReq\" name=\"PaReq\" value=\"%@\"/>"
        "<input type=\"hidden\" id=\"TermUrl\" name=\"TermUrl\" value=\"%@\"/>"
    "</form>"
    "</body>"
    "</html>", self.acsUrl, self.mdOrder, self.paReq, self.termUrl];
    
    return  html;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

  NSURLRequest *request = navigationAction.request;
  
  if (!request.URL.absoluteString) {
    decisionHandler(WKNavigationActionPolicyAllow);
    return;
  }
  
  if ([request.URL.absoluteString containsString:@"sdk://done"]) {
    [self _finishPayment];
    decisionHandler(WKNavigationActionPolicyCancel);
  } else {
    decisionHandler(WKNavigationActionPolicyAllow);
  }
}

- (void)_finishPayment {
  [self _dissmisController];
  
  NSDictionary *nsDictionary = [[NSDictionary alloc] init];
  [self.cardKPaymentDelegate didFinishPaymentFlow:nsDictionary];
}

- (void)_finishWithTimeOut:(NSTimer *) timer {
  [self _dissmisController];
  
  CardKPaymentError *error = [[CardKPaymentError alloc] init];
  error.message = @"3ds1 was finished by timeout";
  [self.cardKPaymentDelegate didErrorPaymentFlow:error];
}

- (void)_dissmisController {
  [self dismissViewControllerAnimated:YES completion:^(void) {
    [self _finishTimer];
  }];
}

- (void)_finishTimer {
  [_noActionTimer invalidate];
}

@end
