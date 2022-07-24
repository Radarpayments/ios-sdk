//
//  CardKCVCTextField.h
//  CardKit
//
//  Created by Alex Korotkov on 22.07.2022.
//  Copyright © 2022 AnjLab. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CardKCVCTextField: UIControl

@property (strong) NSString *secureCode;
@property (strong) NSArray *errorMessages;
-(void)validate;

@end

NS_ASSUME_NONNULL_END
