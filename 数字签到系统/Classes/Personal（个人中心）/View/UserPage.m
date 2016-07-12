//
//  UserPage.m
//  数字签到系统
//
//  Created by VOREVER on 2/11/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import "UserPage.h"
#import "User.h"

#define vMargin 20

@interface UserPage ()

@property (nonatomic, strong) UILabel *number;
@property (nonatomic, strong) UILabel *realname;
@property (nonatomic, strong) UILabel *sex;
@property (nonatomic, strong) UILabel *department;
@property (nonatomic, strong) UILabel *major;
@property (nonatomic, strong) UILabel *class_n;

@end

@implementation UserPage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:235/255.0 green:239/255.0 blue:241/255.0 alpha:1.0]];
        [self setUserPage];
    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    self.number.text = [NSString stringWithFormat:@"学号：%@", self.user.number];
    self.realname.text = [NSString stringWithFormat:@"姓名：%@", self.user.realname];
    self.sex.text = [NSString stringWithFormat:@"性别：%@", self.user.sex];
    self.department.text = [NSString stringWithFormat:@"院系：%@", self.user.department];
    self.major.text = [NSString stringWithFormat:@"专业：%@", self.user.major];
    self.class_n.text = [NSString stringWithFormat:@"班级：%@-%@", self.user.grade, self.user.class_n];
}

/**
 * 设置个人中心页面
 */
- (void)setUserPage {

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenW = screenRect.size.width;
    
    CGFloat cellW = screenW - 2 * vMargin;
    CGFloat cellH = 2 * vMargin;
    CGFloat cellX = vMargin;
    CGFloat cellY = vMargin + cellH;
    
    self.number = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY * 0, cellW, cellH)];
    [self addSubview:self.number];
    
    self.realname = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY * 1, cellW, cellH)];
    [self addSubview:self.realname];
    
    self.sex = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY * 2, cellW, cellH)];
    [self addSubview:self.sex];
    
    self.department = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY * 3, cellW, cellH)];
    [self addSubview:self.department];
    
    self.major = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY * 4, cellW, cellH)];
    [self addSubview:self.major];
    
    self.class_n = [[UILabel alloc] initWithFrame:CGRectMake(cellX, cellY * 5, cellW, cellH)];
    [self addSubview:self.class_n];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(cellX, cellY * 6, cellW, cellH)];
    [logoutBtn setBackgroundColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0]];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.layer.cornerRadius = 5.0;
    [logoutBtn addTarget:self action:@selector(clickLogoutBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logoutBtn];
    
}

- (void)clickLogoutBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(userPageClickLogoutBtn:User:)]) {
        [self.delegate userPageClickLogoutBtn:self User:self.user];
    }
}

@end
