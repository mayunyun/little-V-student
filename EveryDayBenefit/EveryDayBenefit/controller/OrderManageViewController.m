//
//  OrderManageViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderManageViewController.h"
#import "OrderManageTableViewCell.h"
#import "OrderManageListModel.h"
//#import "OrderDetailViewController.h"
#import "OrderDetailWaitViewController.h"
#import "OrderDetailReceiveViewController.h"
#import "OrderDetailReturnViewController.h"
#import "OrderCommentsListViewController.h"

#import "LoginNewViewController.h"
#import "MBProgressHUD.h"
#import "OrderReturnEndViewController.h"


@interface OrderManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    MBProgressHUD* _hud;
    UITableView* _tbView;
    NSArray* _currentDateArray;
    
    //全部订单弹框
    UIView* _myAleartView;
    UIView* _dataAleartView;
    UIButton* _dataBtn;
    UITableView* _aleartTbView;
    BOOL _changeRightBarSelect;
    
    NSString* _SelectStatusType;
    NSInteger _page;
    
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UIDatePicker* datePicker;


@end

@implementation OrderManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"订单管理";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    if (self.orderStatusFlag.integerValue == 0) {
        [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"全部订单"];
    }
    [self creatdata];
    [self creatUI];
//    [self dataRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataRequest];
}


- (void)creatUI
{
    UIView* leftline = [[UIView alloc]initWithFrame:CGRectMake(10, 15, (mScreenWidth - 60 - 20)/2, 1)];
    leftline.backgroundColor = LineColor;
    [self.view addSubview:leftline];
    _dataBtn = [UIButton buttonWithType:UIButtonTypeSystem];//[[UILabel alloc]initWithFrame:CGRectMake(leftline.right, 0, 60, 30)];
    _dataBtn.frame = CGRectMake(leftline.right, 0, 60, 30);
    [_dataBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dataBtn setTitle:_currentDateArray[0] forState:UIControlStateNormal];//_currentDateArray[0];
    [self.view addSubview:_dataBtn];
    [_dataBtn addTarget:self action:@selector(yearChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView* rightline = [[UIView alloc]initWithFrame:CGRectMake(_dataBtn.right, leftline.top, leftline.width, leftline.height)];
    rightline.backgroundColor = LineColor;
    [self.view addSubview:rightline];
    
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
        _SelectStatusType = @"";
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

- (UIView*)myaleartView
{
    if (!_myAleartView) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(mScreenWidth - 80, 0, 80, 45*5)];
        _myAleartView.backgroundColor = [UIColor redColor];
        [self.view addSubview:_myAleartView];
        _aleartTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
        [_aleartTbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        _aleartTbView.delegate = self;
        _aleartTbView.dataSource = self;
        _aleartTbView.bounces = NO;
        [_myAleartView addSubview:_aleartTbView];
    }
    return _myAleartView;
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    _changeRightBarSelect = !_changeRightBarSelect;//因为默认情况下为假，所以如果条件是先转换，那么就转换成真了。
    if (_changeRightBarSelect) {
        [self myaleartView];
    }else{
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    }
}

- (void)yearChoseClick:(UIButton*)sender
{
    _dataBtn.userInteractionEnabled = NO;
    _dataAleartView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, mScreenWidth, 270)];
    _dataAleartView.backgroundColor = [UIColor lightGrayColor];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,30, mScreenWidth, mScreenHeight-64-280-30)];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(_dataAleartView.frame.size.width-60, 0, 60, 30)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(closetime) forControlEvents:UIControlEventTouchUpInside];
    [_dataAleartView addSubview:button];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [_dataAleartView addSubview:_datePicker];
    [self.view addSubview:_dataAleartView];
}
- (void)closetime
{
    [_dataAleartView removeFromSuperview];
    _dataBtn.userInteractionEnabled = YES;
    [self dataRequest];
}
//监听datePicker值发生变化
- (void)dateChange:(id) sender
{
    _dataBtn.userInteractionEnabled = YES;
    UIDatePicker * datePicker = (UIDatePicker *)sender;
    NSDate *selectedDate = [datePicker date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    [_dataBtn setTitle:dateString forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            return _dataArray.count;
        }else{
            return 0;
        }
    }else if (tableView == _aleartTbView){
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if (tableView == _aleartTbView){
        return 5;
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
            OrderManageListModel* model = _dataArray[indexPath.section];
            NSArray* dateArr = [self separateDateStr:model.createtime];
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
//                case 4:
//                    
//                    break;
//                case 5:
//                    
//                    break;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSArray* array = @[@"待付款",@"待收货",@"待评价",@"已完成",@"已取消"];
        nomalcell.textLabel.text = array[indexPath.row];
        nomalcell.textLabel.font = [UIFont systemFontOfSize:13];
        nomalcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return nomalcell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (_dataArray.count!=0) {
            OrderManageListModel* model = _dataArray[indexPath.section];
            switch ([model.orderstatus intValue]) {
                case -1:{
                    //已取消订单
                    OrderDetailWaitViewController* vc = [[OrderDetailWaitViewController alloc]init];
                    vc.typeOrder = typeOrderDel;
                    //                NSString* str = [model.orderno uppercaseString];
                    vc.orderNo = model.orderno;
                    vc.orderStatusFlag = @"-1";
                    [vc setTransVaule:^(NSString* orderStatusFlag) {
                        [self refreshData:orderStatusFlag];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;
                case 0:{
                    //立即付款
                    OrderDetailWaitViewController* vc = [[OrderDetailWaitViewController alloc]init];
                    vc.typeOrder = typeOrderCancel;
                    //                NSString* str = [model.orderno uppercaseString];
                    vc.orderNo = model.orderno;
                    vc.orderStatusFlag = @"0";
                    [vc setTransVaule:^(NSString* orderStatusFlag) {
                        [self refreshData:orderStatusFlag];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;
                case 1:{
                    //确认收货
                    OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
                    //                NSString* str = [model.orderno uppercaseString];
                    vc.orderNo = model.orderno;
                    vc.orderStatusFlag = @"1";
                    [vc setTransVaule:^(NSString* orderStatusFlag) {
                        [self refreshData:orderStatusFlag];
                    }];
//                    vc.sendTime = [NSString stringWithFormat:@"%@",model.sendtime];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;
                case 2:{
                    if (IsEmptyValue(model.exiteflag)) {
                        //已完成
                        OrderDetailReturnViewController* vc = [[OrderDetailReturnViewController alloc]init];
                        //                NSString* str = [model.orderno uppercaseString];
                        vc.orderNo = model.orderno;
                        if (!IsEmptyValue(model.sendtime)) {
                            vc.sendTime = [NSString stringWithFormat:@"%@",model.sendtime];
                        }
                        vc.orderStatusFlag = @"2";
                        [vc setTransVaule:^(NSString* orderStatusFlag) {
                            [self refreshData:orderStatusFlag];
                        }];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else {
                        //退货
                        OrderReturnEndViewController* returnendVC = [[OrderReturnEndViewController alloc]init];
                        returnendVC.orderNo = model.orderno;
                        returnendVC.orderStatusFlag = @"2";
                        [returnendVC setTransVaule:^(NSString* orderStatusFlag) {
                            [self refreshData:orderStatusFlag];
                        }];
                        [self.navigationController pushViewController:returnendVC animated:YES];
                    }
                }break;
                case 3:{
                    //立即评价
                    OrderCommentsListViewController* vc = [[OrderCommentsListViewController alloc]init];
                    //                NSString* str = [model.orderno uppercaseString];
                    vc.orderNo = model.orderno;
                    vc.orderStatusFlag = @"3";
                    [vc setTransVaule:^(NSString* orderStatusFlag) {
                        [self refreshData:orderStatusFlag];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;
                case 6:{
                    //待发货
                    OrderDetailReceiveViewController* vc = [[OrderDetailReceiveViewController alloc]init];
                    //                NSString* str = [model.orderno uppercaseString];
                    vc.orderNo = model.orderno;
//                    vc.sendTime = [NSString stringWithFormat:@"%@",model.sendtime];
                    vc.orderStatusFlag = @"6";
                    [vc setTransVaule:^(NSString* orderStatusFlag) {
                        [self refreshData:orderStatusFlag];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }break;
                default:
                    break;
            }
        }
    }else if(tableView == _aleartTbView){
        switch (indexPath.row) {
            case 0:{
                //待付款
                _SelectStatusType = @"0";
                
                [self selectDataRequest];
                _tbView.mj_footer.hidden = YES;
            }
                break;
            case 1:{
                //待收货
                _SelectStatusType = @"1";
                
                [self selectDataRequest];
                _tbView.mj_footer.hidden = YES;
            }
                break;
            case 2:{
                //待评价
                _SelectStatusType = @"3";
                [self selectDataRequest];
                _tbView.mj_footer.hidden = YES;
            }
                break;
            case 3:{
                //已完成
                _SelectStatusType = @"2";
                [self selectDataRequest];
                _tbView.mj_footer.hidden = YES;
            }
                break;
            case 4:{
                //已取消
                _SelectStatusType = @"-1";
                
                [self selectDataRequest];
                _tbView.mj_footer.hidden = YES;
            }
            default:        break;
        }
        _changeRightBarSelect = !_changeRightBarSelect;
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    
    }
    
}


- (void)creatdata
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"MM"];
    NSDateFormatter *dateFormatter2 =[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd"];
    NSString* yearstr = [dateFormatter stringFromDate:currentDate];
    NSString* monthStr = [dateFormatter1 stringFromDate:currentDate];
    NSString* dataStr = [dateFormatter2 stringFromDate:currentDate];
    _currentDateArray =@[yearstr,monthStr,dataStr];

}

- (void)dataRequest
{
    /*
     /order/searchOrder.do
     mobile:true
     data{
     custid:用户id
     createtime:年
     orderstatus:默认传空
     page
     rows
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (_page == 1) {
        [_dataArray removeAllObjects];
    }
    NSString* orderstatus;
    if (IsEmptyValue(_orderStatusFlag)) {
        orderstatus = @"";
    }else{
        switch ([_orderStatusFlag integerValue]) {
            case 0:
                orderstatus = @"";
                break;
            case 1:
                orderstatus = @"0";
                break;
            case 2:
                orderstatus = @"6";
                break;
            case 3:
                orderstatus = @"1";
                break;
            case 4:
                orderstatus = @"3";
                break;
            default:
                orderstatus = @"";
                break;
        }
    }
       NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"createtime\":\"\",\"orderstatus\":\"%@\",\"page\":\"%@\",\"rows\":\"20\"}",userid,orderstatus,[NSString stringWithFormat:@"%li",(long)_page]];
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
        [hud hide:YES];
    } fail:^(NSError *error) {
        //进度HUD
        [hud hide:YES];
    }];
}

- (void)selectDataRequest
{
    /*
     /order/searchOrder.do
     mobile:true
     data{
     custid:用户id
     createtime:年
     orderstatus:默认传空：全部订单，0待付款，1待收货，2已完成，3待评价，-1已取消
     page:
     rows:
     }
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [_dataArray removeAllObjects];
    NSString* orderstatus;
    if (IsEmptyValue(_SelectStatusType)) {
        orderstatus = @"";
    }else{
        switch ([_SelectStatusType integerValue]) {
            case 0:
                orderstatus = @"0";
                break;
            case 1:
                orderstatus = @"1";
                break;
            case 2:
                orderstatus = @"2";
                break;
            case 3:
                orderstatus = @"3";
                break;
            case -1:
                orderstatus = @"-1";
                break;
            case 6:
                orderstatus = @"6";
                break;
            default:
                orderstatus = @"";
                break;
        }
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"createtime\":\"%@\",\"orderstatus\":\"%@\",\"page\":\"1\",\"rows\":\"1000\"}",userid,_dataBtn.titleLabel.text,orderstatus];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        [hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrder.do登录失败");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            if (array.count!=0) {
                [_dataArray removeAllObjects];
                for (int i = 0 ; i < array.count ; i++) {
                    OrderManageListModel* model = [[OrderManageListModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
            }
            [_tbView reloadData];
        }
    } fail:^(NSError *error) {
        [hud hide:YES];
    }];
}


#pragma mark refreshData
- (void)refreshData:(NSString*)orderStatusFlag
{
    /*
     /order/searchOrder.do
     mobile:true
     data{
     custid:用户id
     createtime:年
     orderstatus:默认传空
     page
     rows
     }
     */
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    if (_page == 1) {
//        [_dataArray removeAllObjects];
//    }
//    NSString* orderstatus;
//    if (IsEmptyValue(orderStatusFlag)) {
//        orderstatus = @"";
//    }else{
//        switch ([orderStatusFlag integerValue]) {
//            case 0:
//                orderstatus = @"0";
//                break;
//            case 1:
//                orderstatus = @"1";
//                break;
//            case 2:
//                orderstatus = @"2";
//                break;
//            case 3:
//                orderstatus = @"3";
//                break;
//            case -1:
//                orderstatus = @"-1";
//                break;
//            case 6:
//                orderstatus = @"6";
//                break;
//            default:
//                orderstatus = @"";
//                break;
//        }
//    }
//    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
//    userid = [self convertNull:userid];
//    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrder.do"];
//    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"createtime\":\"\",\"orderstatus\":\"%@\",\"page\":\"1\",\"rows\":\"1000\"}",userid,orderstatus];
//    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
//    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
//        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
//        NSLog(@"/order/searchOrder.do%@",str);
//        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
//            NSLog(@"/order/searchOrder.do登录失败");
//            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
//            [self.navigationController pushViewController:loginVC animated:NO];
//        }else{
//            [_dataArray removeAllObjects];
//            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
//            if (array.count!=0) {
//                for (int i = 0 ; i < array.count ; i++) {
//                    OrderManageListModel* model = [[OrderManageListModel alloc]init];
//                    [model setValuesForKeysWithDictionary:array[i]];
//                    [_dataArray addObject:model];
//                }
//            }
//            [_tbView reloadData];
//        }
//        //进度HUD
//        [hud hide:YES];
//        } fail:^(NSError *error) {
//        //进度HUD
//        [hud hide:YES];
//    }];

}


@end
