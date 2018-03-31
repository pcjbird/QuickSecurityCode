//
//  UITextField+QuickSecurityCode.m
//  QuickSecurityCode
//
//  Created by pcjbird on 2018/3/31.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "UITextField+QuickSecurityCode.h"
#import <objc/runtime.h>

@implementation UITextField (QuickSecurityCode)

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(yx_deleteBackward));
    method_exchangeImplementations(method1, method2);
    
    method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"becomeFirstResponder"));
    method2 = class_getInstanceMethod([self class], @selector(yx_becomeFirstResponder));
    method_exchangeImplementations(method1, method2);
}

- (void)yx_deleteBackward {
    [self yx_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <QuickSecurityCodeTextFieldDelegate> delegate  = (id<QuickSecurityCodeTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
}

-(BOOL)yx_becomeFirstResponder
{
    if ([self.delegate respondsToSelector:@selector(textFieldBecomeFirstResponder:)])
    {
        id <QuickSecurityCodeTextFieldDelegate> delegate  = (id<QuickSecurityCodeTextFieldDelegate>)self.delegate;
        [delegate textFieldBecomeFirstResponder:self];
    }
    return  [self yx_becomeFirstResponder];
}

@end
