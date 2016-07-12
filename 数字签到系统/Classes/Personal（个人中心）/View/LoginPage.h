//
//  LoginPage.h
//  数字签到系统
//
//  Created by VOREVER on 2/10/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginPage;

@protocol LoginPageDelegate <NSObject>

@optional
- (void)loginPageClickBtn:(LoginPage *)loginPage Number:(NSString *)number Password:(NSString *)password;

@end

@interface LoginPage : UIView

@property (nonatomic, weak) id<LoginPageDelegate> delegate;

@end
