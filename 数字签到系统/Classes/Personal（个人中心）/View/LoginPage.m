//
//  LoginPage.m
//  数字签到系统
//
//  Created by VOREVER on 2/10/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import "LoginPage.h"

#define vMargin 20

@interface LoginPage ()

@property (nonatomic, strong) UITextField *number;
@property (nonatomic, strong) UITextField *password;

@end


@implementation LoginPage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%s",__func__);
        [self setBackgroundColor:[UIColor colorWithRed:235/255.0 green:239/255.0 blue:241/255.0 alpha:1.0]];
        [self setLoginPage];
    }
    return self;
}

/*
 * 设置登陆页面
 */
- (void)setLoginPage {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenW = screenRect.size.width;
    
    // 用户名输入框
    CGFloat numberX = vMargin;
    CGFloat numberY = vMargin;
    CGFloat numberW = screenW - 2 * vMargin;
    CGFloat numberH = 2 * vMargin;
    self.number = [[UITextField alloc] initWithFrame:CGRectMake(numberX, numberY, numberW, numberH)];
    self.number.placeholder = @"请输入学号";
    [self.number setBorderStyle:UITextBorderStyleRoundedRect];
    self.number.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.number];
    
    // 密码输入框
    CGFloat passwordX = vMargin;
    CGFloat passwordY = numberY + numberH + vMargin;
    CGFloat passwordW = screenW - 2 * vMargin;
    CGFloat passwordH = 2 * vMargin;
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(passwordX, passwordY, passwordW, passwordH)];
    self.password.placeholder = @"请输入密码";
    self.password.secureTextEntry = YES;
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.password];
    
    // 登录按钮
    CGFloat loginBtnX = vMargin;
    CGFloat loginBtnY = passwordY + passwordH + vMargin;
    CGFloat loginBtnW = screenW - 2 * vMargin;
    CGFloat loginBtnH = 2 * vMargin;
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(loginBtnX, loginBtnY, loginBtnW, loginBtnH)];
    [loginBtn setBackgroundColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    // 设置按钮圆角
    loginBtn.layer.cornerRadius = 5.0;
    [loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    
}

/*
 * 登录按钮的监听事件
 */
- (void)clickLoginBtn:(UIButton *)sender {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(loginPageClickBtn:Number:Password:)]) {
        [self.delegate loginPageClickBtn:self Number:self.number.text Password:self.password.text];
    }
}

/**
 * 收起键盘
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
