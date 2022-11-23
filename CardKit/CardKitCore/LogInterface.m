//
//  LogInterface.m
//  CardKitCore
//
//  Created by Alex Korotkov on 17.11.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInterface.h"
@implementation LogInterface
- (void) logWithClass:(Class) class tag:(NSString *) tag message:(NSString *) message  exception:(NSError * _Nullable) exception; {
    NSLog(@"message - %@", message);
}
@end
