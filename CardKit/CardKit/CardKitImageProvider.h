//
//  CardKUIImage.h
//  CardKit
//
//  Created by Alex Korotkov on 31.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CardKitImageProvider: NSObject

+ (UIImage *)namedImage:(NSString *)imageName inBundle:(NSBundle *) bundle compatibleWithTraitCollection:(UITraitCollection *) traitCollection;

@end

NS_ASSUME_NONNULL_END
