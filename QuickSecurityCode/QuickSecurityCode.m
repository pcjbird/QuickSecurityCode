//
//  QuickSecurityCode.m
//  QuickSecurityCode
//
//  Created by pcjbird on 2018/3/31.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickSecurityCode.h"
#import "UITextField+QuickSecurityCode.h"

@interface QuickSecurityCodeUnderline : UIView

@property (nonatomic, weak) UIView *underline;

-(void) performAnimation;

@end

@implementation QuickSecurityCodeUnderline

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUnderline];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self setupUnderline];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupUnderline
{
    UIView *underline = [UIView new];
    [self addSubview:underline];
    self.underline = underline;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.underline.frame = self.bounds;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    self.underline.backgroundColor = backgroundColor;
}

-(void) performAnimation
{
    [self.underline.layer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.duration = 0.18;
    animation.repeatCount = 1;
    animation.fromValue = @(1.0);
    animation.toValue = @(0.1);
    animation.autoreverses = YES;
    
    [self.underline.layer addAnimation:animation forKey:@"zoom.scale.x"];
}

@end


@interface QuickSecurityCode()<QuickSecurityCodeTextFieldDelegate>

@property(nonatomic, strong) NSString * code;

@property(nonatomic, assign) NSInteger digitsCount;

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary<id, UILabel*> *labels;
@property (nonatomic, strong) NSMutableDictionary<id, QuickSecurityCodeUnderline*> *underlines;
@end

@implementation QuickSecurityCode

-(NSString *)code
{
    NSString* result = @"";
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        for (NSInteger i = 0; i < self.digitsCount; i++)
        {
            UILabel *label = [self.labels objectForKey:@(i)];
            result = [result stringByAppendingString:label.text];
        }
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
    _showUnderlineInsteadOfBorder = NO;
    _showAnimationWhenUnderlineMode = YES;
    _focusBorderColor = [UIColor colorWithRed:(0x05/255.0f) green:(0x7A/255.0f) blue:(0xDC/255.0f) alpha:1.0f];
    _disabledBorderColor = [UIColor colorWithRed:(0xCC/255.0f) green:(0xCC/255.0f) blue:(0xCC/255.0f) alpha:1.0f];
    _digitColor = [UIColor colorWithRed:(0x00/255.0f) green:(0x00/255.0f) blue:(0x00/255.0f) alpha:1.0f];
    _digitFont = [UIFont systemFontOfSize:17.0f];
    _labels = [NSMutableDictionary<id, UILabel*> dictionary];
    _underlines = [NSMutableDictionary<id, QuickSecurityCodeUnderline*> dictionary];
}

-(void) setupInit
{
    NSArray *subviews = [self subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    [self.labels removeAllObjects];
    [self.underlines removeAllObjects];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin+(itemWidth+spacing)*i, (CGRectGetHeight(self.frame) - itemHeight)/2.0f, itemWidth, itemHeight)];
        label.tag = 100+i;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.digitColor;
        label.font = self.digitFont;
        if(!self.showUnderlineInsteadOfBorder)
        {
            [self setView:label cornerWithRadius:8.0f borderWidth:1.0f borderColor:self.disabledBorderColor];
        }
        [self addSubview:label];
        [self.labels setObject:label forKey:@(i)];
        
        if(self.showUnderlineInsteadOfBorder)
        {
            QuickSecurityCodeUnderline *underline = [[QuickSecurityCodeUnderline alloc] initWithFrame:CGRectMake(margin+(itemWidth+spacing)*i, ((CGRectGetHeight(self.frame) + itemHeight)/2.0f) - 1.0f, itemWidth, 1.0f)];
            underline.backgroundColor = self.disabledBorderColor;
            [self addSubview:underline];
            [self.underlines setObject:underline forKey:@(i)];
        }
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, (CGRectGetHeight(self.frame) - itemHeight)/2.0f, itemWidth, itemHeight)];
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    if(!self.showUnderlineInsteadOfBorder)[self setView:textField cornerWithRadius:8.0f borderWidth:1.0f borderColor:self.focusBorderColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField setTintColor:self.tintColor];
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

- (void)performLabelAnimation:(UILabel *)label
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.repeatCount = 1;
    animation.fromValue = @(0.1);
    animation.toValue = @(1);
    [label.layer addAnimation:animation forKey:@"zoom"];
}

-(void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if([self.textField isKindOfClass:[UITextField class]])
    {
        [self.textField setTintColor:self.tintColor];
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

-(void)setShowUnderlineInsteadOfBorder:(BOOL)showUnderlineInsteadOfBorder
{
    _showUnderlineInsteadOfBorder = showUnderlineInsteadOfBorder;
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
        
        if(label.text.length == 0)
        {
            label.text = string;
            if(!self.showUnderlineInsteadOfBorder)
            {
                [self setView:label cornerWithRadius:8.0f borderWidth:1.0f borderColor:self.focusBorderColor];
            }
            else
            {
                QuickSecurityCodeUnderline *underline = [self.underlines objectForKey:@(i)];
                [underline setBackgroundColor:self.focusBorderColor];
                if(self.showAnimationWhenUnderlineMode)
                {
                    [underline performAnimation];
                    [self performLabelAnimation:label];
                }
            }
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
        if(label.text.length != 0)
        {
            label.text = @"";
            if(!self.showUnderlineInsteadOfBorder)
            {
                [self setView:label cornerWithRadius:8.0f borderWidth:1.0f borderColor:self.disabledBorderColor];
            }
            else if(i < self.digitsCount - 1)
            {
                QuickSecurityCodeUnderline *underline = [self.underlines objectForKey:@(i+1)];
                [underline setBackgroundColor:self.disabledBorderColor];
                if(self.showAnimationWhenUnderlineMode)
                {
                    [underline performAnimation];
                    [self performLabelAnimation:label];
                }
            }
            [self setView:_textField leftX:CGRectGetMinX([self.labels objectForKey:@(i)].frame)];
            _textField.tintColor = self.tintColor;
            return;
        }
    }
}

- (void)textFieldBecomeFirstResponder:(UITextField *)textField
{
    if(textField == self.textField)
    {
        CGFloat textFieldLeftX = CGRectGetMinX(self.textField.frame);
        if([self.labels isKindOfClass:[NSDictionary class]])
        {
            __weak typeof(self) weakSelf = self;
            [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
                CGFloat left = CGRectGetMinX(obj.frame);
                if(left == textFieldLeftX)
                {
                    weakSelf.textField.tintColor = (obj.text.length > 0) ? [UIColor clearColor] : weakSelf.tintColor;
                    *stop = YES;
                }
            }];
        }
    }
}

- (void)resetDefaultStatus {
    
    if([self.labels isKindOfClass:[NSDictionary class]])
    {
        __weak typeof(self) weakSelf = self;
        [self.labels enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UILabel * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.text = @"";
            if(!weakSelf.showUnderlineInsteadOfBorder)
            {
                [weakSelf setView:obj cornerWithRadius:8.0f borderWidth:1.0f borderColor:weakSelf.disabledBorderColor];
            }
            if([@"0" isEqualToString:key])
            {
                [weakSelf setView:weakSelf.textField leftX:CGRectGetMinX(obj.frame)];
                if(!weakSelf.showUnderlineInsteadOfBorder)
                {
                    [weakSelf setView:weakSelf.textField cornerWithRadius:8.0f borderWidth:1.0f borderColor:weakSelf.focusBorderColor];
                }
                [weakSelf.textField becomeFirstResponder];
            }
        }];
    }
    if(self.showUnderlineInsteadOfBorder && [self.underlines isKindOfClass:[NSDictionary class]])
    {
        __weak typeof(self) weakSelf = self;
        [self.underlines enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, QuickSecurityCodeUnderline * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj setBackgroundColor:weakSelf.disabledBorderColor];
        }];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
}


@end
