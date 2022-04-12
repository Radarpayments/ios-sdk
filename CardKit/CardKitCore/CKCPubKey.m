//
//  NSObject+CKCPubKey.m
//  Core
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CKCPubKey.h"

@implementation CKCPubKey: NSObject
+ (NSString *) fromJSONString:(NSString *) json {
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];

    NSError *parseError = nil;

    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&parseError];

    NSArray *keys = [responseDictionary objectForKey:@"keys"];

    NSDictionary *lastKey = [keys lastObject];

    NSString *keyValue = [lastKey objectForKey:@"keyValue"];

    return keyValue;
}
@end
