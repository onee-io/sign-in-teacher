//
//  UserPage.h
//  数字签到系统
//
//  Created by VOREVER on 2/11/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class UserPage;

@protocol UserPageDelegate <NSObject>

@optional
- (void)userPageClickLogoutBtn:(UserPage *)userPage User:(User *)user;

@end

@interface UserPage : UIView

@property (nonatomic, strong) User *user;
@property (nonatomic, weak) id<UserPageDelegate> delegate;



@end
