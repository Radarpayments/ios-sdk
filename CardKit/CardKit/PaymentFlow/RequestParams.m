//
//  NSObject+RequestParams.m
//  CardKit
//
//  Created by Alex Korotkov on 4/8/21.
//  Copyright © 2021 AnjLab. All rights reserved.
//

#import "RequestParams.h"

static RequestParams *__instanceRequestParams = nil;

@implementation RequestParams: NSObject

+ (RequestParams *)shared {
  if (__instanceRequestParams == nil) {
      __instanceRequestParams = [[RequestParams alloc] init];
  }

  return __instanceRequestParams;
}

@end
