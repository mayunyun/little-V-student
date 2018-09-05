//
//  OrderDetailReceiveViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailReceiveViewController.h"
#import "OrderDetailTableView.h"
#import "OrderDetailOrdernoTableViewCell.h"
#import "OrderDetailNameTableViewCell.h"
#import "OrderDetailPayTypeTableViewCell.h"
#import "OrderDetailBillTableViewCell.h"
#import "OrderDetailPriceTableViewCell.h"
#import "OrderDetailSendTableViewCell.h"
#import "LoginNewViewController.h"
#import "OrderManageListModel.h"
#import "OrderDetailProTbViewModel.h"
#import "OrderCommentsListViewController.h"

#import "OrderManageViewController.h"

#define YJDD @"预计到达:"

@interface OrderDetailReceiveViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailNameDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView* _groundSView;
    UIButton* _leftSegBtn;
    UIView* _leftSegLine;
    UIButton* _rightSegBtn;
    UIView* _rightSegLine;
    UITableView* _tbView;
    UILabel* _willSendDataLabel;
    UILabel* _outTimeLabel;
    UIButton* _outTimeBtn;
    UITableView* _sendTbView;
    NSMutableArray* _proDataArray;
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)OrderManageListModel* orderdetailModel;

@end

@implementation OrderDetailReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self creatUI];
    [self SearchOrderRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray* array = self.navigationController.viewControllers;
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
    [footBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    footBtn.tag = 1001;
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
            //发票信息
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
        if (!IsEmptyValue(_orderdetailModel.sendtime)) {
            _willSendDataLabel.text = [NSString stringWithFormat:@"%@%@",YJDD,[Command sendtimeChangeData:_orderdetailModel.sendtime]];
        }
//        if (!IsEmptyValue(self.sendTime)) {
//            _willSendDataLabel.text = [NSString stringWithFormat:@"%@%@",YJDD,[Command sendtimeChangeData:self.sendTime]];
//        }
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
    UIAlertView* aleartView = [[UIAlertView alloc]initWithTitle:@"确认收货" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    aleartView.tag = 1001;
    [aleartView show];
}


- (void)delectBtnClick:(UIButton*)sender
{

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            //取消
        }else if (buttonIndex == 1){
            //确定
            if (!IsEmptyValue(_orderdetailModel.orderno)) {
                //        _orderdetailModel.orderno = [_orderdetailModel.orderno uppercaseString];
                UIButton* btn = [self.view viewWithTag:1001];
                [self confirmOrderRequestData:btn];
            }
        }
    }
}

- (void)SearchOrderRequest
{
    /*
     /order/searchOrderDetail.do
     data{
     orderno:订单编号
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderDetail.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",self.orderNo];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrderDetail.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"/order/searchOrderDetail.do%@",array);
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
    }];
}

#pragma mark 确认收货接口
- (void)confirmOrderRequestData:(UIButton*)sender
{
    /*
     /send/custConfirmOrder.do
     mobile:true
     data{
     orderno:订单编号
     }
     */
    sender.enabled = NO;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/custConfirmOrder.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"orderno\":\"%@\"}",_orderdetailModel.orderno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/confirmOrder.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/send/confirmOrder.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:@"确认收货成功"];
            //跳评价
            OrderCommentsListViewController* comentVC = [[OrderCommentsListViewController alloc]init];
            comentVC.orderNo = [NSString stringWithFormat:@"%@",_orderdetailModel.orderno];
            comentVC.commentType = typeOrderPay;
            [self.navigationController pushViewController:comentVC animated:YES];
        }else{
            [self showAlert:str];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        
    }];
    
    
}




@end
