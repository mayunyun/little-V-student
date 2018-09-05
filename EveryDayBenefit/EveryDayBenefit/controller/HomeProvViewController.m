//
//  HomeProvViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "HomeProvViewController.h"
#import "EmptyCollectionViewCell.h"
#import "ProvinceModel.h"
#import "HomeCityViewController.h"
#import "MBProgressHUD.h"
#import "CommonModel.h"

@interface HomeProvViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _groundViewHight;
    NSMutableArray* _provinceArray;
    MBProgressHUD* _hud;
}
@property (nonatomic,strong)UIScrollView* groundView;
@property (nonatomic,strong)UITextField* cityTextField;
@property (nonatomic,strong)UIView* hotCityview;
@property (nonatomic,strong)UILabel* cityTitleLabel;
@property (nonatomic,strong)UICollectionView* hotCityCollView;
@property (nonatomic,strong)UITableView* hotCityTableView;

@end

@implementation HomeProvViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _provinceArray = [[NSMutableArray alloc]init];
    [self creatNav];
    _groundViewHight = 0;
    [self creatUI];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    [self ProvinceRequest];
}


- (void)creatNav
{
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    NSArray* segArr = @[@"全部"];//,@"海外"
    UISegmentedControl* seg = [[UISegmentedControl alloc]initWithItems:segArr];
    seg.frame = CGRectMake(0, 0, 150, 30);
    seg.selectedSegmentIndex = 0;
    seg.tintColor = NavBarItemColor;
    self.navigationItem.titleView = seg;
    [seg addTarget:seg action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)creatUI
{
    _groundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64)];
    _groundView.contentSize = CGSizeMake(mScreenWidth, mScreenHeight);
    _groundView.backgroundColor = BackGorundColor;
    [self.view addSubview:_groundView];
    
    UIView* searchView = [[UIView alloc]initWithFrame:CGRectMake(15, 5, mScreenWidth - 30, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 7.0;
    [_groundView addSubview:searchView];
    UIImageView* searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 20, 20)];
    searchImgView.image = [UIImage imageNamed:@"icon-search"];
    [searchView addSubview:searchImgView];
    
    _cityTextField = [[UITextField alloc]initWithFrame:CGRectMake(searchImgView.right, 0, searchView.width - searchImgView.right, searchView.height)];
    _cityTextField.delegate = self;
    _cityTextField.placeholder = @"省份名...";
    [searchView addSubview:_cityTextField];
    
    
    UIView* cityTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, searchView.bottom+5, mScreenWidth, 49)];
    cityTitleView.backgroundColor = [UIColor whiteColor];
    [_groundView addSubview:cityTitleView];
    
    _cityTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, cityTitleView.width - 20, cityTitleView.height)];
    [cityTitleView addSubview:_cityTitleLabel];
    _cityTitleLabel.text = @"GPS定位";
    NSString* provincename = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCENAME];
    provincename = [self convertNull:provincename];
    NSString* cityname = [[NSUserDefaults standardUserDefaults]objectForKey:CITYNAME];
    cityname = [self convertNull:cityname];
    NSString* areaname = [[NSUserDefaults standardUserDefaults]objectForKey:AREANAME];
    areaname = [self convertNull:areaname];

    if (!IsEmptyValue(provincename)||!IsEmptyValue(cityname)||!IsEmptyValue(areaname)) {
        NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
        provinceid = [self convertNull:provinceid];
        NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
        cityid = [self convertNull:cityid];
        NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
        areaid = [self convertNull:areaid];
        if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
            [self showAlert:@"定位为空请在首页左上角手动定位"];
            _cityTitleLabel.text = @"GPS定位:山东省泰安市泰山区";
            [self changeTextColor:_cityTitleLabel Txt:_cityTitleLabel.text changeTxt:@"GPS定位"];
        }else{
            _cityTitleLabel.text  = [NSString stringWithFormat:@"GPS定位:%@%@%@",provincename,cityname,areaname];
            [self changeTextColor:_cityTitleLabel Txt:_cityTitleLabel.text changeTxt:@"GPS定位"];
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:CITYNAME object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }
    }else{
        _cityTitleLabel.text = @"GPS定位:山东省泰安市泰山区";
        [self changeTextColor:_cityTitleLabel Txt:_cityTitleLabel.text changeTxt:@"GPS定位"];
    }

    
    _hotCityview = [[UIView alloc]initWithFrame:CGRectMake(0, cityTitleView.bottom + 10, mScreenWidth, 250)];
//    [_groundView addSubview:_hotCityview];
    UILabel* hotTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _hotCityview.width - 20, 40)];
    hotTitleLabel.text = @"国内热门城市";
    hotTitleLabel.font = [UIFont systemFontOfSize:13];
    hotTitleLabel.textColor = GrayTitleColor;
    [_hotCityview addSubview:hotTitleLabel];
    UICollectionViewFlowLayout* hotcityLayout = [[UICollectionViewFlowLayout alloc]init];
    hotcityLayout.minimumInteritemSpacing = 10; //列间距
    hotcityLayout.minimumLineSpacing = 10;//行间距
    _hotCityCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, hotTitleLabel.bottom, mScreenWidth - 20, 210) collectionViewLayout:hotcityLayout];
    _hotCityCollView.backgroundColor = [UIColor whiteColor];
    _hotCityCollView.delegate = self;
    _hotCityCollView.dataSource = self;
    _hotCityCollView.showsHorizontalScrollIndicator = NO;
    _hotCityCollView.showsVerticalScrollIndicator = NO;
    [_hotCityview addSubview:_hotCityCollView];
    
    
    _hotCityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, mScreenWidth, mScreenHeight - 64 - 90)];
    _hotCityTableView.delegate = self;
    _hotCityTableView.dataSource = self;
    _hotCityTableView.scrollEnabled = NO;
    [_groundView addSubview:_hotCityTableView];
    
    
    
}

//改变某字符串的颜色
- (void)changeTextColor:(UILabel *)label Txt:(NSString *)text changeTxt:(NSString *)change
{
    //    NSString *str =  @"35";
    NSString *str= change;
    if ([text rangeOfString:str].location != NSNotFound)
    {
        //关键字在字符串中的位置
        NSUInteger location = [text rangeOfString:str].location;
        //长度
        NSUInteger length = [text rangeOfString:str].length;
        //改变颜色之前的转换
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:text];
        //改变颜色
        [str1 addAttribute:NSForegroundColorAttributeName value:GrayTitleColor range:NSMakeRange(location, length)];
        //赋值
        label.attributedText = str1;
    }
}


- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segClick:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _cityTextField) {
        if (![_cityTextField.text isEqualToString:@""]) {
            [self searchProvinceRequestData:_cityTextField.text];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((collectionView.width - 40)/3 , 40);
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    //    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    static NSString *HomeSelarCellID = @"EmptyCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"EmptyCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    EmptyCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = @"北京";
    [self framAdd:cell];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld个collectionVIewCell",(long)indexPath.row);
}

//格式话小数 四舍五入类型
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (void)framAdd:(id)sender
{
    CALayer *layer = [sender layer];
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = .5f;
    //    //添加四个边阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(0,0);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius = 10.0;//给imageview添加阴影和边框
    //    //添加两个边的阴影
    //    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    //    imageView.layer.shadowOffset = CGSizeMake(4,4);
    //    imageView.layer.shadowOpacity = 0.5;
    //    imageView.layer.shadowRadius=2.0;
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    }
    if (_provinceArray.count!=0) {
        ProvinceModel* model = _provinceArray[indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_provinceArray.count!=0) {
        ProvinceModel* model = _provinceArray[indexPath.row];
        model.Id = [self convertNull:model.Id];
        model.name = [self convertNull:model.name];
        HomeCityViewController* cityVC = [[HomeCityViewController alloc]init];
        cityVC.proId = [NSString stringWithFormat:@"%@",model.Id];
        cityVC.proname = [NSString stringWithFormat:@"%@",model.name];
        GetCustInfoAddressModel* addmodel = [[GetCustInfoAddressModel alloc]init];
        addmodel.provinceid = model.Id;
        addmodel.province = model.name;
        cityVC.addressmodel = addmodel;
        [self.navigationController pushViewController:cityVC animated:YES];
        [[NSUserDefaults standardUserDefaults]setObject:model.Id forKey:PROVINCEID];
        [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:PROVINCENAME];
    }
}

//省数据请求
- (void)ProvinceRequest
{
    /*
     /areamanage/loadprovinceadd.do
     */
    NSString* urlStr = @"http://124.130.131.94:8087/areamanage/loadprovince.do";
    
    [HTNetWorking postWithUrl:urlStr refreshCache:YES params:nil success:^(id result) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ProvinceArray%@",array);
        [_provinceArray removeAllObjects];
        for (int i =0; i <array.count; i++) {
            ProvinceModel* model = [[ProvinceModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_provinceArray addObject:model];
        }
        [_hotCityTableView reloadData];
        _hotCityTableView.frame = CGRectMake(0, 90, mScreenWidth, _provinceArray.count*44);
        _groundView.contentSize = CGSizeMake(mScreenWidth, 90+_provinceArray.count*44);
        [_hud hide:YES afterDelay:.5];
    } fail:^(NSError *error) {
        NSLog(@"error=====%@",error);
        [_hud hide:YES afterDelay:.5];
    }];
    
}

#pragma mark 搜索省
- (void)searchProvinceRequestData:(NSString*)str
{
    /*
     /province/searchProvince.do
     mobile:true
     data{
     name
     }
     */
    [_hud show:YES];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/province/searchProvince.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"name\":\"%@\"}",str];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/province/searchProvince.do%@",str);
        NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"ProvinceArray%@",array);
        [_provinceArray removeAllObjects];
        for (int i =0; i <array.count; i++) {
            ProvinceModel* model = [[ProvinceModel alloc]init];
            [model setValuesForKeysWithDictionary:array[i]];
            [_provinceArray addObject:model];
        }
        [_hotCityTableView reloadData];
        _hotCityTableView.frame = CGRectMake(0, 90, mScreenWidth, _provinceArray.count*44);
        _groundView.contentSize = CGSizeMake(mScreenWidth, 90+_provinceArray.count*44);
        [_hud hide:YES afterDelay:.5];
        
    } fail:^(NSError *error) {
        [_hud hide:YES];
    }];

}



@end
