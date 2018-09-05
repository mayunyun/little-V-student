//
//  MoneyWaterViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/26.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MoneyWaterViewController.h"
#import "MoneyWorterTableViewCell.h"
#import "MoneyWaterModel.h"
#import "MBProgressHUD.h"

@interface MoneyWaterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    NSInteger _page;
    MBProgressHUD* _HUD;
}

@property (nonatomic,strong)NSMutableArray* dataArray;
@end

@implementation MoneyWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"佣金流水";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    
    [self creatUI];
    //进度HUD
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _HUD.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_HUD show:YES];
    [self dataRequest];

}

- (void)backClick:(UIButton* )sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, mScreenWidth - 20, mScreenHeight - 64)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.rowHeight = 140;
    [self.view addSubview:_tbView];
    
    //下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        if (!IsEmptyValue(_dataArray)) {
            [_dataArray removeAllObjects];
            [self dataRequest];
        }
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];

    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }else
    {
        return 0;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyWorterTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyWorterTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MoneyWorterTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count != 0) {
        MoneyWaterModel* model = _dataArray[indexPath.section];
        cell.dataLabel.text = model.date;
        if ([model.type integerValue] ==0) {
            cell.firstLabel.text = [NSString stringWithFormat:@"订单编号:%@",model.orderno];
            cell.secondLabel.text = [NSString stringWithFormat:@"余额变动:+%@",model.changemoney];
            cell.thirdLabel.text = [NSString stringWithFormat:@"当前余额:%@",model.currentmoney];
        }else{
            cell.firstLabel.text = @"提现";
            cell.secondLabel.text = [NSString stringWithFormat:@"余额变动:-%@",model.changemoney];
            cell.thirdLabel.text = [NSString stringWithFormat:@"当前余额:%@",model.currentmoney];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)dataRequest
{
//    NSDate *currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString* yearstr = [dateFormatter stringFromDate:currentDate];
    
    NSDictionary *json = [[NSDictionary alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSString *path;
    path = [[NSBundle mainBundle] pathForResource:@"MoneyWaterModel" ofType:@"json"];
    fileData = [NSData dataWithContentsOfFile:path];
    json = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    NSArray* array = json[@"data"];
    [_HUD hide:YES];
    for (int i = 0; i < array.count; i ++) {
        MoneyWaterModel* model = [[MoneyWaterModel alloc]init];
        [model setValuesForKeysWithDictionary:array[i]];
        [_dataArray addObject:model];
    }
    [_tbView reloadData];
}

- (void)dataRequest1
{

}








@end
