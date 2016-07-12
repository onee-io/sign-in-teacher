//
//  StatisticsViewController.m
//  数字签到系统
//
//  Created by VOREVER on 2/4/16.
//  Copyright © 2016 VOREVER. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController () <UITableViewDataSource>


@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 将状态栏设置为白色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
    };
    self.navigationItem.title = @"考勤统计";
    [self.view setBackgroundColor:[UIColor colorWithRed:235/255.0 green:239/255.0 blue:241/255.0 alpha:1.0]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"XiongSiYao";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"学生 %ld", (long)indexPath.row + 1];
    if (indexPath.row < 9) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"12020420%ld", (long)indexPath.row + 1];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"1202042%ld", (long)indexPath.row + 1];
    }
    return cell;
}


@end
