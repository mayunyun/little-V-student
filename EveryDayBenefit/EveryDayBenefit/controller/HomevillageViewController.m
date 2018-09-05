//
//  HomevillageViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomevillageViewController.h"
#import "VillageModel.h"
#import "MBProgressHUD.h"
#import "HomeProvViewController.h"


@interface HomevillageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _villageArray;
    UITableView* _tbView;
    MBProgressHUD* _hud;
}
@end

@implementation HomevillageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _villageArray = [[NSMutableArray alloc]init];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:self.centerName];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"定位"];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight)];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    [self.view addSubview:_tbView];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    if (self.centerId.length!=0) {
        [self VillageRequest:self.centerId];
    }
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _villageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_villageArray.count!=0) {
        VillageModel* model = _villageArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_villageArray.count!=0) {
        if (!IsEmptyValue(_villageArray)) {
            VillageModel* model = _villageArray[indexPath.row];
            GetCustInfoAddressModel* addmodel = [[GetCustInfoAddressModel alloc]init];
            addmodel = self.addressmodel;
            addmodel.villageid = [NSString stringWithFormat:@"%@",model.Id];
            addmodel.village = [NSString stringWithFormat:@"%@",model.name];
            if (_transVaule) {
                _transVaule(addmodel);
            }
            
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            
            [[NSUserDefaults standardUserDefaults]setObject:addmodel.villageid forKey:VILLAGEID];
        }
    }
}

//业务中心数据请求
- (void)VillageRequest:(NSString*)centerID
{
    NSString* urlStr = [NSString stringWithFormat:@"%@/address/addressVillage.do?mobile=true&&centerid=%@",ROOT_Path,centerID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        [_hud hide:YES];
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"VillageArray%@",array);
            for (int i =0; i <array.count; i++) {
                VillageModel* model = [[VillageModel alloc]init];
                [model setValuesForKeysWithDictionary:array[i]];
                [_villageArray addObject:model];
            }
            [_tbView reloadData];
        }
        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [_hud hide:YES];
    }];
    
}





@end
