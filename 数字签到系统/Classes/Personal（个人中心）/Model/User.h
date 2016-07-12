//
//  User.h
//  数字签到系统
//
//  Created by VOREVER on 2/9/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *realname;   // 姓名
@property (nonatomic, copy) NSString *number;     // 学号
@property (nonatomic, copy) NSString *password;   // 密码
@property (nonatomic, copy) NSString *last_time;  // 最后登录时间
@property (nonatomic, copy) NSString *sex;        // 性别
@property (nonatomic, copy) NSString *department; // 院系
@property (nonatomic, copy) NSString *major;      // 专业
@property (nonatomic, copy) NSString *grade;      // 年级
@property (nonatomic, copy) NSString *class_n;    // 班级

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userWithDict:(NSDictionary *)dict;

@end
