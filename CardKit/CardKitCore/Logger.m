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
    NSLog(@"added log interface");
    Logger *logger = [Logger shared];
    [logger.logInterfaces addObject:logInterface];
}

+ (void) logWithClass:(Class *) classMethod tag:(NSString *) tag  exception:(NSException *) exception {
    
//    syslog(LOG_NOTICE, "Some string %s", "sdadsa");
}

+ (void) log:(NSString *) message {
    
    NSLog(@"log", Logger.shared.logInterfaces);
    [Logger.shared.logInterfaces.firstObject log:message];
//    syslog(LOG_NOTICE, "Some string %s", "sdadsa");
}

@end
