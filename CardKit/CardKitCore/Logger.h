//
//  Logger.h
//  CardKit
//
//  Created by Alex Korotkov on 15.11.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LogInterface.h"
NS_ASSUME_NONNULL_BEGIN
@interface Logger: NSObject
+ (void) addLogInterface:(LogInterface *) logInterface;
+ (void) logWithClass:(Class) class tag:(NSString *) tag message:(NSString *) message  exception:(NSError * _Nullable) exception;
@property (class, readonly, strong, nonatomic) Logger * shared;
@property NSString * TAG;
@property NSMutableArray<LogInterface *> * logInterfaces;
@end
NS_ASSUME_NONNULL_END
