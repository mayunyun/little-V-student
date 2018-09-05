//
//  MineCollectViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//
#define TwoCellHight 220
#import "MineCollectViewController.h"
#import "CommonCollectionViewCell.h"
#import "ProCollModel.h"
#import "LoginNewViewController.h"
#import "ProDetailTbViewController.h"


#define ROWS @"20"

@interface MineCollectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CommonCollectionViewCellDelegate>
{
    UICollectionView* _collView;
    NSInteger _page;
    BOOL _isSelectFinish;
    BOOL _isSelectItemimg;
    NSMutableArray* _delIDArray;
    BOOL _isSelectAll;
    //
    UIView* _deleteView;
    UIImageView* _deSelectImg;
    
}
@property (nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation MineCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    _delIDArray = [[NSMutableArray alloc]init];
    _page = 1;
    self.title = @"我的收藏";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"编辑"];
    [self dataRequest];
    [self creatUI];
}

- (void)creatUI
{
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc]init];
    flow.minimumLineSpacing = 5;
    flow.minimumInteritemSpacing = 5;
    _collView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth - 5, mScreenHeight - 64 - 10 - 49) collectionViewLayout:flow];
    _collView.backgroundColor = [UIColor clearColor];
    _collView.delegate = self;
    _collView.dataSource = self;
    [self.view addSubview:_collView];
    //下拉刷新
    _collView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        if (!IsEmptyValue(_dataArr)) {
            [_dataArr removeAllObjects];
        }
        [self dataRequest];
        // 结束刷新
        [_collView.mj_header endRefreshing];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _collView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _collView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_collView.mj_footer endRefreshing];
        
    }];
    
    //-------------编辑删除----------------
    _deleteView=[[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 64 - 49, mScreenWidth, 49)];
    _deleteView.backgroundColor = [UIColor blackColor];
    _deleteView.hidden = YES;
    [self.view addSubview:_deleteView];
    _deSelectImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 49)];
    _deSelectImg.contentMode = UIViewContentModeScaleAspectFit;
    _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    [_deleteView addSubview:_deSelectImg];
    UILabel *deSelectTitle = [[UILabel alloc] initWithFrame:CGRectMake(_deSelectImg.right, 0, 30, 49)];
    deSelectTitle.font = [UIFont systemFontOfSize:12];
    deSelectTitle.textColor = [UIColor whiteColor];
    deSelectTitle.text = @"全选";
    [_deleteView addSubview:deSelectTitle];
    UIButton *deAllSelect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deAllSelect.frame = CGRectMake(0, 0, 100, 49);
    [deAllSelect addTarget:self action:@selector(deAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteView addSubview:deAllSelect];
}

- (void)emptyUI
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake((mScreenWidth - 200)/2, (mScreenHeight - 64 - 200)/2, 200, 200)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((view.width - 100)/2, 0, 100, 100)];
    imgView.image = [UIImage imageNamed:@"kongshoucang"];
    [view addSubview:imgView];
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+5, view.width, 20)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = GrayTitleColor;
    label1.text = @"您还没有收藏过商品";
    [view addSubview:label1];
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.bottom+5, view.width, 20)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:10];
    label2.textColor = [UIColor blackColor];
    label2.text = @"已经到最底了";
    [view addSubview:label2];
}


- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    _isSelectFinish = !_isSelectFinish;
    if (_isSelectFinish == NO) {
        for (int i= 0 ; i < _dataArr.count; i++) {
            ProCollModel* model = _dataArr[i];
            if ([model.isselect integerValue] == 1) {
                [_delIDArray addObject:model];
            }
        }
        //点击编辑
        if (!IsEmptyValue(_delIDArray)) {
            [self DelProductCollectRequest:sender];
        }
        _deleteView.hidden = YES;
    }else{
        //点击完成
        [sender setTitle:@"删除" forState:UIControlStateNormal];
        [_collView reloadData];
        _deleteView.hidden = NO;
    }
    

}

- (void)deAllSelect:(UIButton*)sender
{
    
    if (_isSelectFinish == YES) {
        if (_isSelectAll == YES) {
            
            //取消全部选中
            for (ProCollModel *model in _dataArr) {
                model.isselect = @"0";
                _isSelectAll = NO;
                [_delIDArray removeAllObjects];
            }
            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
            [_collView reloadData];
            
        }else{
            //全部选中
            for (ProCollModel *model in _dataArr) {
                model.isselect = @"1";
                [_delIDArray addObject:model];
            }
            _isSelectAll = YES;
            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
            [_collView reloadData];
        }
        
    }


}


//协议中的方法，用于返回分区中的单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (IsEmptyValue(_dataArr)) {
        return 0;
    }else{
        return _dataArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{//UICollectionViewCell里的属性非常少，实际做项目的时候几乎必须以其为基类定制自己的Cell
    //    CustomCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCellID" forIndexPath:indexPath];
    static NSString *HomeSelarCellID = @"CommonCollectionViewCellID";
    
    //在这里注册自定义的XIBcell 否则会提示找不到标示符指定的cell
    UINib *nib = [UINib nibWithNibName:@"CommonCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:HomeSelarCellID];
    
    CommonCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeSelarCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    cell.imgView.image = nil;
    cell.titleLabel.text = nil;
    cell.saleCountLabel.text = nil;
    cell.prictLabel.text = nil;
    if (_isSelectFinish) {
        cell.selectImgBtn.hidden = NO;
    }else{
        cell.selectImgBtn.hidden = YES;
    }
    if (!IsEmptyValue(_dataArr)) {
        ProCollModel* model = _dataArr[indexPath.item];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
//        cell.imgView.image = [UIImage imageNamed:@"default_img_cell"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
        cell.saleCountLabel.text = [NSString stringWithFormat:@"销量%@",model.prosale];
        if ([model.isgolds integerValue] == 1) {
            if (IsEmptyValue(model.price)) {
                cell.prictLabel.text = [NSString stringWithFormat:@"金币0"];
            }else{
                cell.prictLabel.text = [NSString stringWithFormat:@"金币%@",model.price];
            }
        }else if ([model.isgolds integerValue] == 0){
            if (IsEmptyValue(model.price)) {
                cell.prictLabel.text = [NSString stringWithFormat:@"￥0"];
            }else{
                model.price = [NSString stringWithFormat:@"%@",model.price];
                cell.prictLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
            }
        }
        cell.selectImgBtn.tag = indexPath.item;
        [cell.selectImgBtn setImage:[UIImage imageNamed:@"icon-16"] forState:UIControlStateNormal];
        NSLog(@"---model.isselect---%@",model.isselect);
        __weak typeof (CommonCollectionViewCell*)weakcell = cell;
        [cell setTransVaule:^(BOOL isclick) {
            if (isclick) {
                model.isselect = @"1";
                [weakcell.selectImgBtn setImage:[UIImage imageNamed:@"icon-13"] forState:UIControlStateNormal];
            }else{
                model.isselect = @"0";
                [weakcell.selectImgBtn setImage:[UIImage imageNamed:@"icon-16"] forState:UIControlStateNormal];
            }
            NSInteger count = 0;
            for (int i = 0; i < _dataArr.count; i++) {
                ProCollModel* model = _dataArr[i];
                if ([model.isselect integerValue] == 1) {
                    count++;
                }
            }
            if (count == _dataArr.count) {
                _isSelectAll = YES;
                _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
            }else{
                _isSelectAll = NO;
                _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
            }
        }];
        if ([model.isselect integerValue] == 1) {
            [cell.selectImgBtn setImage:[UIImage imageNamed:@"icon-13"] forState:UIControlStateNormal];
        }else{
            [cell.selectImgBtn setImage:[UIImage imageNamed:@"icon-16"] forState:UIControlStateNormal];
        }
        
    }
    return cell;
}


#pragma mark ---UIcollectionViewLayoutDelegate
//协议中的方法，用于返回单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((mScreenWidth - 20)/2, TwoCellHight*HightRuler);
}

//协议中的方法，用于返回整个CollectionView上、左、下、右距四边的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //上、左、下、右的边距
    return UIEdgeInsetsMake(5, 5, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArr.count!=0) {
        ProCollModel* model = _dataArr[indexPath.item];
        ProDetailTbViewController* detailVC = [[ProDetailTbViewController alloc]init];
        if (!IsEmptyValue(model.proid)) {
            if ([model.isgolds integerValue] == 0) {
                detailVC.proid = model.proid;
                detailVC.typepro = typeProGoods;
                [self.navigationController pushViewController:detailVC animated:YES];
            }else{
                detailVC.proid = model.proid;
                detailVC.typepro = typeProPoint;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
}


- (void)dataRequest
{
    /*
     /product/searchproductcollect.do
     mobile:true
     data{
     provinceid
     cityid
     areaid
     custid
     page
     rows
     }
     */
    if (_page == 1) {
        [_dataArr removeAllObjects];
    }
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
#pragma mark provinceid&cityid&areaid
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/searchproductcollect.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    NSString* datastr = [NSString stringWithFormat:@"{\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\",\"custid\":\"%@\",\"page\":\"%@\",\"rows\":\"%@\"}",provinceid,cityid,areaid,userid,[NSString stringWithFormat:@"%li",(long)_page],ROWS];
    [params setObject:datastr forKey:@"data"];
    
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"收藏列表查询返回str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"list"];
            if (array.count!=0) {
                for (NSDictionary* dict in array) {
                    ProCollModel* model = [[ProCollModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [_dataArr addObject:model];
                }
            }
            [_collView reloadData];
            if (_dataArr.count == 0) {
                [self emptyUI];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"收藏列表失败返回%@",error.localizedFailureReason);
        [self showAlert:error.localizedFailureReason];
    }];
}

- (void)DelProductCollectRequest:(UIButton*)sender{
    /*
     /product/delproductcollect.do
     mobile:true
     data{
     ids:1,2,3
     custid:用户id
     }
     */
    NSMutableString* delestr = [[NSMutableString alloc]initWithString:@""];
    for (int i = 0; i < _delIDArray.count; i++) {
        ProCollModel* model = _delIDArray[i];
        NSString* str = [NSString stringWithFormat:@"%@,",model.Id];
        [delestr appendString:str];
    }
    NSString* idstr = delestr;
    NSRange range = {0,idstr.length - 1};
    idstr = [idstr substringWithRange:range];
    
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/delproductcollect.do"];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"true" forKey:@"mobile"];
    NSString* userstr = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userstr = [self convertNull:userstr];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\",\"custid\":\"%@\"}",idstr,userstr];//,\"\":\"\"
    [params setObject:datastr forKey:@"data"];
    NSLog(@"删除收藏传参数%@",params);
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"删除收藏返回str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"getAllProductType.do重新登录");
            [self showAlert:@"登录失效请重新登录"];
            LoginNewViewController* VC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:VC animated:NO];
            
        }else{
            if ([str rangeOfString:@"true"].location != NSNotFound) {
                [self showAlert:@"删除收藏成功"];
                [sender setTitle:@"编辑" forState:UIControlStateNormal];
                [_delIDArray removeAllObjects];
                if (_isSelectAll == YES) {
                    _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
                }
                _page = 1;
                [self dataRequest];
            }else{
                [self showAlert:@"删除收藏不成功"];
            }
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        [self showAlert:error.localizedDescription];
        NSLog(@"删除收藏失败%@",error.localizedDescription);
    }];
    
}




@end
