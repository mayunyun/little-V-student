//
//  MoneyDetailProViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/1.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MoneyDetailProViewController.h"
#import "MBProgressHUD.h"
#import "OrderDetailOrdernoTableViewCell.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "OrderDetailSendTableViewCell.h"
#import "OrderDetailTableView.h"
#import "OrderManageListModel.h"
#import "OrderDetailProTbViewModel.h"
#import "LoginViewController.h"


@interface MoneyDetailProViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD* _hud;
    NSMutableArray* _proDataArray;
    NSMutableArray* _dataArray;
    UIButton* _leftSegBtn;
    UIView* _leftSegLine;
    UIButton* _rightSegBtn;
    UIView* _rightSegLine;
    UIScrollView* _groundSView;
    UITableView* _tbView;
    UILabel* _willSendDataLabel;
    UITableView* _sendTbView;
    
    
}

@property (nonatomic,strong)OrderManageListModel* orderdetailModel;
@end

@implementation MoneyDetailProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    //    [self rightBarTitleButtonTarget:self action:@selector(mateClick:) text:@"配送匹配"];
    [self creatUI];
    //    _dataArray = @[@"1",@"2",@"3"];
    [self dataRequest];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
}

- (void)creatUI
{
    UIView* segView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 44)];
    segView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:segView];
    _leftSegBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _leftSegBtn.frame = CGRectMake(0, 0, segView.width/2, 43);
    [_leftSegBtn setTitle:@"订单详情" forState:UIControlStateNormal];
    [_leftSegBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [segView addSubview:_leftSegBtn];
    [_leftSegBtn addTarget:self action:@selector(leftSegBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftSegLine = [[UIView alloc]initWithFrame:CGRectMake(_leftSegBtn.center.x - 40, _leftSegBtn.bottom, 80, 1)];
    _leftSegLine.backgroundColor = NavBarItemColor;
    [segView addSubview:_leftSegLine];
    
    _rightSegBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightSegBtn.frame = CGRectMake(segView.width/2, 0, segView.width/2, 43);
    [_rightSegBtn setTitle:@"配送进度" forState:UIControlStateNormal];
    [_rightSegBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [segView addSubview:_rightSegBtn];
    [_rightSegBtn addTarget:self action:@selector(rightSegBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightSegLine = [[UIView alloc]initWithFrame:CGRectMake(_rightSegBtn.center.x - 40, _rightSegBtn.bottom, 80, 1)];
    _rightSegLine.backgroundColor = [UIColor clearColor];
    [segView addSubview:_rightSegLine];
    
    _groundSView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, segView.bottom, mScreenWidth, mScreenHeight - segView.height - 64)];
    _groundSView.showsVerticalScrollIndicator = NO;
    _groundSView.showsHorizontalScrollIndicator = NO;
    _groundSView.delegate = self;
    _groundSView.scrollEnabled = YES;
    _groundSView.bounces = NO;
    _groundSView.pagingEnabled = YES;
    _groundSView.alwaysBounceVertical = NO;
    _groundSView.contentSize = CGSizeMake(mScreenWidth*2, mScreenHeight - segView.height - 64);
    [self.view addSubview:_groundSView];
    
    //订单详情
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, _groundSView.height - 49)];
    [_tbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = YES;
    _tbView.bounces = NO;
    [_groundSView addSubview:_tbView];
    
    _willSendDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth+20, 0, mScreenWidth - 40, 90)];
    _willSendDataLabel.text = @"预计到达:";
    _willSendDataLabel.textColor = GrayTitleColor;
    [_groundSView addSubview:_willSendDataLabel];
    //配送进度
    _sendTbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth, 90, mScreenWidth, _groundSView.height - 90)];
    _sendTbView.delegate = self;
    _sendTbView.dataSource = self;
    [_sendTbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _sendTbView.showsHorizontalScrollIndicator = NO;
    _sendTbView.showsVerticalScrollIndicator = NO;
    _sendTbView.bounces = NO;
    _sendTbView.backgroundColor = BackGorundColor;
    [_groundSView addSubview:_sendTbView];
    _sendTbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setExtraCellLineHidden:_sendTbView];
    
}
//
- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//配送匹配
- (void)mateClick:(UIButton*)sender
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else {
        NSLog(@"scroView%f",scrollView.contentOffset.x);
        int i = scrollView.contentOffset.x/mScreenWidth;
        if (i == 0) {
            _leftSegBtn.titleLabel.textColor = NavBarItemColor;
            _leftSegLine.backgroundColor = NavBarItemColor;
            _rightSegBtn.titleLabel.textColor = [UIColor blackColor];
            _rightSegLine.backgroundColor = [UIColor clearColor];
            [_groundSView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if(i == 1){
            _rightSegBtn.titleLabel.textColor = NavBarItemColor;
            _rightSegLine.backgroundColor = NavBarItemColor;
            _leftSegBtn.titleLabel.textColor = [UIColor blackColor];
            _leftSegLine.backgroundColor = [UIColor clearColor];
            [_groundSView setContentOffset:CGPointMake(mScreenWidth, 0) animated:YES];
        }else{
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        return 6;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        if (section == 4) {
            return 0;
        }
        return 10;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        switch (indexPath.section) {
            case 0:
                return 44;
                break;
            case 1:
                return 80;
                break;
            case 2:
                if (IsEmptyValue(_dataArray)) {
                    return 0;
                }else{
                    return 100*_dataArray.count;
                }
                break;
            case 3:
                return 110;
                break;
            case 4:
                //                return 90;
                return 0;
                break;
            case 5:
                return 100;
                break;
            default:
                return 0;
                break;
        }
        
    }else{
        return 100;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    OrderDetailOrdernoTableViewCell* ordernoCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailOrdernoTableViewCellID"];
    if (!ordernoCell) {
        ordernoCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailOrdernoTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailNameTableViewCell* nameCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailNameTableViewCellID"];
    if (!nameCell) {
        nameCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailNameTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailPayTypeTableViewCell* payCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailPayTypeTableViewCellID"];
    if (!payCell) {
        payCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailPayTypeTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailBillTableViewCell* billCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailBillTableViewCellID"];
    if (!billCell) {
        billCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailBillTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailPriceTableViewCell* priceCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailPriceTableViewCellID"];
    if (!priceCell) {
        priceCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailPriceTableViewCell" owner:self options:nil]firstObject];
    }
    
    OrderDetailSendTableViewCell* sendCell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailSendTableViewCellID"];
    if (!sendCell) {
        sendCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailSendTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == _tbView) {
        if (indexPath.section == 0) {
            if (!IsEmptyValue(_orderdetailModel.orderno)) {
                //                _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
                ordernoCell.ordernoLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderdetailModel.orderno];
            }else{
                ordernoCell.ordernoLabel.text = @"订单号";
            }
            ordernoCell.orderStatusLabel.text = @"等待收货";
            ordernoCell.orderStatusLabel.textColor = NavBarItemColor;
            ordernoCell.orderStatusLabel.font = [UIFont systemFontOfSize:13];
            ordernoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return ordernoCell;
            
        }else if (indexPath.section == 1) {
            nameCell.selectBtn.hidden = YES;
            nameCell.delegate = self;
            nameCell.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",_orderdetailModel.custname];
            nameCell.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",_orderdetailModel.custphone];
            nameCell.addressLabel.text = [NSString stringWithFormat:@"地址：%@",_orderdetailModel.receiveraddr];
            if ([_orderdetailModel.pickupway integerValue] == 1) {
                [nameCell.pickUpWayBtn setTitle:@"自取" forState:UIControlStateNormal];
            }else{
                [nameCell.pickUpWayBtn setTitle:@"配送" forState:UIControlStateNormal];
            }
            nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nameCell;
            
        }else if (indexPath.section == 2) {
            
            if (!IsEmptyValue(_dataArray)) {
                cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count);
                OrderDetailTableView *view = [[OrderDetailTableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count)];
                view.backgroundColor = [UIColor redColor];
                view.dataArray = _proDataArray;
                [cell.contentView addSubview:view];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.section == 3){
            if (!IsEmptyValue(_orderdetailModel.paymethod)) {
                if ([_orderdetailModel.paymethod integerValue] == 0) {
                    //微信
                    [payCell.paytypeBtn setTitle:@"微信" forState:UIControlStateNormal];
                }else if ([_orderdetailModel.paymethod integerValue] == 1){
                    //支付宝
                    [payCell.paytypeBtn setTitle:@"支付宝" forState:UIControlStateNormal];
                }else if([_orderdetailModel.paymethod integerValue] == -2){
                    //金币
                    [payCell.paytypeBtn setTitle:@"金币" forState:UIControlStateNormal];
                }else if ([_orderdetailModel.paymethod integerValue] == 2){
                    //开联通
                    [payCell.paytypeBtn setTitle:@"开联通" forState:UIControlStateNormal];
                }else if ([_orderdetailModel.paymethod integerValue] == 6){
                    //联行支付
                    [payCell.paytypeBtn setTitle:@"联行支付" forState:UIControlStateNormal];
                }
            }
            if (!IsEmptyValue(_orderdetailModel.beginsendtime)) {
                payCell.sendDataLabel.text = [NSString stringWithFormat:@"%@",[Command sendtimeChangeData:_orderdetailModel.beginsendtime]];
            }
            if (!IsEmptyValue(_orderdetailModel.endsendtime)) {
                payCell.receiveDataLabel.text = [NSString stringWithFormat:@"%@",[Command sendtimeChangeData:_orderdetailModel.endsendtime]];
            }
            
            payCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return payCell;
        }else if (indexPath.section == 4){
            
            billCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            return billCell;
        }else{
            if (!IsEmptyValue(_orderdetailModel.ordermoney)) {
                priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"钱数：%@",_orderdetailModel.ordermoney];
                priceCell.orderPayLabel.text = [NSString stringWithFormat:@"实付款：%@",_orderdetailModel.ordermoney];
                _orderdetailModel.createtime = [self convertNull:_orderdetailModel.createtime];
                priceCell.orderDataLabel.text = [NSString stringWithFormat:@"下单时间：%@",[Command sendtimeChangeData:_orderdetailModel.createtime]];
            }
            priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return priceCell;
        }
        
    }else{
        sendCell.doteimgView.hidden = NO;
        sendCell.upView.hidden = NO;
        sendCell.downView.hidden = NO;
        if (indexPath.row == 0) {
            sendCell.upView.hidden = YES;
        }
        if (indexPath.row == 2) {
            sendCell.downView.hidden = YES;
        }
        if (!IsEmptyValue(_orderdetailModel.sendstatus)) {
            if ([_orderdetailModel.sendstatus integerValue] == 0 || [_orderdetailModel.sendstatus integerValue] == -1) {
                if (indexPath.row == 0) {
                    sendCell.titleLabel.text = @"订单已提交";
                    sendCell.detailLabel.text = @"请耐心等待商家发货";
                    sendCell.downView.hidden = YES;
                }else{
                    sendCell.doteimgView.hidden = YES;
                    sendCell.upView.hidden = YES;
                    sendCell.downView.hidden = YES;
                }
            }else if ([_orderdetailModel.sendstatus integerValue] == 1){
                if (indexPath.row == 0) {
                    sendCell.titleLabel.text = @"订单已提交";
                    sendCell.detailLabel.text = @"请耐心等待商家发货";
                }else if(indexPath.row == 1){
                    sendCell.titleLabel.text = @"商品配送中";
                    sendCell.detailLabel.text = @"请耐心等待配送";
                    sendCell.downView.hidden = YES;
                }else{
                    sendCell.doteimgView.hidden = YES;
                    sendCell.upView.hidden = YES;
                    sendCell.downView.hidden = YES;
                }
            }else if ([_orderdetailModel.sendstatus integerValue] == 2){
                if (indexPath.row == 0) {
                    sendCell.titleLabel.text = @"订单已提交";
                    sendCell.detailLabel.text = @"请耐心等待商家发货";
                }else if(indexPath.row == 1){
                    sendCell.titleLabel.text = @"商品配送中";
                    sendCell.detailLabel.text = @"请耐心等待配送";
                }else if(indexPath.row == 2){
                    sendCell.titleLabel.text = @"配送完成";
                    sendCell.detailLabel.text = @"请确认收货";
                }
            }
        }
        sendCell.backgroundColor = BackGorundColor;
        sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sendCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        
    }else{
        
    }
}

- (void)leftSegBtnClick:(UIButton*)sender
{
    sender.titleLabel.textColor = NavBarItemColor;
    _leftSegLine.backgroundColor = NavBarItemColor;
    _rightSegBtn.titleLabel.textColor = [UIColor blackColor];
    _rightSegLine.backgroundColor = [UIColor clearColor];
    [_groundSView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightSegBtnClick:(UIButton*)sender
{
    sender.titleLabel.textColor = NavBarItemColor;
    _rightSegLine.backgroundColor = NavBarItemColor;
    _leftSegBtn.titleLabel.textColor = [UIColor blackColor];
    _leftSegLine.backgroundColor = [UIColor clearColor];
    [_groundSView setContentOffset:CGPointMake(mScreenWidth, 0) animated:YES];
}


- (void)dataRequest
{
    /*
     /fees/searchfeesDetail.do
     mobile:true
     data{
        orderno
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/fees/searchfeesDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/fees/searchfeesDetail.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/fees/searchfeesDetail.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"/fees/searchfeesDetail.do%@",array);
            [_dataArray removeAllObjects];
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    _orderdetailModel = [[OrderManageListModel alloc]init];
                    [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:_orderdetailModel];
                }
                [self tbViewcellDataRequest];
                [_tbView reloadData];
                [_sendTbView reloadData];
            }
        }
    } failureBlock:^(NSError *error) {
        [_hud hide:YES];
    }];

}

- (void)tbViewcellDataRequest
{
    [_proDataArray removeAllObjects];
    for (int i =0; i < _dataArray.count; i++) {
        OrderManageListModel* promodel = _dataArray[i];
        OrderDetailProTbViewModel* model = [[OrderDetailProTbViewModel alloc]init];
        model.picname = promodel.picname;
        model.proname = promodel.proname;
        model.price = promodel.saleprice;
        model.folder = promodel.folder;
        model.isgolds = promodel.isgolds;
        model.sendtime = [self sendtimeChangeData:promodel.sendtime];
        model.count = [NSString stringWithFormat:@"%@",promodel.count];
        [_proDataArray addObject:model];
        [_tbView reloadData];
    }
}




@end
