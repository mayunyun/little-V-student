//
//  ReturnDetailViewController.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ReturnDetailViewController.h"
#import "ReturnDetailTableView.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "OrderDetailSendTableViewCell.h"
#import "OrderDetailOrdernoTableViewCell.h"
#import "OrderDetailProTbViewModel.h"
#import "commandModel.h"
#import "MBProgressHUD.h"
#import "ExiteDetailModel.h"

@interface ReturnDetailViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailNameDelegate,UIScrollViewDelegate>
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
    
    MBProgressHUD* _hud;
    NSString* _sendlinkerid;
    NSString* _sendlinker;
    
    UIView* _reviewAleartView;
    UITableView* _reviewTbView;
    NSArray* _reviewArray;
    UIButton* _footBtn;
    
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)ExiteDetailModel* detailModel;
@end

@implementation ReturnDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    _sendArray = [[NSMutableArray alloc]init];
    _reviewArray = @[@"待定",@"通过",@"拒绝"];
    self.title = @"退货详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
//    if (!IsEmptyValue(self.sendstatus)) {
//        if ([self.sendstatus integerValue] == -1) {
//            [self rightBarTitleButtonTarget:self action:@selector(mateClick:) text:@"配送匹配"];
//        }
//    }
    [self creatUI];
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
    //退货订单
    
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
    
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, _groundSView.height - 49, mScreenWidth, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
    [_groundSView addSubview:footerView];
    _footBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _footBtn.frame = CGRectMake(footerView.right - 90, 10, 70, 30) ;
    if (!IsEmptyValue(_orderdetailModel.linkerstatus)) {
        switch ([_orderdetailModel.linkerstatus integerValue]) {
            case 0:
                [_footBtn setTitle:@"立即审核" forState:UIControlStateNormal];
                [_footBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
                break;
            case 1:
                [_footBtn setTitle:@"已审核" forState:UIControlStateNormal];
                [_footBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
                _footBtn.enabled = NO;
                break;
            case -1:
                [_footBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                [_footBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
                _footBtn.enabled = NO;
                break;
            default:
                break;
        }
    }
    
    _footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _footBtn.layer.masksToBounds = YES;
    _footBtn.layer.cornerRadius = 5.0;
    CALayer *layer = [_footBtn layer];
    layer.borderColor = NavBarItemColor.CGColor;
    layer.borderWidth = .5f;
    [footerView addSubview:_footBtn];
    [_footBtn addTarget:self action:@selector(footBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    footerView.backgroundColor = BackGorundColor;
    UIButton* delectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    delectBtn.frame = CGRectMake(10, 10, 80, 30);
    [delectBtn setBackgroundColor:[UIColor clearColor]];
    [delectBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    delectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [delectBtn setTitleColor:GrayTitleColor forState:UIControlStateNormal];
//    [footerView addSubview:delectBtn];
    [delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    _orderdetailModel.linkerstatus = [self convertNull:_orderdetailModel.linkerstatus];
    if (!IsEmptyValue(_orderdetailModel.linkerstatus)) {
        if ([_orderdetailModel.linkerstatus integerValue] == 1) {
            [self creatFxCustUI];
            [self searchDistributerReuquestData];
        }else{
            [self showAlert:@"审核通过的订单可以匹配配送人"];
        }
    }

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
    }else if(tableView == _sendTbView){
        return 1;
    }else if (tableView == _fxCustTableView){
        return 1;
    }else if (tableView == _reviewTbView){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if(tableView == _sendTbView){
        return 3;
    }else if (tableView == _fxCustTableView){
        if (!IsEmptyValue(_sendArray)) {
            return _sendArray.count;
        }
    }else if (tableView == _reviewTbView){
        if (!IsEmptyValue(_reviewArray)) {
            return _reviewArray.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        if (section == 4 || section == 3) {
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
//                return 110;
                break;
            case 4:
//                return 90;
                break;
            case 5:
                return 100;
                break;
            default:
                return 0;
                break;
        }
        
    }else if(tableView == _sendTbView){
        return 100;
    }else if (tableView == _fxCustTableView){
        return 44;
    }else if (tableView == _reviewTbView){
        return 44;
    }
    return 0;
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
            if (!IsEmptyValue(_orderdetailModel.exiteno)) {
//                _orderdetailModel.exiteno = [_orderdetailModel.exiteno uppercaseString];
                ordernoCell.ordernoLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderdetailModel.exiteno];
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
            nameCell.pickUpWayBtn.hidden = YES;
            nameCell.delegate = self;
            _orderdetailModel.custname = [self convertNull:_orderdetailModel.custname];
            _orderdetailModel.custphone = [self convertNull:_orderdetailModel.custphone];
            _orderdetailModel.exiteaddress = [self convertNull:_orderdetailModel.exiteaddress];
            nameCell.titleLabel.text = [NSString stringWithFormat:@"姓名：%@",_orderdetailModel.custname];
            nameCell.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",_orderdetailModel.custphone];
            nameCell.addressLabel.text = [NSString stringWithFormat:@"地址：%@",_orderdetailModel.exiteaddress];
            nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return nameCell;

        }else if (indexPath.section == 2) {
            
            if (!IsEmptyValue(_dataArray)) {
                cell.contentView.frame = CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count);
                ReturnDetailTableView *view = [[ReturnDetailTableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 100*_dataArray.count)];
                view.backgroundColor = [UIColor redColor];
                view.dataArray = _proDataArray;
                [cell.contentView addSubview:view];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else if (indexPath.section == 3){
            
            payCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return payCell;
        }else if (indexPath.section == 4){
            
            billCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return billCell;
        }else{
            if (!IsEmptyValue(_orderdetailModel.exitmoney)) {
                priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"钱数：%@",_orderdetailModel.exitmoney];
                priceCell.orderPayLabel.text = [NSString stringWithFormat:@"实付款：%@",_orderdetailModel.exitmoney];
                _orderdetailModel.createtime = [self convertNull:_orderdetailModel.createtime];
                priceCell.orderDataLabel.text = [NSString stringWithFormat:@"下单时间：%@",[Command sendtimeChangeData:_orderdetailModel.createtime]];
            }
            priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return priceCell;
        }
        
    }else if(tableView == _sendTbView){
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
                    sendCell.detailLabel.text = @"请耐心等待退货";
                    sendCell.downView.hidden = YES;
                }else{
                    sendCell.doteimgView.hidden = YES;
                    sendCell.upView.hidden = YES;
                    sendCell.downView.hidden = YES;
                }
            }else if ([_orderdetailModel.sendstatus integerValue] == 2){
                if (indexPath.row == 0) {
                    sendCell.titleLabel.text = @"订单已提交";
                    sendCell.detailLabel.text = @"请耐心等待退货";
                }else if(indexPath.row == 1){
                    sendCell.titleLabel.text = @"商品退货中";
                    sendCell.detailLabel.text = @"请耐心等待配送";
                    sendCell.downView.hidden = YES;
                }else{
                    sendCell.doteimgView.hidden = YES;
                    sendCell.upView.hidden = YES;
                    sendCell.downView.hidden = YES;
                }
            }else if ([_orderdetailModel.sendstatus integerValue] == 1){
                if (indexPath.row == 0) {
                    sendCell.titleLabel.text = @"订单已提交";
                    sendCell.detailLabel.text = @"请耐心等待退货";
                }else if(indexPath.row == 1){
                    sendCell.titleLabel.text = @"商品退货中";
                    sendCell.detailLabel.text = @"请耐心等待配送";
                }else{
                    sendCell.titleLabel.text = @"退货完成";
                    sendCell.detailLabel.text = @"请确认收货";
                }
            }
        }
        sendCell.backgroundColor = BackGorundColor;
        sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sendCell;
    }else if (tableView == _fxCustTableView){
        if (!IsEmptyValue(_sendArray)) {
            commandModel* model = _sendArray[indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
        }
        return cell;
    }else if (tableView == _reviewTbView){
        cell.textLabel.text = _reviewArray[indexPath.row];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        
    }else if(tableView == _sendTbView){
        
    }else if(tableView == _fxCustTableView){
        if (!IsEmptyValue(_sendArray)) {
            commandModel* model = _sendArray[indexPath.row];
            _sendlinkerid = [NSString stringWithFormat:@"%@",model.Id];
            _sendlinker = [NSString stringWithFormat:@"%@",model.name];
            [self confirmDisInforRequestData];
        }
    }else if (tableView == _reviewTbView){
        [self confirmExiteOrderReuqestData:indexPath.row];
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
    [self reviewAleartView:sender.tag];
}

- (void)delectBtnClick:(UIButton*)sender
{
    
}


- (void)dataRequest
{
    /*
     /send/searchExiteOrderDetail.do
     mobile:true
     data{
     ID
     }
     */
    [_hud show:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/searchExiteOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"id\":\"%@\"}",self.Id];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/searchExiteOrderDetail.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        if (array.count!=0) {
            [_dataArray removeAllObjects];
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    _detailModel = [[ExiteDetailModel alloc]init];
                    [_detailModel setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:_detailModel];
                }
                [self tbViewcellDataRequest];
            }
            [_tbView reloadData];
            [_sendTbView reloadData];
        }
        
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        [_hud hide:YES];
    }];
    
}



- (void)tbViewcellDataRequest
{
    [_proDataArray removeAllObjects];
    for (int i =0; i < _dataArray.count; i++) {
        ExiteOrderModel* promodel = _dataArray[i];
        OrderDetailProTbViewModel* model = [[OrderDetailProTbViewModel alloc]init];
        model.picname = promodel.picname;
        model.proname = promodel.proname;
        model.price = promodel.saleprice;
        model.folder = promodel.folder;
        model.isgolds = promodel.isgolds;
//        model.sendtime = [self sendtimeChangeData:promodel.sendtime];
        model.count = [NSString stringWithFormat:@"%@",promodel.exitecount];
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
     /send/confirmDisInfor.do
     mobile:true
     data{
         exiteno
         sendlinkerid
         sendlinker
     }
     */
    NSString* exiteno = [self convertNull:_orderdetailModel.exiteno];
    _sendlinker = [self convertNull:_sendlinker];
    _sendlinkerid = [self convertNull:_sendlinkerid];
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/confirmDisInfor.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"exiteno\":\"%@\",\"sendlinkerid\":\"%@\",\"sendlinker\":\"%@\"}",exiteno,_sendlinkerid,_sendlinker];
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



- (UIView*)reviewAleartView:(NSInteger)index
{
    if (_reviewAleartView == nil) {
        _reviewAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        _reviewAleartView.backgroundColor = [UIColor clearColor];
        [APPDelegate.window addSubview:_reviewAleartView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_reviewAleartView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeReviewAleartView:)];
        [grayView addGestureRecognizer:tap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_reviewAleartView.height - 350)/2, _reviewAleartView.width - 40*2, 350)];
        windowView.userInteractionEnabled = YES;
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        windowView.backgroundColor = [UIColor whiteColor];
        [_reviewAleartView addSubview:windowView];
        
        UIView* topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        topView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:topView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(topView.width - 60, 0, 60, topView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [topView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeCancelAleartView:) forControlEvents:UIControlEventTouchUpInside];
        _reviewTbView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _reviewTbView.tag = index;
        _reviewTbView.backgroundColor = [UIColor grayColor];
        _reviewTbView.delegate = self;
        _reviewTbView.dataSource = self;
        [windowView addSubview:_reviewTbView];
    }
    return _reviewAleartView;
}
- (void)closeReviewAleartView:(UITapGestureRecognizer*)sender
{
    [_reviewAleartView removeFromSuperview];
    _reviewAleartView = nil;
}
- (void)closeCancelAleartView:(UIButton*)sender
{
    [_reviewAleartView removeFromSuperview];
    _reviewAleartView = nil;
}


- (void)confirmExiteOrderReuqestData:(NSInteger)index
{
    /*
     /distribute/confirmExiteOrder.do
     mobile:true
     data{
     linkerstatus审核状态1通过0待定-1拒绝
     exiteno退货单号
     orderno订单号
     }
     */
    NSString* linkerstatus;
    switch (index) {
        case 0:
            linkerstatus = @"0";
            break;
        case 1:
            linkerstatus = @"1";
            break;
        case 2:
            linkerstatus = @"-1";
            break;
        default:
            break;
    }
    NSString* exiteno = [self convertNull:_orderdetailModel.exiteno];
    NSString* orderno = [self convertNull:_orderdetailModel.orderno];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/distribute/confirmExiteOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"linkerstatus\":\"%@\",\"exiteno\":\"%@\",\"orderno\":\"%@\"}",linkerstatus,exiteno,orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    __block NSString* linkerstatusstr = linkerstatus;
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(AFHTTPRequestOperationManager *operation, id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/distribute/confirmExiteOrder.do%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"审核更改成功"];
            _footBtn.enabled = NO;
            switch ([linkerstatusstr integerValue]) {
                case 0:
                    [_footBtn setTitle:@"待定" forState:UIControlStateNormal];
                    break;
                case 1:
                    [_footBtn setTitle:@"通过" forState:UIControlStateNormal];
                    break;
                case -1:
                    [_footBtn setTitle:@"拒绝" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
        }
        [_reviewAleartView removeFromSuperview];
        _reviewAleartView = nil;
    } failureBlock:^(AFHTTPRequestOperationManager *operation, NSError *error) {
        
    }];
}












@end
