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
- (void)log:(NSString *)message {
    NSLog(@"message - %@", message);
}
@end
