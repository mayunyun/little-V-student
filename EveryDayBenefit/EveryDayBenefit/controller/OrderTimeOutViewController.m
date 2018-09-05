//
//  OrderTimeOutViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderTimeOutViewController.h"
#import "MBProgressHUD.h"
#import "OrderManageTableViewCell.h"
#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "OrderDetailReceiveViewController.h"

@interface OrderTimeOutViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD* _hud;
    UITableView* _tbView;
    
    NSInteger _page;
    
}
@property (nonatomic,strong)NSMutableArray* dataArray;

@end

@implementation OrderTimeOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"超时提醒订单";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataRequest];
}


- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(10, 30, mScreenWidth - 20, mScreenHeight - 64 - 30)];
    _tbView.backgroundColor = BackGorundColor;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = 130;
    _tbView.tableHeaderView.backgroundColor = BackGorundColor;
    //    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    [self setExtraCellLineHidden:_tbView];
    
    
    //     下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self dataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        _tbView.mj_footer.hidden = NO;
    }];
    
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++ ;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            return _dataArray.count;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 10;
    }else{
        return 0;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* nomalCellID = @"cellID";
    UITableViewCell* nomalcell = [tableView dequeueReusableCellWithIdentifier:nomalCellID];
    if (!nomalcell) {
        nomalcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nomalCellID];
    }
    
    static NSString* cellID = @"OrderManageTableViewCellID";
    OrderManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderManageTableViewCell" owner:self options:nil]firstObject];
    }
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            {
                OrderManageListModel* model = _dataArray[indexPath.section];
                
                NSArray* dateArr = [self separateDateStr:model.warntime];
                cell.dayLabel.text = dateArr[2];
                cell.monthLabel.text = [NSString stringWithFormat:@"%@月",dateArr[1]];
                if ([model.isgolds integerValue] == 1) {
                    cell.titleLabel.text = [NSString stringWithFormat:@"总金额%@金币",model.ordermoney];//@"总金额**元";
                }else{
                    cell.titleLabel.text = [NSString stringWithFormat:@"总金额%@元",model.ordermoney];//@"总金额**元";
                }
                NSString* str;
                NSString* selectStr;
                switch ([model.orderstatus intValue]) {
                    case -1:
                        str = [NSString stringWithFormat:@"共%@件商品 | 已取消订单",model.ordercount];
                        selectStr = @"立即删除";
                        break;
                    case 0:
                        str = [NSString stringWithFormat:@"共%@件商品 | 等待付款",model.ordercount];
                        selectStr = @"立即付款";
                        break;
                    case 1:
                        str = [NSString stringWithFormat:@"共%@件商品 | 等待收货",model.ordercount];
                        selectStr = @"确认收货";
                        break;
                    case 2:
                    {
                        if (IsEmptyValue(model.exiteflag)) {
                            str = [NSString stringWithFormat:@"共%@件商品 | 已完成",model.ordercount];
                            selectStr = @"已完成";
                        }else if([model.exiteflag intValue] == 0){
                            str = [NSString stringWithFormat:@"共%@件商品 | 等待退货",model.ordercount];
                            selectStr = @"立即查看";
                        }else if ([model.exiteflag intValue] == 1){
                            str = [NSString stringWithFormat:@"共%@件商品 | 退货完成",model.ordercount];
                            selectStr = @"立即查看";
                        }else if ([model.exiteflag intValue] == -1){
                            str = [NSString stringWithFormat:@"共%@件商品 | 退货拒绝",model.ordercount];
                            selectStr = @"立即查看";
                        }
                    }
                        
                        break;
                    case 3:
                        str = [NSString stringWithFormat:@"共%@件商品 | 等待评价",model.ordercount];
                        selectStr = @"立即评价";
                        break;
                    case 6:
                        str = [NSString stringWithFormat:@"共%@件商品 | 待发货",model.ordercount];
                        selectStr = @"立即查看";
                        break;
                    default:
                        break;
                }
                cell.countLabel.text = str;
                cell.statusLabel.text = selectStr;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            
            OrderManageListModel* model = _dataArray[indexPath.section];
            OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
            vc.orderNo = model.orderno;
//            vc.sendTime = [NSString stringWithFormat:@"%@",model.sendtime];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


- (void)dataRequest
{
    /*
     /order/OrderTimeOut.do
     mobile:true
     data{
     custid
     page
     rows
     }
     */
    [_hud show:YES];
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/OrderTimeOut.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"page\":\"%li\",\"rows\":\"20\"}",userid,(long)_page];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/order/searchOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrder.do登录失败");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            if (array.count!=0) {
                for (int i = 0 ; i < array.count ; i++) {
                    OrderManageListModel* model = [[OrderManageListModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
            }
            [_tbView reloadData];
        }
        //进度HUD
        [_hud hide:YES afterDelay:.5];
        } fail:^(NSError *error) {
    }];
}


@end
