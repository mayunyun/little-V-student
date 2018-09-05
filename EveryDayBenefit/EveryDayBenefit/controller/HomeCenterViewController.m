//
//  HomeCenterViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeCenterViewController.h"
#import "ServiceCenterModel.h"
#import "MBProgressHUD.h"
#import "HomevillageViewController.h"

@interface HomeCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
    NSMutableArray* _sevicecenterArray;
    MBProgressHUD* _hud;
}
@end

@implementation HomeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sevicecenterArray = [[NSMutableArray alloc]init];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:self.areaName];
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
    if (self.areaId.length!=0) {
        [self ServiceCenterRequest:self.areaId];
    }
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sevicecenterArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_sevicecenterArray.count!=0) {
        ServiceCenterModel* model = _sevicecenterArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sevicecenterArray.count!=0) {
        if (!IsEmptyValue(_sevicecenterArray)) {
            ServiceCenterModel* model = _sevicecenterArray[indexPath.row];
            HomevillageViewController* VC = [[HomevillageViewController alloc]init];
            VC.centerId = [NSString stringWithFormat:@"%@",model.Id];
            VC.centerName = [NSString stringWithFormat:@"%@",model.name];
            GetCustInfoAddressModel* addmodel = [[GetCustInfoAddressModel alloc]init];
            addmodel = self.addressmodel;
            addmodel.serviceid = [NSString stringWithFormat:@"%@",model.Id];
            addmodel.servicecenter = [NSString stringWithFormat:@"%@",model.name];
            VC.addressmodel = addmodel;
            [self.navigationController pushViewController:VC animated:YES];
            [[NSUserDefaults standardUserDefaults]setObject:VC.centerId forKey:SERVICEID];
        }
    }
}

//区域数据请求
- (void)ServiceCenterRequest:(NSString*)areaID
{
    /*
     /address/addressCenter.do
     mobile:true
     areaid
     */
    NSString* urlStr = [NSString stringWithFormat:@"%@/address/addressCenter.do?mobile=true&&areaid=%@",ROOT_Path,areaID];
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ServiceCenter%@",array);
        [_sevicecenterArray removeAllObjects];
        for (int i =0; i <array.count; i++) {
            ServiceCenterModel * model = [[ServiceCenterModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_sevicecenterArray addObject:model];
        }
        [_tbView reloadData];
        [_hud hide:YES];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [_hud hide:YES];
    }];
}



@end
