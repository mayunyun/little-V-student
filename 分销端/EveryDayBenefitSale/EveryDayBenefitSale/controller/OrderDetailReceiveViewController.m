//
//  OrderDetailReceiveViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailReceiveViewController.h"
#import "OrderDetailTableView.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "OrderDetailSendTableViewCell.h"
#import "OrderDetailOrdernoTableViewCell.h"
#import "OrderManageListModel.h"
#import "LoginViewController.h"
#import "OrderDetailProTbViewModel.h"
#import "commandModel.h"

@interface OrderDetailReceiveViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailNameDelegate,UIScrollViewDelegate>
{
    UIScrollView* _groundSView;
    UIButton* _leftSegBtn;
    UIView* _leftSegLine;
    UIButton* _rightSegBtn;
    UIView* _rightSegLine;
    UILabel* _orderNoLabel;
    UITableView* _tbView;
    UILabel* _willSendDataLabel;
    UITableView* _sendTbView;
    NSMutableArray* _proDataArray;
    
    UIView* _myAleartView;
    UITableView* _fxCustTableView;
    NSMutableArray* _sendArray;
    NSString* _sendlinker;
    NSString* _sendlinkerid;
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;
@end

@implementation OrderDetailReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    _sendArray = [[NSMutableArray alloc]init];
    
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
//    if (!IsEmptyValue(self.sendstatus)) {
//        if ([self.sendstatus integerValue] == -1) {
//            [self rightBarTitleButtonTarget:self action:@selector(mateClick:) text:@"配送匹配"];
//        }
//    }
    [self creatUI];
    [self SearchOrderRequest];
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
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, _groundSView.height)];
    [_tbView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    _tbView.showsHorizontalScrollIndicator = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.scrollEnabled = YES;
    _tbView.bounces = NO;
    [_groundSView addSubview:_tbView];
    
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, _groundSView.height - 49, mScreenWidth, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
//    [_groundSView addSubview:footerView];
    UIButton* footBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    footBtn.frame = CGRectMake(footerView.right - 90, 10, 70, 30) ;
    [footBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    [footBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    footBtn.layer.masksToBounds = YES;
    footBtn.layer.cornerRadius = 5.0;
    CALayer *layer = [footBtn layer];
    layer.borderColor = NavBarItemColor.CGColor;
    layer.borderWidth = .5f;
    [footerView addSubview:footBtn];
    [footBtn addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    footerView.backgroundColor = BackGorundColor;
    UIButton* delectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    delectBtn.frame = CGRectMake(10, 10, 80, 30);
    [delectBtn setBackgroundColor:[UIColor clearColor]];
    [delectBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    delectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [delectBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
    [footerView addSubview:delectBtn];
    [delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _willSendDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth+20, 0, mScreenWidth - 40, 90)];
    _willSendDataLabel.text = @"预计到达:";
    _willSendDataLabel.textColor = GrayTitleColor;
    _willSendDataLabel.adjustsFontSizeToFitWidth = YES;
    _willSendDataLabel.numberOfLines = 0;
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
    [self creatFxCustUI];
    [self searchDistributerReuquestData];
}

- (UIView*)creatFxCustUI{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_myAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFxCustAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleartView.height - 350)/2, _myAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _fxCustTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _fxCustTableView.backgroundColor = [UIColor grayColor];
        _fxCustTableView.delegate = self;
        _fxCustTableView.dataSource = self;
        [windowView addSubview:_fxCustTableView];
        
    }
    return _myAleartView;
}

- (void)closeFxCustAleartView:(UITapGestureRecognizer*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (void)closeAleartView:(UIButton*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
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
    }else if (tableView == _fxCustTableView){
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
    }else if (tableView == _fxCustTableView){
        if (!IsEmptyValue(_sendArray)) {
            return _sendArray.count;
        }
    }
    return 0;
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

    }else if (tableView == _fxCustTableView){
        return 44;
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
    }else if (tableView == _fxCustTableView){
        if (!IsEmptyValue(_sendArray)) {
            commandModel* model = _sendArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        }
        return cell;
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
        sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sendCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        
    }else if(tableView == _fxCustTableView){
        if (!IsEmptyValue(_sendArray)) {
            commandModel* model = _sendArray[indexPath.row];
            _sendlinkerid = [NSString stringWithFormat:@"%@",model.Id];
            _sendlinker = [NSString stringWithFormat:@"%@",model.name];
            [self confirmDisInforRequestData];
        }
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

- (void)selectAddBtnClick:(UIButton *)sender
{
    NSLog(@"==点击了地址选择按钮==");
}

- (void)footBtnClick:(UIButton*)sender
{

}

- (void)delectBtnClick:(UIButton*)sender
{
    
}

- (void)SearchOrderRequest
{
    /*
     /order/searchOrderDetail.do
     data{
     orderno:订单编号
     page:1
     rows:1
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\",\"page\":\"1\",\"rows\":\"1\"}",self.orderNo];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"searchOrder.do重新登录");
            LoginViewController* loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"searchOrder.do%@",array);
            [_dataArray removeAllObjects];
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    _orderdetailModel = [[OrderManageListModel alloc]init];
                    [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:_orderdetailModel];
                }
                 _willSendDataLabel.text = [NSString stringWithFormat:@"预计到达时间：%@",[self sendtimeChangeData:_orderdetailModel.sendtime]];
                [self tbViewcellDataRequest];
                
            }
            [_tbView reloadData];
            [_sendTbView reloadData];
        }
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
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


- (void)searchDistributerReuquestData
{
    /*
     /send/searchDistributer.do
     mobile:true
     data{
        linkerid 分销端当前登录用户的id
     }
     */
    NSString* linkerid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    linkerid = [self convertNull:linkerid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchDistributer.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"linkerid\":\"%@\"}",linkerid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/searchDistributer.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        [_sendArray removeAllObjects];
        if (!IsEmptyValue(array)) {
            for (int i = 0; i <array.count; i++) {
                commandModel* model = [[commandModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_sendArray addObject:model];
            }
        }
        [_fxCustTableView reloadData];
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}

- (void)confirmDisInforRequestData
{
    /*
     /order/confirmDis.do
     mobile:true
     data{
         orderno
         senderid
     }
     */
    NSString* exiteno = [self convertNull:_orderdetailModel.orderno];
    _sendlinker = [self convertNull:_sendlinker];
    _sendlinkerid = [self convertNull:_sendlinkerid];
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/confirmDis.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\",\"senderid\":\"%@\"}",exiteno,_sendlinkerid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"配送员匹配成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([str rangeOfString:@"false"].location != NSNotFound){
            [self showAlert:@"配送员匹配失败"];
        }
        [_myAleartView removeFromSuperview];
        _myAleartView = nil;
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
    
}





@end
