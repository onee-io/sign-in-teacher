//
//  User.m
//  数字签到系统
//
//  Created by VOREVER on 2/9/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _realname = dict[@"data"][@"realname"];
        _number = dict[@"data"][@"number"];
        _password = dict[@"data"][@"password"];
        _last_time = dict[@"data"][@"last_time"];
        _sex = dict[@"data"][@"sex"];
        _department = dict[@"data"][@"department"];
        _major = dict[@"data"][@"major"];
        _grade = dict[@"data"][@"grade"];
        _class_n = dict[@"data"][@"class"];
    }
    return self;
}

+ (instancetype)userWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"realname = %@, number = %@, last_time = %@, sex = %@, department = %@, major = %@, grade = %@, class = %@", self.realname, self.number, self.last_time, self.sex, self.department, self.major, self.grade, self.class_n];
}

@end
