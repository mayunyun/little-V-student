//
//  AddressManageViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddressManageTableViewCell.h"
#import "AddressManageModel.h"
#import "AddReceiveAddressViewController.h"
#import "AddNewAddressViewController.h"
#import "EditAddressVC.h"
#import "AddEcodeXVNewAddressViewController.h"
#import "AddressDetailViewController.h"
#import "LoginNewViewController.h"
#import "MBProgressHUD.h"
#import "ZBarReaderViewController.h"//二维码
#import "ORCodeViewController.h"
#import "InviteCodeAddrModel.h"

@interface AddressManageViewController ()<UITableViewDelegate,UITableViewDataSource,ZBarReaderDelegate>
{
    UITableView* _tbView;
    NSInteger _page;
    MBProgressHUD* _hud;
    
    int oldnum;
    BOOL oldupOrdown;
    NSTimer * oldtimer;
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic, strong) UIImageView * line;//二维码

@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarImgButtonTarget:self action:@selector(rightBarClick:) imgname:@"addressadd"];
    _dataArray = [[NSMutableArray alloc]init];
    [self creatUI];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dataRequest];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
//    AddReceiveAddressViewController* addVC = [[AddReceiveAddressViewController alloc]
//                                              init];
//    [self.navigationController pushViewController:addVC animated:YES];
    if(IOS7)
    {
        ORCodeViewController * rt = [[ORCodeViewController alloc]init];
        [rt setTransVaule:^(NSString *code) {
            NSString* result = [self inviteCodeDeal:code];
            if (!IsEmptyValue(result)) {
                [self inviteCodegetAddressRequestData:result];
            }else{
                [self showAlert:@"分销不存在"];
            }
        }];
        [self presentViewController:rt animated:YES completion:^{
            
        }];
    }
    else
    {
        [self checkAVAuthorizationStatus];
    }

}

- (void)creatUI
{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, mScreenWidth, mScreenHeight - 64)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
//    _tbView.bounces = NO;
    _tbView.showsHorizontalScrollIndicator = YES;
    _tbView.showsVerticalScrollIndicator = YES;
    _tbView.tableHeaderView.height = 5;
    _tbView.scrollsToTop = YES;
    _tbView.tableHeaderView.backgroundColor = BackGorundColor;
    _tbView.rowHeight = 80;
    [self.view addSubview:_tbView];

    //下拉刷新
    _tbView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        if (!IsEmptyValue(_dataArray)) {
            [_dataArray removeAllObjects];
        }
        [self dataRequest];
        // 结束刷新
        [_tbView.mj_header endRefreshing];
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddressManageTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddressManageTableViewCell" owner:self options:nil]firstObject];
    }
    if (_dataArray.count!=0) {
        if (_dataArray.count!=0) {
            AddressManageModel* model = _dataArray[indexPath.section];
            model.provincename = [self convertNull:model.provincename];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.provincename];
            cell.proLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",model.provincename,model.cityname,model.areaname,model.servincename,model.doornumbername,model.comunity,model.roomnumber,model.address];
            if ([model.isdefault integerValue] == 1) {
                cell.addDetailLabel.text = @"默认地址";
            }else{
                cell.addDetailLabel.text = @"非默认地址";
            }
            
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma 传值没有判断哦
    EditAddressVC* detailVC = [[EditAddressVC alloc]init];
    if (_dataArray.count!=0) {
        InviteCodeAddrModel* model =_dataArray[indexPath.section];
        AddressManageModel * addmodel = _dataArray[indexPath.section];
        detailVC.selectAddModel = model;
        detailVC.addModel = addmodel;
        
    }
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)dataRequest
{
    /*
     /login/appSearchCustAddr.do
     custid:客户id
     mobile = true,
     */
    [_hud show:YES];
    [_dataArray removeAllObjects];
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/appSearchCustAddr.do"];
    NSMutableDictionary* parmas = [[NSMutableDictionary alloc]init];
    [parmas setObject:@"true" forKey:@"mobile"];
    [parmas setObject:userid forKey:@"custid"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"查询地址%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"appSearchCustAddr.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
             NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                for (int i = 0; i < array.count; i++) {
                    AddressManageModel* model = [[AddressManageModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_dataArray addObject:model];
                }
                [_tbView reloadData];
            }else{
                [self showAlert:@"查询收货地址列表失败"];
            }
        }
    } fail:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"查询地址失败返回%@",error.localizedDescription);
    }];
    
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
        
        NSLog(@"%@",result);
        NSString* code = [self inviteCodeDeal:result];
        if (!IsEmptyValue(code)) {
            [self inviteCodegetAddressRequestData:code];
        }else{
            [self showAlert:@"分销不存在"];
        }
    }];
}

- (NSString*)inviteCodeDeal:(NSString*)str
{
    if ([str rangeOfString:@"fx"].location != NSNotFound) {
        //删除字符串两端的尖括号
        NSMutableString *mString = [NSMutableString stringWithString:str];
        //删除字符串中的空格
        NSString *str2 = [mString stringByReplacingOccurrencesOfString:@"fx" withString:@""];
        NSLog(@"str2:%@",str2);
        return str2;
    } else {
        return @"";
    }
}
#pragma mark 接口----用邀请码获取到对应的地址
- (void)inviteCodegetAddressRequestData:(NSString*)invitecode
{
    /*
     /login/InviteCodegetAddress.do
     mobile:true
     invitecode:邀请码
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/InviteCodegetAddress.do"];
    NSDictionary* parmas = @{@"mobile":@"true",@"invitecode":invitecode};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/InviteCodegetAddress.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                InviteCodeAddrModel* addrmodel = [[InviteCodeAddrModel alloc]init];
                [addrmodel setValuesForKeysWithDictionary:array[0]];
//                AddNewAddressViewController* addVC = [[AddNewAddressViewController alloc]
//                                                      init];
//                addVC.selectAddModel = addrmodel;
//                [self.navigationController pushViewController:addVC animated:YES];
                AddEcodeXVNewAddressViewController* vc = [[AddEcodeXVNewAddressViewController alloc]init];
                vc.selectAddModel = addrmodel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [self showAlert:@"分销不存在"];
            }
        }
    } fail:^(NSError *error) {
    }];
}


@end
