//
//  OrderMineCustViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 17/2/6.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderMineCustViewController.h"
#import "OrderMineCustTableViewCell.h"
#import "searchCustomerModel.h"

@interface OrderMineCustViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _dataArray;
    NSInteger _page;
    NSString* _countcust;
}
@property (nonatomic,strong)UITableView* tbView;


@end

@implementation OrderMineCustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"我的客户"];
    [self creatUI];
    [self dataRestData];
    [self countDataRequest];
    
}
- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self dataRestData];
        [self countDataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++ ;
        [self dataRestData];
        [self countDataRequest];
        [_tbView.mj_footer endRefreshing];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return _dataArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if(indexPath.section == 1){
        return 60;
    }else{
        return 44;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    OrderMineCustTableViewCell* custCell = [tableView dequeueReusableCellWithIdentifier:@"OrderMineCustTableViewCellID"];
    if (!custCell) {
        custCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderMineCustTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (indexPath.section == 0) {
        for (UIView* view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth-150)*0.5, 2, 150, 40)];
        [cell.contentView addSubview:view];
        UIImageView* iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 30)];
        iconView.image = [UIImage imageNamed:@"minecust"];
        [view addSubview:iconView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right, 0, view.width - iconView.right, view.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = [NSString stringWithFormat:@"共 %@ 位客户",_countcust];
        [view addSubview:label];
        
        
        return cell;
    }else if (indexPath.section == 1){
        if (!IsEmptyValue(_dataArray)) {
            searchCustomerModel* model = _dataArray[indexPath.row];
            [custCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,model.picsrc,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            custCell.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
            custCell.phoneLabel.text = [NSString stringWithFormat:@"%@",model.phone];
            custCell.dateLabel.text =[NSString stringWithFormat:@"%@",[Command sendtimeChangeData:model.createtime]];
            custCell.ordernoLabel.text = [NSString stringWithFormat:@"%@笔",model.count];
            model.money = [NSString stringWithFormat:@"%@",model.money];
            custCell.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.money doubleValue]];
        }
        return custCell;
    }
    return cell;
}

- (void)dataRestData
{
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    /*
     NSASCIIStringEncoding = 1,
    NSNEXTSTEPStringEncoding = 2,
    NSJapaneseEUCStringEncoding = 3,
    NSUTF8StringEncoding = 4,
    NSISOLatin1StringEncoding = 5,
    NSSymbolStringEncoding = 6,
    NSNonLossyASCIIStringEncoding = 7,
    NSShiftJISStringEncoding = 8,
    NSISOLatin2StringEncoding = 9,
    NSUnicodeStringEncoding = 10,
    NSWindowsCP1251StringEncoding = 11,
    NSWindowsCP1252StringEncoding = 12,    
     NSWindowsCP1253StringEncoding = 13,
    NSWindowsCP1254StringEncoding = 14,
    NSWindowsCP1250StringEncoding = 15,
    NSISO2022JPStringEncoding = 21,
    NSMacOSRomanStringEncoding = 30,
    
    NSUTF16StringEncoding = NSUnicodeStringEncoding,
    
    NSUTF16BigEndianStringEncoding = 0x90000100,
    NSUTF16LittleEndianStringEncoding = 0x94000100,
    
    NSUTF32StringEncoding = 0x8c000100,
    NSUTF32BigEndianStringEncoding = 0x98000100,
    NSUTF32LittleEndianStringEncoding = 0x9c000100
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/customer/searchCustomer.do"];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* datastr = [NSString stringWithFormat:@"{\"linkerid\":\"%@\",\"page\":\"%ld\",\"rows\":\"20\"}",userid,(long)_page];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/customer/searchCustomer.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (!IsEmptyValue(array)) {
            for (int i = 0; i <array.count; i++) {
                searchCustomerModel* model = [[searchCustomerModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_dataArray addObject:model];
            }
        }
        [_tbView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
    }];
}

- (void)countDataRequest
{
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/customer/searchCustomerCount.do"];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    NSString* datastr = [NSString stringWithFormat:@"{\"linkerid\":\"%@\"}",userid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/customer/searchCustomerCount.do%@",str);
        _countcust = str;
        [_tbView reloadData];
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}



@end
