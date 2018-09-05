//
//  PeopleOnLineViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "PeopleOnLineViewController.h"
#import "MineTableViewCell.h"

#import <RongIMKit/RongIMKit.h>
//#import "RCConversationViewController.h"//融云
#import "PeopleOnLineModel.h"
#import "LoginNewViewController.h"
#import "PeopleOnLineNewModel.h"
#import "PeopleOnlineTableViewCell.h"
#import "SevenAddressPickerView.h"


@interface PeopleOnLineViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMUserInfoDataSource>
{
    UITableView* _tbView;
    UIView* _myAleartView;
    NSMutableArray* _hefuListArray;
    
}
@property (nonatomic,strong)NSArray* imgArray;
@property (nonatomic,strong)NSArray* titleArray;
@property (nonatomic,strong)UITableView* kehutbView;

@end

@implementation PeopleOnLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hefuListArray = [[NSMutableArray alloc]init];
    self.title = @"在线客服";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
//    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"测试"];
    _imgArray = @[@"dingdan",@"shouhou",@"wuliu"];
    _titleArray = @[@"订单咨询",@"售后咨询",@"配送咨询"];
    [self creatUI];
    
}
- (void)rightBarClick:(UIButton*)sender
{
    [_grayView showView];
    [self addressAleartView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    UIView* leftline = [[UIView alloc]initWithFrame:CGRectMake(10, 15, (mScreenWidth - 20 - 110)/2, 1)];
    leftline.backgroundColor = LineColor;
    [self.view addSubview:leftline];
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftline.right, 0, 110, 30)];
    titleLabel.text = @"请选择资讯的问题";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = GrayTitleColor;
    [self.view addSubview:titleLabel];
    UIView* rightline = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.right, leftline.top, leftline.width, leftline.height)];
    rightline.backgroundColor = LineColor;
    [self.view addSubview:rightline];
    
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+5, mScreenWidth, mScreenHeight - 64 - titleLabel.height - 5) style:UITableViewStylePlain];
    _tbView.delegate= self;
    _tbView.dataSource = self;
    _tbView.bounces = NO;
    _tbView.showsVerticalScrollIndicator = NO;
    _tbView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tbView];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        return 3;
    }else if (tableView == _kehutbView){
        if (!IsEmptyValue(_hefuListArray)) {
            return _hefuListArray.count;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MineTableViewCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:self options:nil]firstObject];
        
    }
    PeopleOnlineTableViewCell* onlineCell = [tableView dequeueReusableCellWithIdentifier:@"PeopleOnlineTableViewCellID"];
    if (!onlineCell) {
        onlineCell = [[[NSBundle mainBundle]loadNibNamed:@"PeopleOnlineTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (tableView == _tbView) {
        cell.imgView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView == _kehutbView){
        if (!IsEmptyValue(_hefuListArray)) {
            PeopleOnLineNewModel* model = _hefuListArray[indexPath.row];
            onlineCell.nameLabel.text = [NSString stringWithFormat:@"%@",model.custname];
            if ([model.type integerValue] == 0) {
                onlineCell.typeLabel.text = @"订单咨询";
            }else if([model.type integerValue] == 1){
                onlineCell.typeLabel.text = @"售后咨询";
            }else if([model.type integerValue] == 2){
                onlineCell.typeLabel.text = @"配送咨询";
            }
            if ([model.status integerValue] == 0) {
                 onlineCell.statusLabel.text = @"离线";
            }else if ([model.status integerValue] == 1) {
                 onlineCell.statusLabel.text = @"在线";
            }
            
        }
        return onlineCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        [self creatKhCustUI];
        [self checkOnLineRequest:indexPath.row];
        if (indexPath.row == 0) {
            //        [self getTargetId];
            
            
        }else if (indexPath.row == 1){
                //登录融云服务器,开始阶段可以先从融云API调试网站获取，之后token需要通过服务器到融云服务器取。
                NSString*token=@"v8CoeyuzCf4GeXjFiPVp/mTGXnTi1tDYi4kLLpfA/sH5M9Lu2ZdsD0W5qVNphyN1Tj1Yq35jlXm1tJMpwnhPkA==";
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
                    [[RCIM sharedRCIM] setUserInfoDataSource:self];
                    NSLog(@"Login successfully with userId: %@.", userId);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //新建一个聊天会话View Controller对象
                        RCConversationViewController *chat = [[RCConversationViewController alloc]init];
                        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
                        chat.conversationType = ConversationType_CUSTOMERSERVICE;
                        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
                        chat.targetId = @"targetIdYouWillChatIn";
                        //设置聊天会话界面要显示的标题
                        chat.title = @"**客服";
                        //显示聊天会话界面
                        [self.navigationController pushViewController:chat animated:YES];
                    });
        
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"login error status: %ld.", (long)status);
                } tokenIncorrect:^{
                    NSLog(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
                }];
        }else if(indexPath.row == 2){
            
        }

    }else if (tableView == _kehutbView){
        if (!IsEmptyValue(_hefuListArray)) {
            PeopleOnLineNewModel* model = _hefuListArray[indexPath.row];
            //新建一个聊天会话View Controller对象
            RCConversationViewController *chat = [[RCConversationViewController alloc]init];
            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
            chat.conversationType = ConversationType_PRIVATE;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//             model.custname = [model.custname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            chat.targetId = [NSString stringWithFormat:@"*%@*%@",model.custid,model.custname];
            NSLog(@"chat.targetId%@",chat.targetId);
            //设置聊天会话界面要显示的标题
            chat.title = [NSString stringWithFormat:@"%@",model.custname];
            //显示聊天会话界面
            [self.navigationController pushViewController:chat animated:YES];
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
        }
    }
}


- (void)getTargetId
{
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/rongcloud/getFriendsList.do"];
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:nil success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getFriendsList.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (array.count!=0) {
                NSDictionary* dict = array[0];
                PeopleOnLineModel* model = [[PeopleOnLineModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                //新建一个聊天会话View Controller对象
                RCConversationViewController *chat = [[RCConversationViewController alloc]init];
                //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
                chat.conversationType = ConversationType_CUSTOMERSERVICE;
                //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
                chat.targetId = model.custid;
                //设置聊天会话界面要显示的标题
                chat.title = [NSString stringWithFormat:@"%@",model.kefuname];
                //显示聊天会话界面
                [self.navigationController pushViewController:chat animated:YES];
            }
        }
    } fail:^(NSError *error) {
    }];
}
- (void)checkOnLineRequest:(NSInteger)index
{
/*
 /rongcloud/checkonline.do
 mobile:true
 data{
  kehustatus 0,1,2订单咨询，售后咨询，配送咨询//kehustatus
 }
 */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/rongcloud/checkonline.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"kehustatus\":\"%@\"}",[NSString stringWithFormat:@"%li",(long)index]];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"checkonline.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
//            {"code":200,"status":"0"}
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            [_hefuListArray removeAllObjects];
            if (!IsEmptyValue(array)) {
                for (int i = 0; i < array.count; i ++) {
                    PeopleOnLineNewModel*model = [[PeopleOnLineNewModel alloc]init];
                    [model setValuesForKeysWithDictionary:array[i]];
                    [_hefuListArray addObject:model];
                }
            }
            [_kehutbView reloadData];
        }
        
    } fail:^(NSError *error) {
    }];
}




- (UIView*)creatKhCustUI{
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
        _kehutbView = [[UITableView alloc]initWithFrame:CGRectMake(5, topView.bottom, windowView.width - 10, windowView.height - topView.height) style:UITableViewStylePlain];
        _kehutbView.backgroundColor = [UIColor grayColor];
        _kehutbView.delegate = self;
        _kehutbView.dataSource = self;
        [windowView addSubview:_kehutbView];
        
    }
    return _myAleartView;
}

- (void)closeAleartView:(UIButton*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (void)closeFxCustAleartView:(UITapGestureRecognizer*)sender
{
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

- (UIView*)addressAleartView
{
    if (_myAleartView == nil) {
        _myAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
        _myAleartView.backgroundColor = [UIColor clearColor];
        //        [APPDelegate.window addSubview:_myAleartView];
        [self.view addSubview:_myAleartView];
        UIImageView* grayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _myAleartView.width, _myAleartView.height)];
        grayView.userInteractionEnabled = YES;
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha = 0.5;
        [_myAleartView addSubview:grayView];
        UITapGestureRecognizer* garytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAleartClick:)];
        [grayView addGestureRecognizer:garytap];
        
        UIImageView* windowView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (mScreenHeight - 64 - 360)/2, _myAleartView.width-20, 360)];
        windowView.userInteractionEnabled = YES;
        windowView.backgroundColor = [UIColor whiteColor];
        [_myAleartView addSubview:windowView];
        
        UIScrollView* sView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, windowView.width, windowView.height)];
        [windowView addSubview:sView];
        
        SevenAddressPickerView* pickerView = [[SevenAddressPickerView alloc]initWithFrame:CGRectMake(0, 0, windowView.width , windowView.height)];
        [pickerView setTransVaule:^(SevenAddressPickerViewModel * model,BOOL istrue) {
            NSLog(@"-----%@%@%@%@%@%@%@",model.province,model.city,model.district,model.sevicecenter,model.village,model.comunity,model.roomnumber);
            [_myAleartView removeFromSuperview];
            _myAleartView = nil;
            [_grayView hideView];
        }];
        [sView addSubview:pickerView];
    }
    return _myAleartView;
}

- (void)closeAleartClick:(UITapGestureRecognizer*)tap
{
    [_grayView hideView];
    [_myAleartView removeFromSuperview];
    _myAleartView = nil;
}

@end
