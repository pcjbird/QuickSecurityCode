//
//  UITextField+QuickSecurityCode.h
//  QuickSecurityCode
//
//  Created by pcjbird on 2018/3/31.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuickSecurityCodeTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
- (void)textFieldBecomeFirstResponder:(UITextField *)textField;
@end

@interface UITextField (QuickSecurityCode)

@property (weak, nonatomic) id <QuickSecurityCodeTextFieldDelegate> delegate;

@end
