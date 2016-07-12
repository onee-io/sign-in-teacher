//
//  PersonalViewController.m
//  数字签到系统
//
//  Created by VOREVER on 2/4/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import "PersonalViewController.h"
#import "AFNetworking.h"
#import "User.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Hash.h"
#import "FMDB.h"
#import "LoginPage.h"
#import "UserPage.h"

#define vMargin 20

@interface PersonalViewController () <LoginPageDelegate, UserPageDelegate>

@property (nonatomic, strong) NSDictionary *userDict;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 将状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
    };
    self.navigationItem.title = @"个人中心";    
    [self initDataBase];
    [self checkUser];
}

- (FMDatabase *)db {
    if (_db == nil) {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"user.sqlite"];
        _db = [FMDatabase databaseWithPath:filePath];
    }
    return _db;
}

#pragma mark 初始化数据库
- (void)initDataBase {

    if ([self.db open]) {
        NSLog(@"数据库打开成功");
        if (![self isTableOK:@"t_user"]) {
            // 创建用户信息表
            NSString *sql = @"CREATE TABLE `t_user` (`realname` varchar(100) NOT NULL,`number` varchar(100) NOT NULL,`password` varchar(100) NOT NULL,`last_time` varchar(100) NOT NULL,`sex` varchar(100) NOT NULL,`department` varchar(100) NOT NULL,`major` varchar(100) NOT NULL,`grade` varchar(100) NOT NULL,`class` varchar(100) NOT NULL,PRIMARY KEY (`number`));";
            if ([self.db executeUpdate:sql]) {
                NSLog(@"创建user表成功");
            } else {
                NSLog(@"创建user表失败");
            }
        }
    } else {
        NSLog(@"数据库打开失败");
    }
}

#pragma mark 检查数据库中是否有登录用户
- (void)checkUser {
    NSString *sql = @"SELECT * FROM 't_user'";
    FMResultSet *result = [self.db executeQuery:sql];
    NSMutableArray *userGroup = [NSMutableArray array];
    while ([result next]) {
        User *user = [[User alloc] init];
        user.realname = [result stringForColumn:@"realname"];
        user.number = [result stringForColumn:@"number"];
        user.password = [result stringForColumn:@"password"];
        user.last_time = [result stringForColumn:@"last_time"];
        user.sex = [result stringForColumn:@"sex"];
        user.department = [result stringForColumn:@"department"];
        user.major = [result stringForColumn:@"major"];
        user.grade = [result stringForColumn:@"grade"];
        user.class_n = [result stringForColumn:@"class"];
        [userGroup addObject:user];
    }
    if (userGroup.count != 0) {
        NSLog(@"数据库中有数据 ＝＝＝＝＝＝ %lu", (unsigned long)userGroup.count);
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        User *user = userGroup[0];
        UserPage *userPage = [[UserPage alloc] initWithFrame:[UIScreen mainScreen].bounds];
        userPage.delegate = self;
        userPage.user = user;
        [self.view addSubview:userPage];
        [self hudForSuccess];
    } else {
        NSLog(@"数据库中没有数据");
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        LoginPage *loginPage = [[LoginPage alloc] initWithFrame:[UIScreen mainScreen].bounds];
        loginPage.delegate = self;
        [self.view addSubview:loginPage];
    }
}


#pragma mark 判断sqlite数据库中是否存在一张表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [self.db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

#pragma mark 判断某张表中是否存在某一条数据
- (BOOL)isExistDataForColumn:(NSString *)column Value:(NSString *)value TableName:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE %@ = '%@'", tableName, column, value];
    FMResultSet *result = [self.db executeQuery:sql];
    while ([result next]) {
        return YES;
    }
    return NO;
}

#pragma mark 登录按钮代理方法
- (void)loginPageClickBtn:(LoginPage *)loginPage Number:(NSString *)number Password:(NSString *)password {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"正在拼命登录中。。。";
    [hud show:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"number"] = number;//[NSString stringWithFormat:@"\'%@\'",number];
    params[@"password"] = [password md5String];
    params[@"format"] = @"json";
    
    NSString *url = @"http://tokusa.cn/login.php";
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 10.0; // timeout: 10seconed
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _userDict = responseObject;
        NSLog(@"%@",responseObject);
        [hud hide:YES];
        if ([@"200" isEqualToString:self.userDict[@"code"]]) {
//            NSLog(@"登录成功");
            [self initUser];
            [self checkUser];
        } else {
            if ([@"402" isEqualToString:self.userDict[@"code"]]) {
                NSLog(@"密码错误");
                [self hudForErrorMessage:@"密码错误!"];
            } else if ([@"403" isEqualToString:self.userDict[@"code"]]) {
                NSLog(@"无此用户");
                [self hudForErrorMessage:@"无此用户!"];
            } else if ([@"405" isEqualToString:self.userDict[@"code"]]) {
                NSLog(@"数据库连接失败");
                [self hudForErrorMessage:@"数据库连接失败!"];
            }
//            [self hudForErrorMessage:@"登录失败!"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        NSLog(@"error %@", error);
        [self hudForErrorMessage:@"请求失败，请重试！"];
    }];
}

#pragma mark 向sqlite存储用户信息
- (void)initUser {
    self.user = [User userWithDict:self.userDict];
    if (![self isExistDataForColumn:@"number" Value:self.user.number TableName:@"t_user"]) {
        NSLog(@"不存在数据");
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO `t_user` VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",self.user.realname, self.user.number, self.user.password, self.user.last_time, self.user.sex, self.user.department, self.user.major, self.user.grade, self.user.class_n];
        
        if ([self.db executeUpdate:sql]) {
            NSLog(@"插入数据成功");
        } else {
            NSLog(@"插入数据失败");
        }
    } else {
        NSLog(@"已存在数据");
    }
    NSLog(@"%@", self.user);
}

#pragma mark 退出登录代理方法
- (void)userPageClickLogoutBtn:(UserPage *)userPage User:(User *)user{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM 't_user' WHERE number = %@;", user.number];
    if ([self.db executeUpdate:sql]) {
        NSLog(@"退出成功！");
        [self checkUser];
    } else {
        NSLog(@"退出失败！");
    }
}


#pragma mark 显示登陆成功信息
- (void)hudForSuccess {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/success.png"]]];
    hud.labelText = @"登录成功！";
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
}

#pragma mark 显示登陆失败信息
- (void)hudForErrorMessage:(NSString *)message {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/error.png"]]];
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
}


@end
