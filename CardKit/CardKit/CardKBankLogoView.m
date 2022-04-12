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
  UIView *_coverView;
  UILabel *_titleLabel;
}

- (instancetype)init {
  if (self = [super init]) {
    CardKTheme *theme = CardKConfig.shared.theme;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setAllowsDefaultTighteningForTruncation:YES];
    [_titleLabel setMinimumScaleFactor:0.5];
    [_titleLabel setFont: [_titleLabel.font fontWithSize:22]];
    _titleLabel.textColor = theme.colorPlaceholder;
    _coverView = [[UIView alloc] init];
    [_coverView addSubview:_titleLabel];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"interOp"];
    _webView = [[CardKWebView alloc] initWithFrame:CGRectZero configuration: configuration];
    [self addSubview:_webView];
    _coverView.backgroundColor = theme.colorTableBackground;
    _webView.backgroundColor = theme.colorTableBackground;
    _webView.navigationDelegate = self;
    [self addSubview:_coverView];
    
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
  _webView.frame = CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20);
  _coverView.frame = self.bounds;
  _titleLabel.frame = _webView.frame;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
  [_webView setOpaque:NO];
  _webView.backgroundColor = UIColor.clearColor;
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
     [_coverView setHidden:NO];
     [self _showCardLogo:nil];
     currentBankName = @"";
   }
  
  if (cardNumber.length < 6) {
    [_coverView setHidden:NO];
    currentBankName = @"";
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
    [self _showCardLogo:bankInfo[isLightTheme ? @"logo" : @"logoInvert"]];
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
      NSString *logo = [responseDictionary objectForKey:@"logo"];
      NSString *logoInvert = [responseDictionary objectForKey:@"logoInvert"];

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

  UIView *coverView = _coverView;

  [_webView evaluateJavaScript:script completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    [coverView setHidden:YES];
  }];
}

- (void)showNumber:(NSString *)number {
  
  if (number.length < 6) {
    [_coverView setHidden:NO];
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
  
  UIView *coverView = _coverView;
  
  [_webView evaluateJavaScript:script completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    [coverView setHidden:YES];
  }];
  
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  decisionHandler(WKNavigationActionPolicyAllow);
}

@end

