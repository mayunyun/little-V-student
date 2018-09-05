//
//  MineViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineCollectionViewCell.h"
#import "MineSetDetailViewController.h"
#import "MySetViewController.h"
#import "MBProgressHUD.h"
#import "OrderManageViewController.h"
#import "MineCollectViewController.h"//我的收藏
#import "PeopleOnLineViewController.h"
#import "AddressManageViewController.h"
#import "BrowseHistoryViewController.h"
#import "SaveSetViewController.h"
#import "OrderDetailReceiveViewController.h"
//#import "LoginViewController.h"
#import "LoginNewViewController.h"
#import "UINavigationBar+PS.h"

#import "GetCustInfoModel.h"
#import "GetCustInfoAddressModel.h"
#import "SearchOrderStateModel.h"
#import <RongIMKit/RongIMKit.h>
#import "OrderTimeOutViewController.h"
#import "OrderManageProViewController.h"
#import "MineNewCollectViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UILabel* _titleLabel;
    UIImageView* _headerImgView;
    UICollectionView* _iconeCollView;
    UIScrollView* _mainScrollView;
}
@property (nonatomic,retain)GetCustInfoModel* custInfoModel;
@property (nonatomic,retain)GetCustInfoAddressModel* addressModel;
@property (nonatomic,strong)NSArray* iconesArr;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _iconesArr = @[@"",@"+100",@"+10",@"+10"];
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _titleLabel.hidden = NO;
    _headerImgView.hidden = NO;
    [self getPersonContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _titleLabel.hidden = YES;
    _headerImgView.hidden = YES;
}


- (void)creatUI
{
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 49)];
    _mainScrollView.backgroundColor = BackGorundColor;
    _mainScrollView.bounces = NO;
    _mainScrollView.contentSize = CGSizeMake(mScreenWidth, 480+45+50);
    [self.view addSubview:_mainScrollView];
    
    UIImageView* headerbgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 110)];
    headerbgView.backgroundColor = COLOR(205, 60, 10, 1);
    [_mainScrollView addSubview:headerbgView];
    UIView* wightView = [[UIView alloc]initWithFrame:CGRectMake(0, headerbgView.bottom, mScreenWidth, 20)];
    wightView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:wightView];
    
    UICollectionViewFlowLayout* iconFlow = [[UICollectionViewFlowLayout alloc]init];
    iconFlow.minimumLineSpacing = 10;
    iconFlow.minimumInteritemSpacing = 5;
    _iconeCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, wightView.bottom, mScreenWidth, 80) collectionViewLayout:iconFlow];
    _iconeCollView.backgroundColor = [UIColor whiteColor];
    _iconeCollView.delegate = self;
    _iconeCollView.dataSource = self;
    [_mainScrollView addSubview:_iconeCollView];
    [_iconeCollView registerNib:[UINib nibWithNibName:@"MineCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MineCollectionViewCellID"];
    UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(headerbgView.left, headerbgView.top, headerbgView.width, headerbgView.height+20)];
    [_mainScrollView addSubview:headerView];
    
    UIView* clearbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, mScreenWidth, 120)];
    clearbgView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:clearbgView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((mScreenWidth- 300)/2 , 10, 300, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    [clearbgView addSubview:_titleLabel];
    //头像
    _headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake((mScreenWidth - 60)/2, _titleLabel.bottom +5, 60, 60)];
    _headerImgView.layer.masksToBounds = YES;
    _headerImgView.layer.cornerRadius = 30.0;
    _headerImgView.userInteractionEnabled = YES;
    _headerImgView.image = [UIImage imageNamed:@"icon-11"];
    [clearbgView addSubview:_headerImgView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick:)];
    [_headerImgView addGestureRecognizer:tap];
    
    UITableView* tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, _iconeCollView.bottom+10, mScreenWidth, 44*6)];
//    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.bounces = NO;
    tbView.delegate = self;
    tbView.dataSource = self;
    [_mainScrollView addSubview:tbView];
    [self setExtraCellLineHidden:tbView];
    
    UIButton* kefuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    kefuBtn.frame = CGRectMake(20, 480+45, mScreenWidth - 40, 44);
    [kefuBtn setTitle:@"客服热线：0538-6118666" forState:UIControlStateNormal];
    [kefuBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_mainScrollView addSubview:kefuBtn];
    [kefuBtn addTarget:self action:@selector(kefuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"MineTableViewCellID";
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:self options:nil]firstObject];
    }
    NSArray* titleArr = @[@"我的收藏",@"在线客服",@"收货地址",@"安全设置",@"浏览历史",@"超时预警"];
    NSArray* imgArr = @[@"icon-22",@"icon-5",@"icon-shouhuo",@"icon-shezhi",@"icon-lishi",@"icon-yujing"];
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //收藏
//        MineCollectViewController* collVC = [[MineCollectViewController alloc]init];
//        [self.navigationController pushViewController:collVC animated:YES];
        MineNewCollectViewController* collVC = [[MineNewCollectViewController alloc]init];
        [self.navigationController pushViewController:collVC animated:YES];
    }else if (indexPath.row == 1){
        //在线客服
        PeopleOnLineViewController* vc = [[PeopleOnLineViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 2){
        //地址
        AddressManageViewController* vc = [[AddressManageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.row == 3){
        //安全设置
        SaveSetViewController* saveVC = [[SaveSetViewController alloc]init];
        [self.navigationController pushViewController:saveVC animated:YES];
    }else if (indexPath.row == 4){
        //浏览历史
        BrowseHistoryViewController* browseVC = [[BrowseHistoryViewController alloc]init];
        [self.navigationController pushViewController:browseVC animated:YES];
    }else if (indexPath.row == 5){
        //超时预警
        OrderTimeOutViewController* vc = [[OrderTimeOutViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((collectionView.width - 60)/5 , 50);
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    //    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    static NSString *HomeSelarCellID = @"MineCollectionViewCellID";
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"MineCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    MineCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    NSArray* titleArr = @[@"全部订单",@"待付款",@"待发货",@"待收货",@"待评价"];
    NSArray* imgArr = @[@"icon-12",@"icon-21",@"icon-23",@"icon-9",@"icon-10"];
    cell.titleLabel.text = titleArr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    if (!IsEmptyValue(_iconesArr)) {
        cell.megLabel.text = _iconesArr[indexPath.row];
    }
//    [self framAdd:cell];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个collectionVIewCell",(long)indexPath.row);
//    OrderManageViewController* manageVC = [[OrderManageViewController alloc]init];
    OrderManageProViewController* manageVC = [[OrderManageProViewController alloc]init];
    manageVC.orderStatusFlag = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    [self.navigationController pushViewController:manageVC animated:YES];
}

//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

//- (void)framAdd:(id)sender
//{
//    CALayer *layer = [sender layer];
//    layer.borderColor = [UIColor lightGrayColor].CGColor;
//    layer.borderWidth = .5f;
//    //    //添加四个边阴影
//    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    //    imageView.layer.shadowOffset = CGSizeMake(0,0);
//    //    imageView.layer.shadowOpacity = 0.5;
//    //    imageView.layer.shadowRadius = 10.0;//给imageview添加阴影和边框
//    //    //添加两个边的阴影
//    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    //    imageView.layer.shadowOffset = CGSizeMake(4,4);
//    //    imageView.layer.shadowOpacity = 0.5;
//    //    imageView.layer.shadowRadius=2.0;
//    
//}

- (void)headerClick:(UITapGestureRecognizer*)tap
{
//    MineSetDetailViewController* setVC = [[MineSetDetailViewController alloc]init];
//    if (!IsEmptyValue(_custInfoModel.phone)) {
//        setVC.addressModel = _addressModel;
//        setVC.custInfoModel = _custInfoModel;
//        [self.navigationController pushViewController:setVC animated:YES];
//    }
    MySetViewController* vc = [[MySetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)kefuBtnClick:(UIButton*)sender{
    
    [self callTel:@"0538-6118666"];
    
}

-(void)callTel:(NSString *)telNum
{
    BOOL isPhone=[self isPhone];
    if(isPhone){
        NSString *telephoneStr = [[NSString alloc] initWithFormat:@"tel://%@", telNum];
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:telephoneStr];// 貌似tel:// 或者 tel: 都行
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        
        [self.view addSubview:callWebview];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持电话功能！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
}

- (BOOL)isPhone{
    NSString *deviceModel = [NSString stringWithString:[UIDevice currentDevice].model];
    //if(DEBUG) DLog(@"device model = %@", deviceModel);
    if ([deviceModel rangeOfString:@"iPhone"].location != NSNotFound) {
        if ([deviceModel rangeOfString:@"Simulator"].location == NSNotFound) {
            return YES;
        }
    }
    return NO;
}



#pragma mark - 获取个人信息
- (void)getPersonContent{
    /*
     /login/getCustInfo.do
     custid:用户id
     mobile:true
     */
    NSString* custid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    custid = [self convertNull:custid];
    NSDictionary *params = @{@"custid":custid,@"mobile":@"true"};
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/login/getCustInfo.do"];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:params success:^(id result) {
        //判断是否登录状态
        NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/login/getCustInfo.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
//            [self showAlert:@"未登录,请先登录!"];
            LoginNewViewController *relogVC = [[LoginNewViewController alloc] init];
            [self.navigationController pushViewController:relogVC animated:NO];
        }else{
            NSArray *array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"个人信息数据%@",array);
            if (array.count == 2) {
                NSDictionary* dict = array[0];
                if (!IsEmptyValue(dict)) {
                    _custInfoModel = [[GetCustInfoModel alloc]init];
                    [_custInfoModel setValuesForKeysWithDictionary:dict];
                }
                NSArray* addArray = array[1][@"addrlist"];
                if (!IsEmptyValue(addArray)) {
                    _addressModel = [[GetCustInfoAddressModel alloc]init];
                    for (int i = 0; i < addArray.count; i++) {
                        GetCustInfoAddressModel* model = [[GetCustInfoAddressModel alloc]init];
                        [model setValuesForKeysWithDictionary:addArray[i]];
                        if ([model.isdefault integerValue] == 1) {
                            _addressModel = model;
                        }
                    }
                }
                if (!IsEmptyValue(_custInfoModel.account)) {
                    _titleLabel.text = [NSString stringWithFormat:@"%@",_custInfoModel.account];
                }else{
                    _titleLabel.text = @"无昵称";
                }
                if (!IsEmptyValue(_custInfoModel.picname)) {
                    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@",ROOT_Path,_custInfoModel.picsrc,_custInfoModel.picname]] placeholderImage:[UIImage imageNamed:@"icon-11"]];
                }
                
                [self searchOrderStateRequest];
                
//                [self getTokenwithId:_custInfoModel.Id name:_custInfoModel.name];
            }
        }
//        [_hud hide:YES afterDelay:.5];
        
    } fail:^(NSError *error) {
        
    }];

}


//请求到的是字符串需要处理一下
- (NSString *)replaceAllOthers:(NSString *)responseString
{
    NSString * returnString = [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return returnString;
}

- (void)searchOrderStateRequest
{
/*
 /order/searchOrderState.do
 mobile:true
 data{
 custid ：当前用户id
 }
 */
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/order/searchOrderState.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"custid\":\"%@\"}",userid];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/order/searchOrderState.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/order/searchOrderState.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            SearchOrderStateModel* model = [[SearchOrderStateModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            model.unpaycounts = [self convertNull:model.unpaycounts];
            model.ungetcounts = [self convertNull:model.ungetcounts];
            model.uncommentcounts = [self convertNull:model.uncommentcounts];
            model.allcounts = [self convertNull:model.allcounts];
            model.unsendcounts = [self convertNull:model.unsendcounts];
            _iconesArr = @[[NSString stringWithFormat:@"%@",model.allcounts],[NSString stringWithFormat:@"%@",model.unpaycounts],[NSString stringWithFormat:@"%@",model.unsendcounts],[NSString stringWithFormat:@"%@",model.ungetcounts],[NSString stringWithFormat:@"%@",model.uncommentcounts]];
            [_iconeCollView reloadData];
            
        }
    } fail:^(NSError *error) {
        
    }];
    
}


- (void)getTokenwithId:(NSString*)userid name:(NSString*)name
{
    /*
     /rongcloud/getToken.do
     mobile:true
     data{
     id:客户id
     name:客户名字
     }
     */
    userid = [self convertNull:userid];
    name = [self convertNull:name];
    //获取token
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/rongcloud/getToken.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"id\":\"%@\",\"name\":\"%@\"}",userid,name];
    NSDictionary* params = @{@"data":datastr,@"mobile":@"true"};
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* restr = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([restr rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getToken.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            //            NSRange range = {1,restr.length - 2};
            //            NSString *str  = [restr substringWithRange:range];
            //            str = [self replaceAllOthers:str];
            //            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSString* token = dict[@"token"];
            NSLog(@"转换===%@",token);
            // 连接融云服务器。
            // 设置 deviceToken。
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", (long)status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}





@end
