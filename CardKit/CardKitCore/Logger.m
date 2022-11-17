//
//  Logger.m
//  CardKitCore
//
//  Created by Alex Korotkov on 15.11.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logger.h"
#import "LogInterface.h"
#include<syslog.h>

static Logger *__instance = nil;

@implementation Logger

- (instancetype)init {
    self.logInterfaces = [[NSMutableArray alloc] init];
    
    return self;
}
+ (Logger *)shared {
  if (__instance == nil) {
      __instance = [[Logger alloc] init];
  }

  return __instance;
}

+ (void) addLogInterface:(LogInterface *) logInterface {
    Logger *logger = [Logger shared];
    [logger.logInterfaces addObject:logInterface];
}

+ (void) logWithClass:(Class) class tag:(NSString *) tag message:(NSString *) message  exception:(NSException * _Nullable) exception {
    for (LogInterface *logInterface in Logger.shared.logInterfaces) {
        [logInterface logWithClass:class tag:tag message:message exception:exception];
    }
}

@end
