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
#import "ReturnZbarViewController.h"
#import "MBProgressHUD.h"
//#import "ExiteOrderModel.h"
#import "ExiteDetailModel.h"
#import "OrderDetailProTbViewModel.h"

@interface ReturnDetailViewController ()<UITableViewDelegate,UITableViewDataSource,OrderDetailNameDelegate,UIScrollViewDelegate,BMKGeoCodeSearchDelegate>
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
    NSString* _zbarStatus;
    MBProgressHUD* _hud;
    NSMutableArray* _proDataArray;
    NSString* _addressStr;
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)ExiteDetailModel* detailModel;

@end

@implementation ReturnDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self locate];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _proDataArray = [[NSMutableArray alloc]init];
    self.title = @"订单详情";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
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
    UIButton* footBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    footBtn.frame = CGRectMake(footerView.right - 90, 10, 70, 30) ;
    [footBtn setTitle:@"退货完成" forState:UIControlStateNormal];
    [footBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    footBtn.layer.masksToBounds = YES;
    footBtn.layer.cornerRadius = 5.0;
    [footBtn setBackgroundColor:NavBarItemColor];
    [footerView addSubview:footBtn];
    [footBtn addTarget:self action:@selector(endReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    footerView.backgroundColor = BackGorundColor;
    UIButton* delectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    delectBtn.frame = CGRectMake(20, 10, 70, 30);
    [delectBtn setBackgroundColor:[UIColor clearColor]];
    [delectBtn setTitle:@"开始退货" forState:UIControlStateNormal];
    delectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    delectBtn.layer.masksToBounds = YES;
    delectBtn.layer.cornerRadius = 5.0;
    CALayer *layer = [delectBtn layer];
    layer.borderColor = NavBarItemColor.CGColor;
    layer.borderWidth = .5f;
    [delectBtn setTitleColor:NavBarItemColor forState:UIControlStateNormal];
    [footerView addSubview:delectBtn];
    [delectBtn addTarget:self action:@selector(startReturnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    footBtn.hidden = YES;
    delectBtn.hidden = YES;
    if (!IsEmptyValue(self.sendstatus)) {
        if ([self.sendstatus integerValue] == 1) {
            footBtn.hidden = YES;
            delectBtn.hidden = YES;
        }else if ([self.sendstatus integerValue] == 2){
            delectBtn.hidden = YES;
            footBtn.hidden = NO;
        }else if ([self.sendstatus integerValue] == 0){
            delectBtn.hidden = NO;
            footBtn.hidden = YES;
        }
    }else{
        footBtn.hidden = YES;
        delectBtn.hidden = YES;
    }
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
        
    }else{
        return 100;
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
            if (!IsEmptyValue(_dataArray)) {
                double totalmoney = 0.00;
                for (ExiteDetailModel* model in _dataArray) {
                    totalmoney = totalmoney+[model.exitemoney doubleValue];
                }
                priceCell.orderPriceLabel.text = [NSString stringWithFormat:@"钱数：%.2f",totalmoney];
                priceCell.orderPayLabel.text = [NSString stringWithFormat:@"实付款：%.2f",totalmoney];
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
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        
    }else{
        
    }
}
#pragma mark - 定位
- (void)locate
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //上传经纬度获取
    self.lblLongitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.lblLatitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    //停止定位服务
    _loc = coordinate;
    [_locService stopUserLocationService];
    [self outputAdd];
    
    //定位显示点
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = _loc;
    annotation.title = @"我的位置";
    [_mapView setCenterCoordinate:_loc];
    [_mapView addAnnotation:annotation];
}

- (BMKGeoCodeSearch *)geoCode
{
    if (!_geoCode) {
        _geoCode = [[BMKGeoCodeSearch alloc] init];
        _geoCode.delegate = self;
    }
    return _geoCode;
}

- (void)outputAdd
{
    // 初始化反地址编码选项（数据模型）
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    // 将TextField中的数据传到反地址编码模型
    option.reverseGeoPoint = CLLocationCoordinate2DMake([self.lblLatitude floatValue], [self.lblLongitude floatValue]);
    NSLog(@"reverseGeoPoint%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    // 调用反地址编码方法，让其在代理方法中输出
    [self.geoCode reverseGeoCode:option];
}

#pragma mark 代理方法返回反地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (result) {
        NSLog(@"标志性建筑 - - - -- - - %@",result);
        NSLog(@"%@ - %@", result.address, result.addressDetail.streetNumber);
        _addressStr = [NSString stringWithFormat:@"%@",result.address];
        //        if (result.addressDetail.province.length!=0) {
        //            [_addressDict setObject:result.addressDetail.province forKey:@"province"];
        //        }
        //        if (result.addressDetail.city.length!=0){
        //            [_addressDict setObject:result.addressDetail.city forKey:@"city"];
        //        }
        //        if (result.addressDetail.district.length!=0){
        //            [_addressDict setObject:result.addressDetail.district forKey:@"district"];
        //        }
        //        if (result.poiList.count != 0) {
        //            BMKPoiInfo *poiInfo = result.poiList[0];
        //            NSLog(@"标志性建筑:%@  ",poiInfo.city);
        //            NSString* text = [self changeTxt:poiInfo.city changeTxt:@"市"];
        //            if (text.length!=0) {
        //                [[NSUserDefaults standardUserDefaults]setObject:text forKey:CITYNAME];
        //                [_leftBtn setTitle:text forState:UIControlStateNormal];
        //            }
        //        }
        
    }else{
        NSLog(@"找不到相对应的位置信息");
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

- (void)endReturnBtnClick:(UIButton*)sender
{
//    _zbarStatus = @"1";
//    if(IOS7)
//    {
//        ReturnZbarViewController * rt = [[ReturnZbarViewController alloc]init];
//        [rt setTransVaule:^(NSString * code) {
//           
//        }];
//        [self presentViewController:rt animated:YES completion:^{
//            
//        }];
//    }
//    else
//    {
//        [self scanBtnAction];
//    }
    [self sendExiteProductRequest:sender];
}

- (void)startReturnBtnClick:(UIButton*)sender
{
//    _zbarStatus = @"0";
//    if(IOS7)
//    {
//        ReturnZbarViewController * rt = [[ReturnZbarViewController alloc]init];
//        [self presentViewController:rt animated:YES completion:^{
//        }];
//    }
//    else
//    {
//        [self scanBtnAction];
//    }
    [self sendBeginExiteProductRequestData:sender];
}

#pragma mark --------二维码扫描-------
- (void)checkAVAuthorizationStatus
{
    if (IOS7) {
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        //    NSString *tips = NSLocalizedString(@"AVAuthorization", @"您没有权限访问相机");
        if(status == AVAuthorizationStatusAuthorized) {
            // authorized
            [self scanBtnAction];
        } else if (status == AVAuthorizationStatusNotDetermined) {
            //            if ([AVCaptureDevice instancesRespondToSelector:@selector(requestAccessForMediaType:completionHandler:)]) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    [self scanBtnAction];
                }else{
                    [self showAlert:@"用户拒绝申请"];
                }
                
            }];
            //            }else{
            //                [self showAlert:@"拒绝"];
            //            }
        } else if (status == AVAuthorizationStatusDenied) {
            [self showAlert:@"用户关闭了权限"];
            AVAuthorizationStatus status1 = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status1 == AVAuthorizationStatusAuthorized) {
                [self scanBtnAction];
            }
        } else if(status == AVAuthorizationStatusRestricted){
            [self showAlert:@"您没有权限访问相机"];
        }
        
    }else{
        [self scanBtnAction];
    }
}
- (void)scanBtnAction
{
    oldnum = 0;
    oldupOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    oldtimer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self presentViewController:reader animated:YES completion:^{
        
    }];
    
}

-(void)animation1
{
    if (oldupOrdown == NO) {
        oldnum ++;
        _line.frame = CGRectMake(30, 10+2*oldnum, 220, 2);
        if (2*oldnum == 260) {
            oldupOrdown = YES;
        }
    }
    else {
        oldnum --;
        _line.frame = CGRectMake(30, 10+2*oldnum, 220, 2);
        if (oldnum == 0) {
            oldupOrdown = NO;
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [oldtimer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    oldnum = 0;
    oldupOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [oldtimer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    oldnum = 0;
    oldupOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        if ([_zbarStatus integerValue] == 0) {
            NSLog(@"开始退货%@",result);
        }else if([_zbarStatus integerValue] == 1){
            NSLog(@"退货完成%@",result);
        }
        
        
    }];
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
//    self.exiteno = [self convertNull:self.exiteno];
//    NSString* datastr = [NSString stringWithFormat:@"{\"page\":\"1\",\"rows\":\"1\",\"exiteno\":\"%@\"}",self.exiteno];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/searchExiteOrderDetail.do%@",str);
//        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
//        NSArray* array = dict[@"list"];
//        [_dataArray removeAllObjects];
//        if (array.count!=0) {
//            for (int i = 0; i < array.count; i++) {
//                _orderdetailModel = [[ExiteOrderModel alloc]init];
//                [_orderdetailModel setValuesForKeysWithDictionary:array[i]];
//                [_dataArray addObject:_orderdetailModel];
//            }
//            [self tbViewcellDataRequest];
//        }
//        [_tbView reloadData];
//        [_sendTbView reloadData];
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

    } failureBlock:^(NSError *error) {
        [_hud hide:YES];
    }];
    
}


- (void)tbViewcellDataRequest
{
    [_proDataArray removeAllObjects];
    for (int i =0; i < _dataArray.count; i++) {
        ExiteDetailModel* promodel = _dataArray[i];
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

- (void)sendBeginExiteProductRequestData:(UIButton*)sender
{
    /*
     /send/sendBeginExiteProduct.do
     mobile:true
     data{
         exiteno
         longitude经度
         latitude纬度
         senderid
         sendaddress
     }
     */
    sender.enabled = NO;
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    _orderdetailModel.exiteno = [self convertNull:_orderdetailModel.exiteno];
    NSString* longitude = [[NSUserDefaults standardUserDefaults]objectForKey:LBLLONGITUDE];
    longitude = [self convertNull:longitude];
    NSString* latitude = [[NSUserDefaults standardUserDefaults]objectForKey:LBLLATITUDE];
    latitude = [self convertNull:latitude];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/sendBeginExiteProduct.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"exiteno\":\"%@\",\"longitude\":\"%@\",\"latitude\":\"%@\",\"senderid\":\"%@\",\"sendaddress\":\"%@\"}",_orderdetailModel.exiteno,longitude,latitude,userid,_addressStr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:[NSString stringWithFormat:@"%@%@",_orderdetailModel.exiteno,sender.titleLabel.text]];
            sender.hidden = YES;
            _orderdetailModel.sendstatus = @"2";
            [_sendTbView reloadData];
//            [self dataRequest];
        }else{
            [self showAlert:str];
        }
        
    } failureBlock:^(NSError *error) {
        sender.enabled = YES;
    }];
    
    
}

- (void)sendExiteProductRequest:(UIButton*)sender
{
/*
 /send/sendExiteProduct.do
 mobile:true
 data{
     exiteno
     longitude
     latitude
     custid     订单中的custid
     orderno    退货单中的订单号
     isgolds    是否是积分商城
    sendaddress
 }
 */
    sender.enabled = NO;
    NSString* custid = [self convertNull:_orderdetailModel.custid];
    _orderdetailModel.exiteno = [self convertNull:_orderdetailModel.exiteno];
    _orderdetailModel.orderno = [self convertNull:_orderdetailModel.orderno];
    _orderdetailModel.isgolds = [self convertNull:_orderdetailModel.isgolds];
    NSString* longitude = [[NSUserDefaults standardUserDefaults]objectForKey:LBLLONGITUDE];
    longitude = [self convertNull:longitude];
    NSString* latitude = [[NSUserDefaults standardUserDefaults]objectForKey:LBLLATITUDE];
    latitude = [self convertNull:latitude];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/send/sendExiteProduct.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"exiteno\":\"%@\",\"longitude\":\"%@\",\"latitude\":\"%@\",\"custid\":\"%@\",\"orderno\":\"%@\",\"isgolds\":\"%@\",\"sendaddress\":\"%@\"}",_orderdetailModel.exiteno,longitude,latitude,custid,_orderdetailModel.orderno,_orderdetailModel.isgolds,_addressStr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    
    [DataPost requestAFWithUrl:urlstr params:parmas finishDidBlock:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/send/sendExiteProduct.do%@",str);
        if ([str rangeOfString:@"true"].location != NSNotFound) {
            [self showAlert:[NSString stringWithFormat:@"%@%@",_orderdetailModel.exiteno,sender.titleLabel.text]];
            sender.hidden = YES;
            _orderdetailModel.sendstatus = @"1";
            [_sendTbView reloadData];
//            [self dataRequest];
        }else{
            [self showAlert:str];
        }
        
    } failureBlock:^(NSError *error) {
        sender.enabled = YES;
    }];
    
}





@end
