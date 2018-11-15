//
//  QuickSecurityCode.h
//  QuickSecurityCode
//
//  Created by pcjbird on 2018/3/31.
//  Copyright © 2018年 Zero Status. All rights reserved.
//
//  框架名称:QuickSecurityCode
//  框架功能:A security/verify code input control. 一个安全码/验证码输入控件，支持4位或6位的安全码/验证码。
//  修改记录:
//     pcjbird    2018-11-05  Version:1.0.3 Build:201811150002
//                            1.更新演示Demo
//                            2.修复显示位置的问题
//
//     pcjbird    2018-11-05  Version:1.0.2 Build:201811150001
//                            1.支持用下划线替代边框
//                            2.支持下划线模式下是否展示动画
//
//     pcjbird    2018-04-01  Version:1.0.1 Build:201804010002
//                            1.设置光标只在无数字文本时显示
//                            2.设置控件垂直居中
//                            3.修复返回code不正确的问题
//
//     pcjbird    2018-04-01  Version:1.0.0 Build:201804010001
//                            1.首次发布SDK版本
//

#import <UIKit/UIKit.h>

//! Project version number for QuickSecurityCode.
FOUNDATION_EXPORT double QuickSecurityCodeVersionNumber;

//! Project version string for QuickSecurityCode.
FOUNDATION_EXPORT const unsigned char QuickSecurityCodeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QuickSecurityCode/PublicHeader.h>

/**
 *@brief 输入完成回调Block
 */
typedef void(^QuickSecurityCodeBlock)(NSString *code);

/**
 *@brief A security/verify code input control. 一个安全码/验证码输入控件，支持4位或6位的安全码/验证码。
 */
@interface QuickSecurityCode : UIView

/**
 *@brief 安全码/验证码
 */
@property(nonatomic, strong, readonly) NSString * code;

/**
 *@brief 是否6位数字的安全码/验证码。 默认NO, 即4位数字的安全码/验证码。
 */
@property(nonatomic, assign) IBInspectable BOOL preferredSixDigits;

/**
 *@brief 焦点状态边框颜色 默认#057ADC
 */
@property(nonatomic, strong) IBInspectable UIColor* focusBorderColor;

/**
 *@brief 不可用状态边框颜色 默认#CCCCCC
 */
@property(nonatomic, strong) IBInspectable UIColor* disabledBorderColor;

/**
 *@brief 是否用下划线替代边框，默认FALSE
 */
@property(nonatomic, assign) IBInspectable BOOL     showUnderlineInsteadOfBorder;

/**
 *@brief 下划线模式下是否展示动画，默认YES
 */
@property(nonatomic, assign) IBInspectable BOOL     showAnimationWhenUnderlineMode;

/**
 *@brief 数字颜色 默认#000000
 */
@property(nonatomic, strong) IBInspectable UIColor* digitColor;

/**
 *@brief 数字字体 默认系统字体17号
 */
@property(nonatomic, strong) UIFont* digitFont;

/**
 *@brief 输入完成回调Block
 */
@property(nonatomic, copy) QuickSecurityCodeBlock complete;

@end
