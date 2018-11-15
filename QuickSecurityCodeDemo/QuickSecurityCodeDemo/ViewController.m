//
//  ViewController.m
//  QuickSecurityCodeDemo
//
//  Created by pcjbird on 2018/4/1.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "ViewController.h"
#import <QuickSecurityCode/QuickSecurityCode.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet QuickSecurityCode *securityCodeCtrl1;
@property (weak, nonatomic) IBOutlet QuickSecurityCode *securityCodeCtrl2;
@property (weak, nonatomic) IBOutlet QuickSecurityCode *securityCodeCtrl3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.securityCodeCtrl1.digitFont = [UIFont boldSystemFontOfSize:18.0f];
    self.securityCodeCtrl1.complete = ^(NSString *code) {
        NSLog(@"SecurityCodeCtrl1: %@", code);
    };
    
    self.securityCodeCtrl2.complete = ^(NSString *code) {
        NSLog(@"SecurityCodeCtrl2: %@", code);
    };
    
    self.securityCodeCtrl3.digitFont = [UIFont boldSystemFontOfSize:18.0f];
    self.securityCodeCtrl3.complete = ^(NSString *code) {
        NSLog(@"SecurityCodeCtrl3: %@", code);
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
