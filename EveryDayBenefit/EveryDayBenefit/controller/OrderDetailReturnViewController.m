//
//  OrderDetailReturnViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/31.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailReturnViewController.h"
#import "OrderDetailTableView.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "OrderDetailSendTableViewCell.h"
#import "OrderDetailOrdernoTableViewCell.h"

#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "OrderDetailProTbViewModel.h"
#import "ExiteOrderCollectionViewCell.h"

#import "OrderManageViewController.h"

#import "MBProgressHUD.h"
#define YJDD @"预计到达:"
@interface OrderDetailReturnViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailNameDelegate,UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    MBProgressHUD* _hud;
    UIScrollView* _groundSView;
    UIButton* _leftSegBtn;
    UIView* _leftSegLine;
    UIButton* _rightSegBtn;
    UIView* _rightSegLine;
//    UILabel* _orderNoLabel;
    UITableView* _tbView;
    UILabel* _willSendDataLabel;
    UILabel* _outTimeLabel;
    UIButton* _outTimeBtn;
    UITableView* _sendTbView;
    
    UIView* _myAleareView;
    UITextField* _noteTextField;
    UIImageView* _deSelectImg;
    UILabel* _totalLabel;
    UIScrollView* _aleartScrollView;
    UICollectionView* _collView;
    UIImageView* windowView;
    BOOL _isSelectAll;
    
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;
@property (nonatomic,strong)NSMutableArray* proDataArray;
@property (nonatomic,strong)NSMutableIndexSet* selectIndexArr;

@end

@implementation OrderDetailReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    _selectIndexArr = [[NSMutableIndexSet alloc]init];
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
    [self SearchOrderRequest];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray* array = self.navigationController.viewControllers;
    NSLog(@"-------%@,,,%@",array,array[array.count - 1 - 1]);
    if ([array[array.count - 1] isKindOfClass:[OrderManageViewController class]]) {
        if (_transVaule) {
            _transVaule(self.orderStatusFlag);
        }
    }
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
    _tbView.showsVerticalScrollIndicator = YES;
    _tbView.showsHorizontalScrollIndicator = YES;
    [_groundSView addSubview:_tbView];
    
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, _groundSView.height - 49, mScreenWidth, 49)];
    footerView.backgroundColor = [UIColor whiteColor];
    [_groundSView addSubview:footerView];
    UIButton* footBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    footBtn.frame = CGRectMake(footerView.right - 90, 10, 70, 30) ;
    [footBtn setTitle:@"申请退货" forState:UIControlStateNormal];
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
//    [footerView addSubview:delectBtn];
    [delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //配送进度
    _willSendDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth+20, 0, mScreenWidth - 40 - 80, 90)];
    _willSendDataLabel.text = YJDD;
    _willSendDataLabel.textColor = GrayTitleColor;
    _willSendDataLabel.numberOfLines = 0;
    [_groundSView addSubview:_willSendDataLabel];
    _outTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(mScreenWidth*2 - 80 - 20, 0, 80, 90)];
    _outTimeLabel.font = [UIFont systemFontOfSize:13];
    _outTimeLabel.text = @"已超时";
    _outTimeLabel.hidden = YES;
    _outTimeLabel.textAlignment = NSTextAlignmentRight;
    _outTimeLabel.textColor = NavBarItemColor;
    [_groundSView addSubview:_outTimeLabel];
    
    _sendTbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth, 90, mScreenWidth, _groundSView.height - 90 - 50)];
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
    
    _outTimeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _outTimeBtn.frame = CGRectMake(_outTimeLabel.left, _sendTbView.bottom, 80, 30);
    _outTimeBtn.enabled = NO;
    [_outTimeBtn setTitle:@"超时提醒" forState:UIControlStateNormal];
    [_outTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_outTimeBtn setBackgroundColor:GrayTitleColor];
    [_groundSView addSubview:_outTimeBtn];
    _outTimeBtn.layer.masksToBounds = YES;
    _outTimeBtn.layer.cornerRadius = 5.0;
    [_outTimeBtn addTarget:self action:@selector(outTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
            [self isOutTime];
        }else{
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tbView) {
        return 6;
    }else if (tableView == _sendTbView){
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 1;
    }else if (tableView == _sendTbView){
        return 3;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _tbView){
//        return 10;
        if (section == 4) {
            return 0;
        }else{
            return 10;
        }
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
        
    }else if(tableView == _sendTbView){
        return 100;
    }else{
        return 0;
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
                ordernoCell.ordernoLabel.text = [NSString stringWithFormat:@"订单号：%@",_orderdetailModel.orderno];
            }else{
                ordernoCell.ordernoLabel.text = @"订单号";
            }
            ordernoCell.orderStatusLabel.text = @"已完成";
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
                priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"钱数：%.2f",[_orderdetailModel.ordermoney floatValue]];
                priceCell.orderPayLabel.text = [NSString stringWithFormat:@"实付款：%@",_orderdetailModel.ordermoney];
                _orderdetailModel.createtime = [self convertNull:_orderdetailModel.createtime];
                priceCell.orderDataLabel.text = [NSString stringWithFormat:@"下单时间：%@",[Command sendtimeChangeData:_orderdetailModel.createtime]];
            }
            priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return priceCell;
        }
        
    }else{
        if (!IsEmptyValue(self.sendTime)) {
            NSLog(@"-------%@",self.sendTime);
            _willSendDataLabel.text = [NSString stringWithFormat:@"%@%@",YJDD,[Command sendtimeChangeData:self.sendTime]];
        }
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
                }
            }else if ([_orderdetailModel.sendstatus integerValue] == 1){
                if (indexPath.row == 0) {
                    sendCell.titleLabel.text = @"订单已提交";
                    sendCell.detailLabel.text = @"请耐心等待商家发货";
                }else if(indexPath.row == 1){
                    sendCell.titleLabel.text = @"商品配送中";
                    sendCell.detailLabel.text = @"请耐心等待配送";
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
    
}

- (void)tbViewcellDataRequest
{
    for (int i =0; i < _dataArray.count; i++) {
        OrderManageListModel* promodel = _dataArray[i];
        OrderDetailProTbViewModel* model = [[OrderDetailProTbViewModel alloc]init];
        model.picname = promodel.picname;
        model.proname = promodel.proname;
        model.price = promodel.saleprice;
        model.folder = promodel.folder;
        model.isgolds = promodel.isgolds;
        model.count = [NSString stringWithFormat:@"%@",promodel.count];
        [_proDataArray addObject:model];
        [_tbView reloadData];
    }
}

- (void)isOutTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    NSString* willStr = [self changeTxt:_willSendDataLabel.text changeTxt:[NSString stringWithFormat:@"%@",YJDD]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * datewill = [formatter dateFromString:willStr];
    
    NSTimeInterval time2 =[date timeIntervalSinceDate:datewill];
    int days=((int)time2)/(3600*24);
    int hours=((int)time2)%(3600*24)/3600;
    int minute=((int)time2 - hours*3600)/60;
    int second = (int)time2 - hours*3600 - minute*60;
    if (!IsEmptyValue(self.sendTime)) {
        if (time2 < 0) {
            NSLog(@"如今时间:%@;预计到达时间%@,您还有%d天%d时%d分%d秒可以支付",dateStr,willStr,days,hours,minute,second);
            _outTimeLabel.hidden = YES;
            _outTimeBtn.enabled = NO;
            [_outTimeBtn setBackgroundColor:GrayTitleColor];
        }else{
            NSLog(@"如今时间:%@;预计到达时间%@,请您超时%d天%d时%d分%d秒未支付",dateStr,willStr,days,hours,minute,second);
            if (!IsEmptyValue(_orderdetailModel.warnflag)) {
                if ([_orderdetailModel.warnflag integerValue] >= 3) {
                    _outTimeBtn.backgroundColor = GrayTitleColor;
                    _outTimeBtn.enabled = NO;
                    _outTimeLabel.hidden = YES;
                }else{
                    _outTimeLabel.hidden = NO;
                    [_outTimeBtn setBackgroundColor:NavBarItemColor];
                    _outTimeBtn.enabled = YES;
                }
            }
        }
    }else{
        _outTimeLabel.hidden = YES;
        _outTimeBtn.enabled = NO;
        [_outTimeBtn setBackgroundColor:GrayTitleColor];
    }
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}



//截取字符串
- (NSString*)changeTxt:(NSString *)text changeTxt:(NSString *)change
{
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableString * muStr = [NSMutableString stringWithString:text];
        [muStr deleteCharactersInRange:NSMakeRange(location, length)];
        //赋值
        return muStr;
    }else{
        return text;
    }
}

- (void)leftSegBtnClick:(UIButton*)sender
{
    //切换ui
    sender.titleLabel.textColor = NavBarItemColor;
    _leftSegLine.backgroundColor = NavBarItemColor;
    _rightSegBtn.titleLabel.textColor = [UIColor blackColor];
    _rightSegLine.backgroundColor = [UIColor clearColor];
    [_groundSView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightSegBtnClick:(UIButton*)sender
{
    //切换ui
    sender.titleLabel.textColor = NavBarItemColor;
    _rightSegLine.backgroundColor = NavBarItemColor;
    _leftSegBtn.titleLabel.textColor = [UIColor blackColor];
    _leftSegLine.backgroundColor = [UIColor clearColor];
    [_groundSView setContentOffset:CGPointMake(mScreenWidth, 0) animated:YES];
    [self isOutTime];
    
}

- (void)selectAddBtnClick:(UIButton *)sender
{
    NSLog(@"==点击了地址选择按钮==");
}

- (void)footBtnClick:(UIButton*)sender
{
    [_grayView showView];
    [self createExiteOrderUI];
}

- (UIView*)createExiteOrderUI
{
    if (_myAleareView == nil) {
        _myAleareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _myAleareView.backgroundColor = [UIColor clearColor];
        //        [APPDelegate.window addSubview:_myAleareView];
        [self.view addSubview:_myAleareView];
        
        UIView* grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myAleareView.width, _myAleareView.height)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleareView addSubview:grayView];
        grayView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closemyAleartViewTap:)];
        [grayView addGestureRecognizer:tap];
        
        windowView = [[UIImageView alloc]initWithFrame:CGRectMake(40, (_myAleareView.height - 260)/2, _myAleareView.width- 80, 260)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        windowView.layer.masksToBounds = YES;
        windowView.layer.cornerRadius = 5.0;
        [_myAleareView addSubview:windowView];
        
        UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, 30)];
        titleView.backgroundColor = [UIColor grayColor];
        [windowView addSubview:titleView];
        UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(titleView.width - 60, 0, 60, titleView.height);
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [windowView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat gap = 5;
        _aleartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, titleView.bottom+5, windowView.width, windowView.width/3+10)];
        _aleartScrollView.contentSize = CGSizeMake((windowView.width/5+gap*2)*_proDataArray.count, _aleartScrollView.height);
        _aleartScrollView.delegate = self;
        [windowView addSubview:_aleartScrollView];
        UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = gap;
        flow.minimumInteritemSpacing = gap;
        _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, (windowView.width/5+gap*2)*_proDataArray.count, windowView.width/3)collectionViewLayout:flow];
        _collView.contentSize = CGSizeMake((windowView.width/5+gap*2)*_proDataArray.count, _collView.height);
        _collView.backgroundColor = [UIColor clearColor];
        _collView.delegate = self;
        _collView.dataSource = self;
        _collView.scrollEnabled = NO;
        _collView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
        [_aleartScrollView addSubview:_collView];
        [_collView registerNib:[UINib nibWithNibName:@"ExiteOrderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ExiteOrderCollectionViewCellID"];
        
        UIView* deleteView=[[UIView alloc]initWithFrame:CGRectMake(0, _aleartScrollView.bottom, windowView.width, 30)];
        deleteView.backgroundColor = [UIColor blackColor];
        [windowView addSubview:deleteView];
//        _deSelectImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 20, 30)];
//        _deSelectImg.contentMode = UIViewContentModeScaleAspectFit;
//        _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
//        [deleteView addSubview:_deSelectImg];
//        UILabel *deSelectTitle = [[UILabel alloc] initWithFrame:CGRectMake(_deSelectImg.right, 0, 30, 30)];
//        deSelectTitle.font = [UIFont systemFontOfSize:12];
//        deSelectTitle.textColor = [UIColor whiteColor];
//        deSelectTitle.text = @"全选";
//        [deleteView addSubview:deSelectTitle];
//        UIButton *deAllSelect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        deAllSelect.frame = CGRectMake(0, 0, 100, 30);
//        [deAllSelect addTarget:self action:@selector(deAllSelect:) forControlEvents:UIControlEventTouchUpInside];
//        [deleteView addSubview:deAllSelect];
        
/*
        这里计算申请退货合计的金额
 */
        double totlemoney = 0.00;
        for (int i = 0 ; i < _dataArray.count ; i++) {
            [_selectIndexArr addIndex:i];
            NSIndexPath * selIndex = [NSIndexPath indexPathForRow:i inSection:0];
            [_collView selectItemAtIndexPath:selIndex animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            OrderManageListModel* model = _dataArray[i];
            
            double price = [model.saleprice doubleValue];
            NSInteger count = [model.count integerValue];
            totlemoney = totlemoney + price*count;
            
        }
        
        UILabel *totalTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 30)];
        totalTitle.text = @"合计: ¥";
        totalTitle.textColor = [UIColor whiteColor];
        totalTitle.font = [UIFont systemFontOfSize:14];
        [deleteView addSubview:totalTitle];
        //合计的金额
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(totalTitle.right+10, 0, mScreenWidth - 200, 30)];
        _totalLabel.font = [UIFont systemFontOfSize:14];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.text = [NSString stringWithFormat:@"%.2f",totlemoney];
        [deleteView addSubview:_totalLabel];

        
        _noteTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, deleteView.bottom+10, windowView.width - 20, 44)];
        _noteTextField.delegate = self;
        _noteTextField.placeholder = @"退货原因";
        _noteTextField.keyboardType = UIKeyboardTypeASCIICapable;
        [windowView addSubview:_noteTextField];
        
        
        UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 5.0;
        sureBtn.frame = CGRectMake(20, windowView.height - 50, windowView.width - 40, 40);
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.backgroundColor = NavBarItemColor;
        [windowView addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(surePhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _myAleareView;
    
}

- (void)closemyAleartViewTap:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

- (void)closeBtnClick:(UIButton*)sender
{
    [_grayView hideView];
    [_myAleareView removeFromSuperview];
    _myAleareView = nil;
}

//- (void)deAllSelect:(UIButton*)sender
//{
//    if (_isSelectAll == YES) {
//         //取消全部选中
//        [_selectIndexArr removeAllIndexes];
//        _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
//        [_collView reloadData];
//        _totalLabel.text = @"0.00";
//        _isSelectAll = NO;
//    }else{
//        //全部选中
//        double totlemoney = 0.00;
//        for (int i = 0 ; i < _dataArray.count ; i++) {
//            [_selectIndexArr addIndex:i];
//            NSIndexPath * selIndex = [NSIndexPath indexPathForRow:i inSection:0];
//            [_collView selectItemAtIndexPath:selIndex animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//            OrderManageListModel* model = _dataArray[i];
//            
//            double price = [model.saleprice doubleValue];
//            NSInteger count = [model.count integerValue];
//            totlemoney = totlemoney + price*count;
//            
//        }
//        _totalLabel.text = [NSString stringWithFormat:@"%.2f",totlemoney];
//        _isSelectAll = YES;
//        _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
//    }
//}

- (void)surePhoneBtnClick:(UIButton*)sender
{
    NSLog(@"_selectIndexArr-----%@",_selectIndexArr);
    if (_dataArray.count!=0) {
        NSInteger isgolds = 0;
        for (int i = 0; i < _dataArray.count; i++) {
            OrderManageListModel* model = _dataArray[i];
            if ([model.isgolds integerValue] == 1) {
                //金币商城
                isgolds++;
            }
        }
        if (_selectIndexArr.count!=0) {
            //isgolds用来表示都是积分商城的商品，或者不都是积分商城的商品
            if (_dataArray.count == isgolds) {
                [self goldAddExiteOrderRequestData:sender];
            }else{
                [self addExiteOrderRequestData:sender];
            }
        }else{
            [self showAlert:@"请选择商品"];
        }
    }
}


- (void)delectBtnClick:(UIButton*)sender
{
    
}

#pragma mark collectionViewDatasource
//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (IsEmptyValue(_dataArray)) {
        return 0;
    }else{
        return _dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    //    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    static NSString *HomeSelarCellID = @"ExiteOrderCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"ExiteOrderCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    ExiteOrderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    if (_dataArray.count!=0) {
        OrderManageListModel* model = _dataArray[indexPath.item];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
        cell.titleLabel.text = [NSString stringWithFormat:@"名称:%@",model.proname];
        if ([model.isgolds integerValue] == 1) {
            if (!IsEmptyValue1(model.saleprice)) {
                cell.priceLabel.text = [NSString stringWithFormat:@"金币%@",model.saleprice];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"金币0"];
            }
            
        }else{
            if (!IsEmptyValue1(model.saleprice)) {
                model.saleprice = [NSString stringWithFormat:@"%@",model.saleprice];
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.saleprice doubleValue]];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"￥0"];
            }
        }
        if (!IsEmptyValue1(model.count)) {
            cell.saleLabel.text = [NSString stringWithFormat:@"数量:%@",model.count];
        }else{
            cell.saleLabel.text = [NSString stringWithFormat:@"数量:0"];
        }

    }
//    if (cell.selected) {
//        cell.backgroundColor = [UIColor redColor];
//    }else{
//        cell.backgroundColor = [UIColor clearColor];
//    }
//    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        return cell;
}
#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"单元格的大小%f,,%f",windowView.width/5, windowView.width/3);
    return  CGSizeMake(windowView.width/5, windowView.width/3);
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"select item at indexPath: %@",indexPath);
//    if (_dataArray.count!=0) {
//        [_selectIndexArr addIndex:indexPath.item];
//        NSArray* array = [_dataArray objectsAtIndexes:_selectIndexArr];
//        double totlemoney = 0.00;
//        for (int i = 0; i < array.count; i++) {
//            OrderManageListModel* model = array[i];
//            double price = [model.saleprice doubleValue];
//            NSInteger count = [model.count integerValue];
//            totlemoney = totlemoney + price*count;
//        }
//        _totalLabel.text = [NSString stringWithFormat:@"%.2f",totlemoney];
//        if (_dataArray.count == array.count) {
//            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
//        }else{
//            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
//        }
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Deselect item at indexPath: %@",indexPath);
//    [_selectIndexArr removeIndex:indexPath.item];
//    NSArray* array = [_dataArray objectsAtIndexes:_selectIndexArr];
//    double totlemoney = 0.00;
//    for (int i = 0; i < array.count; i++) {
//        OrderManageListModel* model = array[i];
//        double price = [model.saleprice doubleValue];
//        NSInteger count = [model.count integerValue];
//        totlemoney = totlemoney + price*count;
//    }
//    _totalLabel.text = [NSString stringWithFormat:@"%.2f",totlemoney];
//    if (_dataArray.count == array.count) {
//        _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
//    }else{
//        _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
//    }
}


- (void)outTimeBtnClick:(UIButton*)sender
{
    /*
     /order/timeOutWarn.do
     mobile:true
     data{
     orderno
     }
     */
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/timeOutWarn.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",_orderdetailModel.orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/timeOutWarn.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"超时提醒成功"];
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
            [self showAlert:@"超时提醒失败"];
        }else{
            [self showAlert:str];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
    }];

}

- (void)SearchOrderRequest
{
    /*
     /order/searchOrderDetail.do
     data{
     orderno:订单编号
     }
     */
    [_hud show:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderNo];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"searchOrder.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"searchOrderDetail.do%@",array);
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    _orderdetailModel = [[OrderManageListModel alloc]init];
                    [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:_orderdetailModel];
                }
                [self tbViewcellDataRequest];
            }
            [_tbView reloadData];
            [_sendTbView reloadData];

        }
    } fail:^(NSError *error) {
        [_hud hide:YES];
    }];
}

- (void)addExiteOrderRequestData:(UIButton*)sender
{
    /*
     /send/addExiteOrder.do
     mobile:true
     data{
     custid,
     custname,
     custphone,
     linkerid,///订单的分销人（新增）
     isgolds,//是否是积分商城的订单（新增）
     orderno,
     exitecount,
     exitmoney,
     note,退货原因
     provinceid,定位地址
     cityid,定位地址
     areaid,定位地址
     provinceidadd,收货地址
     cityidadd,收货地址
     areaidadd,收货地址
     serviceidadd,收货地址
     villageidadd,收货地址
     communityid
     roomnumberid
     exiteaddress,
     prolist:[{
     proid,
     proname,
     prono,
     specification,
     prounitid,
     prounitname,
     exitecount,
     exitemoney,
     saleprice,
     orderid//订单的id
     }]
     }
     */
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
//#warning mark provinceid&cityid&areaid
    sender.enabled = NO;
    [_hud show:YES];
    _orderdetailModel.custid = [self convertNull:_orderdetailModel.custid];
    _orderdetailModel.custname = [self convertNull:_orderdetailModel.custname];
    _orderdetailModel.provinceid = [self convertNull:_orderdetailModel.provinceid];
    _orderdetailModel.cityid = [self convertNull:_orderdetailModel.cityid];
    _orderdetailModel.areaid = [self convertNull:_orderdetailModel.areaid];
    _orderdetailModel.serviceid = [self convertNull:_orderdetailModel.serviceid];
    _orderdetailModel.villageid = [self convertNull:_orderdetailModel.villageid];
    _orderdetailModel.receiveraddr = [self convertNull:_orderdetailModel.receiveraddr];
    _orderdetailModel.ordercount = [self convertNull:_orderdetailModel.ordercount];
    _orderdetailModel.ordermoney = [self convertNull:_orderdetailModel.ordermoney];
    _orderdetailModel.pickupway = [self convertNull:_orderdetailModel.pickupway];
    _orderdetailModel.online1 = [self convertNull:_orderdetailModel.online1];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/addExiteOrder.do"];
    NSArray* array = [_dataArray objectsAtIndexes:_selectIndexArr];
    NSMutableString* prolist = [[NSMutableString alloc]init];
    double totlemoney = 0.00;
    NSInteger count = 0;
    for (int i = 0; i < array.count; i++) {
        OrderManageListModel* model = _dataArray[i];
        model.proid = [self convertNull:model.proid];
        model.proname = [self convertNull:model.proname];
        model.prono = [self convertNull:model.prono];
        model.specification = [self convertNull:model.specification];
        model.prounitid = [self convertNull:model.prounitid];
        model.prounitname = [self convertNull:model.prounitname];
        model.money = [self convertNull:model.money];
        model.count = [self convertNull:model.count];
        model.saleprice = [self convertNull:model.saleprice];
        
        double price = [model.saleprice doubleValue];
        count = [model.count integerValue];
        totlemoney = totlemoney + price*count;
        
//        totlemoney = totlemoney + [model.money floatValue];
        NSLog(@"Model返回的count是多少呢======%ld",count);
        count = count+ [model.count intValue];
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"exitecount\":\"%@\",\"exitemoney\":\"%@\",\"saleprice\":\"%@\",\"orderid\":\"%@\"},",model.proid,model.proname,model.prono,model.specification,model.prounitid,model.prounitname,model.count,model.money,model.saleprice,_orderdetailModel.Id];
        [prolist appendString:str];
    }
    NSString* prostr = prolist;
    if (prostr.length!=0) {
        NSRange range = {0,prostr.length - 1};
        prostr = [prostr substringWithRange:range];
    }
//    _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"linkerid\":\"%@\",\"isgolds\":\"0\",\"orderno\":\"%@\",\"exitecount\":\"%ld\",\"exitmoney\":\"%.2f\",\"note\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"provinceidadd\":\"%@\",\"cityidadd\":\"%@\",\"areaidadd\":\"%@\",\"serviceidadd\":\"%@\",\"villageidadd\":\"%@\",\"communityid\":\"%@\",\"roomnumberid\":\"%@\",\"exiteaddress\":\"%@\",\"pickupway\":\"%@\",\"online1\":\"%@\",\"prolist\":[%@]}",_orderdetailModel.custid,_orderdetailModel.custname,_orderdetailModel.custphone,_orderdetailModel.distributeid,_orderdetailModel.orderno,count,totlemoney,_noteTextField.text,provinceid,cityid,areaid,_orderdetailModel.provinceid,_orderdetailModel.cityid,_orderdetailModel.areaid,_orderdetailModel.serviceid,_orderdetailModel.villageid,_orderdetailModel.communityid,_orderdetailModel.roomnumberid,_orderdetailModel.receiveraddr,_orderdetailModel.pickupway,_orderdetailModel.online1,prostr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/addExiteOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"status"] integerValue] == 200) {
                [_grayView hideView];
                [_myAleareView removeFromSuperview];
                _myAleareView = nil;
                [self showAlert:@"添加退货单成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if ([str rangeOfString:@"false"].location != NSNotFound) {
                    if (!IsEmptyValue(dict)) {
                        [self showAlert:[NSString stringWithFormat:@"%@",dict[@"false"]]];
                    }
                }
            }
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [_hud hide:YES];
    }];
}

//积分商城的商品的退货
- (void)goldAddExiteOrderRequestData:(UIButton*)sender
{
/*
 /gold/addExiteOrder.do
 */
    sender.enabled = NO;
    [_hud show:YES];
    _orderdetailModel.custid = [self convertNull:_orderdetailModel.custid];
    _orderdetailModel.custname = [self convertNull:_orderdetailModel.custname];
    _orderdetailModel.provinceid = [self convertNull:_orderdetailModel.provinceid];
    _orderdetailModel.cityid = [self convertNull:_orderdetailModel.cityid];
    _orderdetailModel.areaid = [self convertNull:_orderdetailModel.areaid];
    _orderdetailModel.serviceid = [self convertNull:_orderdetailModel.serviceid];
    _orderdetailModel.villageid = [self convertNull:_orderdetailModel.villageid];
    _orderdetailModel.receiveraddr = [self convertNull:_orderdetailModel.receiveraddr];
    _orderdetailModel.ordercount = [self convertNull:_orderdetailModel.ordercount];
    _orderdetailModel.ordermoney = [self convertNull:_orderdetailModel.ordermoney];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/gold/addExiteOrder.do"];
    NSArray* array = [_dataArray objectsAtIndexes:_selectIndexArr];
    NSMutableString* prolist = [[NSMutableString alloc]init];
    double totlemoney = 0.00;
    long int count = 0;
    for (int i = 0; i < array.count; i++) {
        OrderManageListModel* model = _dataArray[i];
        model.proid = [self convertNull:model.proid];
        model.proname = [self convertNull:model.proname];
        model.prono = [self convertNull:model.prono];
        model.specification = [self convertNull:model.specification];
        model.prounitid = [self convertNull:model.prounitid];
        model.prounitname = [self convertNull:model.prounitname];
        model.money = [self convertNull:model.money];
        model.count = [self convertNull:model.count];
        model.saleprice = [self convertNull:model.saleprice];
        totlemoney = totlemoney + [model.money doubleValue];
        count = count + [model.count integerValue];
        NSString* str = [NSString stringWithFormat:@"{\"proid\":\"%@\",\"proname\":\"%@\",\"prono\":\"%@\",\"specification\":\"%@\",\"prounitid\":\"%@\",\"prounitname\":\"%@\",\"exitecount\":\"%@\",\"exitemoney\":\"%@\",\"saleprice\":\"%@\"},",model.proid,model.proname,model.prono,model.specification,model.prounitid,model.prounitname,model.count,model.money,model.saleprice];
        [prolist appendString:str];
    }
    NSString* prostr = prolist;
    NSRange range = {0,prostr.length - 1};
    prostr = [prostr substringWithRange:range];
    //    _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\",\"custname\":\"%@\",\"custphone\":\"%@\",\"linkerid\":\"%@\",\"isgolds\":\"1\",\"orderno\":\"%@\",\"exitecount\":\"%li\",\"exitmoney\":\"%.2f\",\"note\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"serviceid\":\"%@\",\"villageid\":\"%@\",\"exiteaddress\":\"%@\",\"prolist\":[%@]}",_orderdetailModel.custid,_orderdetailModel.custname,_orderdetailModel.custphone,_orderdetailModel.distributeid,_orderdetailModel.orderno,(long)count,totlemoney,_noteTextField.text,_orderdetailModel.provinceid,_orderdetailModel.cityid,_orderdetailModel.areaid,_orderdetailModel.serviceid,_orderdetailModel.villageid,_orderdetailModel.receiveraddr,prostr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/gold/addExiteOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"添加退货单成功"];
            sender.enabled = NO;
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [_hud hide:YES];
    }];
}





@end
