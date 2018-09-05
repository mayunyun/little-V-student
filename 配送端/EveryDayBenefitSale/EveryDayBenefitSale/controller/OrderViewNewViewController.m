//
//  OrderViewNewViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 17/2/4.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderViewNewViewController.h"
#import "InfoCell.h"

@interface OrderViewNewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView* tableBgScroll;

@end

@implementation OrderViewNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实现Table
    CGRect scrollRect = CGRectMake(0, 0, 320, 460);
    self.tableBgScroll = [[UITableView alloc] initWithFrame:scrollRect style:UITableViewStylePlain];
    self.tableBgScroll.rowHeight = 460;
    [self.tableBgScroll setDelegate:self];
    [self.tableBgScroll setDataSource:self];
    [self.view addSubview:self.tableBgScroll];
    
}



//Table的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellname = @"cell";
    NSLog(@"------%ld",(long)indexPath.row);
    InfoCell *cell = (InfoCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil)
    {
        cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
        cell.backgroundColor = [UIColor redColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld",(long)indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
