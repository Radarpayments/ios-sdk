//
//  UITextField+TextField.m
//  CardKit
//
//  Created by Alex Korotkov on 11/9/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "TextField.h"
#import "CardKConfig.h"

@implementation TextField

- (void)drawTextInRect:(CGRect)rect
{
    if (self.isSecureTextEntry)
    {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = self.textAlignment;

        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Menlo-bold" size:self.font.pointSize], NSForegroundColorAttributeName: CardKConfig.shared.theme.colorLabel};

        
        CGSize textSize = [self.text sizeWithAttributes:attributes];

        rect = CGRectInset(rect, 0, (CGRectGetHeight(rect) - textSize.height) * 0.5);
        rect.origin.y = floorf(rect.origin.y);
        
        NSMutableString *redactedText = [NSMutableString new];
        while (redactedText.length < self.text.length)
        {
            [redactedText appendString:@"\u2022"];
        }
        
        [redactedText drawInRect:rect withAttributes:attributes];
    }
    else
    {
        [super drawTextInRect:rect];
    }
}

@end
