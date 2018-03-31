//
//  QuickSecurityCode.m
//  QuickSecurityCode
//
//  Created by pcjbird on 2018/3/31.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickSecurityCode.h"
#import "UITextField+QuickSecurityCode.h"

@interface QuickSecurityCode()<QuickSecurityCodeTextFieldDelegate>

@property(nonatomic, strong) NSString * code;

@property(nonatomic, assign) NSInteger digitsCount;

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary<id, UILabel*> *labels;

@end

@implementation QuickSecurityCode

-(NSString *)code
{
    __block NSString* result = @"";
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
            result = [result stringByAppendingString:obj.text];
        }];
    }
    return result;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initVariables];
        [self setupInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self initVariables];
        [self setupInit];
    }
    return self;
}

-(void) initVariables
{
    _digitsCount = 4;
    _preferredSixDigits = NO;
    _focusBorderColor = [UIColor colorWithRed:(0x05/255.0f) green:(0x7A/255.0f) blue:(0xDC/255.0f) alpha:1.0f];
    _disabledBorderColor = [UIColor colorWithRed:(0xCC/255.0f) green:(0xCC/255.0f) blue:(0xCC/255.0f) alpha:1.0f];
    _digitColor = [UIColor colorWithRed:(0x00/255.0f) green:(0x00/255.0f) blue:(0x00/255.0f) alpha:1.0f];
    _digitFont = [UIFont systemFontOfSize:17.0f];
    _labels = [NSMutableDictionary<id, UILabel*> dictionary];
}

-(void) setupInit
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    [self.labels removeAllObjects];
    CGFloat itemWidth = 50.0f;
    CGFloat itemHeight = 50.0f;
    CGFloat spacing = 18.0f;
    if(self.digitsCount == 6)
    {
        itemWidth = itemHeight = 38.0f;
        spacing = 10.0f;
    }
    CGFloat margin = (CGRectGetWidth(self.frame) - itemWidth*self.digitsCount - spacing*(self.digitsCount-1))/2.0f;
    
    for (NSInteger i = 0; i < self.digitsCount; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin+(itemWidth+spacing)*i, 0, itemWidth, itemHeight)];
        label.tag = 100+i;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.digitColor;
        label.font = self.digitFont;
        [self setView:label cornerWithRadius:5.0f borderWidth:1.0f borderColor:self.disabledBorderColor];
        [self addSubview:label];
        [self.labels setObject:label forKey:@(i)];
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, itemWidth, itemHeight)];
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    [self setView:textField cornerWithRadius:5.0f borderWidth:1.0f borderColor:self.focusBorderColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField setTintColor:[UIColor clearColor]];
    [self addSubview:textField];
    _textField = textField;
    
    [textField becomeFirstResponder];
    [self setNeedsDisplay];
}

- (void)setView:(UIView*)view cornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    if(![view isKindOfClass:[UIView class]]) return;
    view.layer.cornerRadius = radius;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
    view.layer.masksToBounds = YES;
}

- (void)setView:(UIView*)view leftX:(CGFloat)left
{
    if(![view isKindOfClass:[UIView class]]) return;
    view.frame = CGRectMake(left, CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if([self.textField isKindOfClass:[UITextField class]])
    {
        [self.textField setTintColor:[UIColor clearColor]];
    }
}

-(BOOL)becomeFirstResponder
{
    if([self.textField isKindOfClass:[UITextField class]])
    {
        return [self.textField becomeFirstResponder];
    }
    return NO;
}

-(void)setFocusBorderColor:(UIColor *)focusBorderColor
{
    _focusBorderColor = focusBorderColor;
    [self setupInit];
}

-(void)setDisabledBorderColor:(UIColor *)disabledBorderColor
{
    _disabledBorderColor = disabledBorderColor;
    [self setupInit];
}

-(void)setDigitFont:(UIFont *)digitFont
{
    _digitFont = digitFont;
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.font = digitFont;
        }];
    }
}

-(void)setDigitColor:(UIColor *)digitColor
{
    _digitColor = digitColor;
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.textColor = digitColor;
        }];
    }
}

-(void)setPreferredSixDigits:(BOOL)preferredSixDigits
{
    _preferredSixDigits = preferredSixDigits;
    _digitsCount = _preferredSixDigits ? 6 : 4;
    [self setupInit];
}
         
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    for (NSInteger i = 0; i < self.digitsCount; i++)
    {
        UILabel *label = [self.labels objectForKey:@(i)];
        if(label.text == 0)
        {
            label.text = string;
            [self setView:label cornerWithRadius:5.0f borderWidth:1.0f borderColor:self.focusBorderColor];
            if(i < self.digitsCount - 1)
            {
                [self setView:_textField leftX:CGRectGetMinX([self.labels objectForKey:@(i+1)].frame)];
            }
            else
            {
                [_textField resignFirstResponder];
                if(self.complete)
                {
                    self.complete(self.code);
                }
            }
            break;
        }
    }
    return NO;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    for (NSInteger i = self.digitsCount - 1; i >= 0; i--)
    {
        UILabel *label = [self.labels objectForKey:@(i)];
        if(label.text != 0)
        {
            label.text = @"";
            [self setView:label cornerWithRadius:5.0f borderWidth:1.0f borderColor:self.disabledBorderColor];
            if(i > 0)
            {
                [self setView:_textField leftX:CGRectGetMinX([self.labels objectForKey:@(i-1)].frame)];
            }
            return;
        }
    }
}

- (void)resetDefaultStatus {
    
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        __weak typeof(self) weakSelf = self;
        [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.text = @"";
            [weakSelf setView:obj cornerWithRadius:5.0f borderWidth:1.0f borderColor:weakSelf.disabledBorderColor];
            if([@"0" isEqualToString:key])
            {
                [weakSelf setView:weakSelf.textField leftX:CGRectGetMinX(obj.frame)];
                [weakSelf setView:weakSelf.textField cornerWithRadius:5.0f borderWidth:1.0f borderColor:weakSelf.focusBorderColor];
                [weakSelf.textField becomeFirstResponder];
            }
        }];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj drawLayer:obj.layer inContext:ctx];
        }];
    }
    if([self.textField isKindOfClass:[UITextField class]])
    {
        [self.textField drawLayer:self.textField.layer inContext:ctx];
    }
}


@end
