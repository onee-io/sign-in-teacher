//
//  SignViewController.m
//  数字签到系统
//
//  Created by VOREVER on 2/4/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import "SignViewController.h"
#import "FMDB.h"
#import "User.h"
#import "MBProgressHUD+MJ.h"

@interface SignViewController ()

@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) UIImageView *QRcodeImageView;  // 二维码展示区域
@property (nonatomic, strong) UIButton *CreateQRBtn;   // 生成二维码按钮

@end

@implementation SignViewController

#pragma mark 二维码区域懒加载
- (UIImageView *)QRcodeImageView{
    if (_QRcodeImageView == nil) {
        CGRect ScreenRect = [[UIScreen mainScreen] bounds];
        CGFloat QRW = ScreenRect.size.width * 0.75;
        CGFloat QRH = QRW;
        CGFloat QRX = (ScreenRect.size.width - QRW) / 2;
        CGFloat QRY = QRX;
        _QRcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QRX, QRY, QRW, QRH)];
    }
    return _QRcodeImageView;
}

#pragma mark 按钮懒加载
- (UIButton *)CreateQRBtn{
    if (_CreateQRBtn == nil) {
        CGRect ScreenRect = [[UIScreen mainScreen] bounds];
        CGFloat QRBtnW = ScreenRect.size.width * 0.75;
        CGFloat QRBtnH = 50;
        CGFloat QRBtnX = (ScreenRect.size.width - QRBtnW) / 2;
        CGFloat QRBtnY = self.QRcodeImageView.frame.size.height + self.QRcodeImageView.frame.origin.y + 80;
        _CreateQRBtn = [[UIButton alloc] initWithFrame:CGRectMake(QRBtnX, QRBtnY, QRBtnW, QRBtnH)];
        [_CreateQRBtn setBackgroundColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0]];
        [_CreateQRBtn setTitle:@"点击生成二维码" forState:UIControlStateNormal];
        _CreateQRBtn.layer.cornerRadius = 5.0;
        [_CreateQRBtn addTarget:self action:@selector(createQR:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CreateQRBtn;
}

#pragma mark 检查数据库中是否有登录用户
- (BOOL)checkUser {
    NSString *sql = @"SELECT * FROM 't_user'";
    FMResultSet *result = [self.db executeQuery:sql];
    while ([result next]) {
        return YES;
    }
    return NO;
}

#pragma mark 生成二维码
- (void)createQR:(UIButton *)sender{
    
    if (![self checkUser]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        [self.view addSubview:hud];
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/error.png"]]];
        hud.labelText = @"请您先登陆账户";
        [hud show:YES];
        [hud hide:YES afterDelay:1.0];
        return;
    }
    
    // 课程随机字符串
    NSString *text = [self shuffledAlphabet];
    NSLog(@"Cilck Button ---- %@", text);
    
    
    NSData *stringData = [text dataUsingEncoding: NSUTF8StringEncoding];
    
    // 生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    // 上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage",qrFilter.outputImage,@"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],@"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    // 绘制
    CGSize size = CGSizeMake(self.QRcodeImageView.frame.size.width, self.QRcodeImageView.frame.size.height);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    self.QRcodeImageView.image = codeImage;
}

#pragma mark 生成随机课程代码
- (NSString *)shuffledAlphabet {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform(numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:numberOfCharacters];
    free(characters);
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:1.0]; // 启动页延迟一秒
    // 将状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
    };
    self.navigationItem.title = @"课程二维码";
    [self.view setBackgroundColor:[UIColor colorWithRed:235/255.0 green:239/255.0 blue:241/255.0 alpha:1.0]];
    
    [self.view addSubview:self.QRcodeImageView];
    [self.view addSubview:self.CreateQRBtn];
    
    [self initDataBase];

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    NSLog(@"%s",__func__);
    return UIStatusBarStyleLightContent;
}

- (FMDatabase *)db {
    if (_db == nil) {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"user.sqlite"];
        _db = [FMDatabase databaseWithPath:filePath];
    }
    return _db;
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


@end
