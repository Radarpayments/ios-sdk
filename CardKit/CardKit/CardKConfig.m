//
//  CardKConfig.m
//  CardKit
//
//  Created by Alex Korotkov on 10/1/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKConfig.h"
#import <CardKitCore/CardKitCore.h>

static CardKConfig *__instance = nil;

@implementation CardKConfig
+ (CardKConfig *)defaultConfig {

  CardKConfig *config = [[CardKConfig alloc] init];

  config.theme = CardKTheme.defaultTheme;
  config.language = nil;
  config.isTestMod = false;

  return config;
}

- (void)setLanguage:(NSString *)language {
  NSArray *codes = [NSArray arrayWithObjects:@"en", @"ru", @"de", @"fr", @"es", @"uk", nil];
  
  BOOL test = [codes containsObject:language];
  
  if (test) {
    _language = language;
    return;
  }
  
  _language = nil;
}

+ (CardKConfig *)shared {
  if (__instance == nil) {
    __instance = [CardKConfig defaultConfig];
  }

  return __instance;
}

+ (void)fetchKeys:(NSString *)url {
  NSString *URL = [[NSString alloc] initWithString:url];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];

  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      if(httpResponse.statusCode == 200)
      {
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSArray *keys = [responseDictionary objectForKey:@"keys"];
        NSDictionary *lastKey = [keys firstObject];
        NSString *keyValue = [lastKey objectForKey:@"keyValue"];

        __instance.pubKey = keyValue;
      }
  }];
  [dataTask resume];
}

+ (NSString *) timestampForDate:(NSDate *) date {
  return [CKCToken timestampForDate:date];
}

+ (NSString *) getVersion {
  return [[[NSBundle bundleForClass: CardKConfig.self] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
