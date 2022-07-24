//
//  BankLogoView.m
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKBankLogoView.h"
#import <WebKit/WebKit.h>
#import "CardKConfig.h"

@interface CardKWebView: WKWebView {
}
@end

@implementation CardKWebView {
}
- (BOOL)canResignFirstResponder
{
  return NO;
}

- (BOOL)becomeFirstResponder
{
  return NO;
}

- (void)_keyboardDidChangeFrame:(id)sender
{
  
}

- (void)_keyboardWillChangeFrame:(id)sender
{
  
}

- (void)_keyboardWillShow:(id)sender
{
  
}

- (void)_keyboardWillHide:(id)sender
{
  
}


@end

@interface CardKBankLogoView () <WKScriptMessageHandler, WKNavigationDelegate>
@end


@implementation CardKBankLogoView {
  CardKWebView *_webView;
  UIView *_webViewContainer;
  UILabel *_titleLabel;
}

- (instancetype)init {
  if (self = [super init]) {
    CardKTheme *theme = CardKConfig.shared.theme;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"interOp"];
    
    _webView = [[CardKWebView alloc] initWithFrame:CGRectZero configuration: configuration];
      
    _webViewContainer = [[UIView alloc] init];
    _webViewContainer.layer.cornerRadius = 12;
    _webViewContainer.backgroundColor = theme.colorInactiveBorderTextView;
    _webView.backgroundColor = theme.colorInactiveBorderTextView;
      
    [_webViewContainer addSubview:_webView];
    [self addSubview:_webViewContainer];
      
    _webView.navigationDelegate = self;
    
    NSBundle *bundle = [NSBundle bundleForClass:[CardKBankLogoView class]];
    NSString *path = [bundle pathForResource:@"index" ofType:@"html" inDirectory:@"banks-info"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_webView loadFileURL:url allowingReadAccessToURL:url];
    [_webView setUserInteractionEnabled:NO];
  }
  return self;
}

- (nullable NSString *)title {
  return _titleLabel.text;
}

- (void)setTitle:(NSString *)title {
  _titleLabel.text = title;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _webViewContainer.frame = CGRectMake(0, 0, 40, 40);
  _webView.frame = CGRectMake(0, 0, 32, 32);
  _webView.center = CGPointMake(40/2, 40/2);
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
  [_webView setOpaque:NO];
  _webView.backgroundColor = [UIColor clearColor];
}



- (BOOL) isLightTheme {
   NSString *imageAppearance = CardKConfig.shared.theme.imageAppearance;
  
  if (imageAppearance == nil) {
    if (@available(iOS 12.0, *)) {
      if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        imageAppearance = @"dark";
      } else {
        imageAppearance = @"light";
      }
    } else {
      imageAppearance = @"light";
    }
  }
  
  return [imageAppearance isEqualToString:@"light"];
}

- (void) fetchBankInfo:(NSString *)url cardNumber: (NSString *) cardNumber {
  static NSMutableDictionary *hashTable = nil;
  static NSString *currentBankName = nil;
  if ([_titleLabel.text isEqual:@""]) {
     [self _showCardLogo:nil];
     currentBankName = @"";
   }
  
  if (cardNumber.length < 6) {
    currentBankName = @"";
    [self _showCardLogo:nil];
    return;
  }
  
  BOOL isLightTheme = [self isLightTheme];
  
  if (hashTable == nil) {
    hashTable = [[NSMutableDictionary alloc] init];
  }
  
  if (currentBankName == nil) {
    currentBankName = @"";
  }
  
   NSDictionary *bankInfo =  hashTable[[cardNumber substringToIndex:6]];
  
  if ([cardNumber length] >= 8) {
    bankInfo = hashTable[[cardNumber substringToIndex:8]];
  }
  
  NSDictionary *jsonBodyDict = @{@"bin":cardNumber};

  if (bankInfo != nil && [bankInfo[@"name"] isEqualToString: currentBankName]) {
    return;
  } else if (bankInfo != nil) {
    currentBankName = bankInfo[@"name"];
    [self _showCardLogo:bankInfo[isLightTheme ? @"logoMini" : @"logoMini"]];
    return;
  }

  NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setHTTPMethod:@"POST"];
  [request setURL:[NSURL URLWithString:url]];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:jsonBodyData];

  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    if (error != nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self _showCardLogo:nil];
      });

      return;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse.statusCode == 200)
    {
      NSError *parseError = nil;
      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
      NSString *logo = [responseDictionary objectForKey:@"logoMini"];
      NSString *logoInvert = [responseDictionary objectForKey:@"logoMini"];

      [hashTable setObject:responseDictionary forKey:cardNumber];
      dispatch_async(dispatch_get_main_queue(), ^{
        if ([responseDictionary[@"name"] isEqualToString: currentBankName]) {
          return;
        }

        currentBankName = responseDictionary[@"name"];
        
        [self _showCardLogo:isLightTheme ? logo : logoInvert];
      });
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self _showCardLogo:nil];
    });
    
    return;
  }];
  
  [dataTask resume];
}

- (void)_showCardLogo: (NSString *)logo {
  NSString *script;
  
  if (logo == nil) {
    BOOL isLightTheme = [self isLightTheme];
    NSString *folderName = isLightTheme ? @"color" : @"white";

    script = [NSString stringWithFormat:@"__showBankLogo(\"%@%@%@\");", @"./images/bank-logos/", folderName, @"/unknown.svg"];
  } else {
    script = [NSString stringWithFormat:@"__showBankLogo(\"%@%@\");", CardKConfig.shared.mrBinURL, logo];
  }

  [_webView evaluateJavaScript:script completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
  }];
}

- (void)showNumber:(NSString *)number {
  
  if (number.length < 6) {
    return;
  }

  NSString *imageAppearance = CardKConfig.shared.theme.imageAppearance;

  if (imageAppearance == nil) {
    if (@available(iOS 12.0, *)) {
      if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        imageAppearance = @"dark";
      } else {
        imageAppearance = @"light";
      }
    } else {
      imageAppearance = @"light";
    }
  }
  
  NSString *script = [NSString stringWithFormat:@"__showBank(\"%@\", %d);", number, [imageAppearance isEqualToString:@"dark"]];
  
  [_webView evaluateJavaScript:script completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
  }];
  
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self _showCardLogo:nil];
}

@end

