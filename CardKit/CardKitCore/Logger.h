//
//  Logger.h
//  CardKit
//
//  Created by Alex Korotkov on 15.11.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LogInterface.h"

@interface Logger: NSObject
+ (void) addLogInterface:(LogInterface *) logInterface;
+ (void) logWithClass:(Class *) classMethod tag:(NSString *) tag  exception:(NSException *) exception;
+ (void) log:(NSString *) message;
@property (class, readonly, strong, nonatomic) Logger *shared;
@property NSMutableArray<LogInterface *> *logInterfaces;
@end
//(void(^)(NSString *message)) logHandler in Logger.shared.logHandlers
