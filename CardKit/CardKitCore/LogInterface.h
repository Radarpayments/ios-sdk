//
//  LogInterface.h
//  CardKit
//
//  Created by Alex Korotkov on 17.11.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LogInterface: NSObject
- (void) logWithClass:(Class) class tag:(NSString *) tag message:(NSString *) message  exception:(NSException * _Nullable) exception;
@end
