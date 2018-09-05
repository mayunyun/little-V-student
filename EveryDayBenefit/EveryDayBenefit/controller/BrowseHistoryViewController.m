//
//  BrowseHistoryViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "BrowseHistoryViewController.h"
#import "OrderDetailProTableViewCell.h"
#import "LoginNewViewController.h"
#import "MBProgressHUD.h"
#import "BowseHistoryModel.h"

@interface BrowseHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    MBProgressHUD* _hud;
    NSMutableIndexSet *_indexSetToDel;
    NSMutableArray* _selectArray;
    UIView* _deleteView;
    UIImageView* _deSelectImg;
    BOOL _isSelectAll;
    BOOL _isdelectBtn;
}
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)UITableView* tbView;

@end

@implementation BrowseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.title = @"浏览历史管理";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBarClick:) text:@"删除"];
    _dataArray = [[NSMutableArray alloc]init];
    _indexSetToDel = [[NSMutableIndexSet alloc]init];
    _selectArray = [[NSMutableArray alloc]init];
    [self creatUI];

    [self dataRequest];
    //进度HUD
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //设置模式
    _hud.mode = MBProgressHUDModeIndeterminate;
    //_hud.labelText = @"网络不给力，正在加载中...";
    [_hud show:YES];
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarClick:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"删除"]) {
        _isdelectBtn = YES;
        _deleteView.hidden = NO;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [_tbView setEditing:YES animated:YES];
        [_indexSetToDel removeAllIndexes];//清空上次推出编辑状态之前选中的那些行（下标）
    }else{
        _isdelectBtn = NO;
        _deleteView.hidden = YES;
        _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        [sender setTitle:@"删除" forState:UIControlStateNormal];
        [_tbView setEditing:NO animated:YES];
#pragma mark删除接口
        if (_selectArray.count!=0) {
            [self delproductbrowerRequest];
        }
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
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tbView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tbView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _page ++ ;
        [self dataRequest];
        [_tbView.mj_footer endRefreshing];
        
    }];
    
    
    //-------------编辑删除----------------
    _deleteView=[[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 64 - 49, mScreenWidth, 49)];
    _deleteView.hidden = YES;
    _deleteView.backgroundColor = [UIColor blackColor];
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

- (void)deAllSelect:(UIButton*)sender
{
    
    if (_isdelectBtn == YES) {
        if (_isSelectAll == YES) {
            //取消全部选中
            _isSelectAll = NO;
            [_selectArray removeAllObjects];
            for (int i = 0 ;i < _dataArray.count ;i++) {
                [_indexSetToDel removeIndex:i];
                NSIndexPath * selIndex = [NSIndexPath indexPathForRow:i inSection:0];
                [_tbView deselectRowAtIndexPath:selIndex animated:YES];
            }
            _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];

        }else{
            //全部选中
            [_selectArray removeAllObjects];
            [_indexSetToDel removeAllIndexes];
            for (int i = 0 ;i < _dataArray.count ;i++) {
                [_indexSetToDel addIndex:i];
                BowseHistoryModel* model = _dataArray[i];
                [_selectArray addObject:model];
                
                NSIndexPath * selIndex = [NSIndexPath indexPathForRow:i inSection:0];
                [_tbView selectRowAtIndexPath:selIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            _isSelectAll = YES;
            _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        }

    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        if (_dataArray.count != 0) {
            return _dataArray.count;
        }else{
            return 0;
        }
    }
    return 0;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (tableView == _tbView) {
//        if (_dataArray.count != 0) {
//            return _dataArray.count;
//        }else{
//            return 0;
//        }
//    }else{
//        return 0;
//    }
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"OrderDetailProTableViewCellID";
    OrderDetailProTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailProTableViewCell" owner:self options:nil]firstObject];

    }
    if (_dataArray.count!=0) {
        BowseHistoryModel* model = _dataArray[indexPath.row];
        NSLog(@"%ld",(long)indexPath.row);
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
        cell.titleLabel.text = [NSString stringWithFormat:@"名称:%@",model.proname];
        cell.countLabel.text = [NSString stringWithFormat:@"数量:%@",model.prosale];
        if ([model.isgolds integerValue] == 1) {
            if (IsEmptyValue(model.price)) {
                cell.priceLabel.text = [NSString stringWithFormat:@"金币0"];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"金币%@",model.price];
            }
        }else{
            if (IsEmptyValue(model.price)) {
                cell.priceLabel.text = [NSString stringWithFormat:@"￥0"];
            }else{
                model.price = [NSString stringWithFormat:@"%@",model.price];
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
            }
        }
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;//表示多选状态
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_tbView.editing) {
        //是编辑状态，记录选中的行号做数组下标
        BowseHistoryModel* model = _dataArray[indexPath.row];
        model.isselect = @"1";
        [_selectArray addObject:model];
        [_indexSetToDel addIndex:indexPath.row];
    }
}

//协议中取消选中tableView中某行时被调用
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tbView.editing) {
        //把之前选中的行号扔掉
        BowseHistoryModel* model = _dataArray[indexPath.row];
        model.isselect = @"0";
        [_selectArray removeObject:model];
        [_indexSetToDel removeIndex:indexPath.row];
    }
}
- (void)dataRequest
{
   /*
    /product/searchproductbrower.do
    mobile:true
    data{
    provinceid：
    cityid：
    areaid：
    creatorid:客户id
    rows:
    page:
    }
    */
//#warning mark provinceid&cityid&areaid&_proid
    NSString* provinceid = [[NSUserDefaults standardUserDefaults]objectForKey:PROVINCEID];
    provinceid = [self convertNull:provinceid];
    NSString* cityid = [[NSUserDefaults standardUserDefaults]objectForKey:CITYID];
    cityid = [self convertNull:cityid];
    NSString* areaid = [[NSUserDefaults standardUserDefaults]objectForKey:AREAID];
    areaid = [self convertNull:areaid];
    if (IsEmptyValue(provinceid)||IsEmptyValue(cityid)||IsEmptyValue(areaid)) {
        [self showAlert:@"定位为空请在首页左上角手动定位"];
    }
    NSString* userid = [[NSUserDefaults standardUserDefaults]objectForKey:USERID];
    userid = [self convertNull:userid];
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/searchproductbrower.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"creatorid\":\"%@\",\"rows\":\"20\",\"page\":\"%@\",\"provinceid\":\"%@\",\"cityid\":\"%@\",\"areaid\":\"%@\"}",userid,[NSString stringWithFormat:@"%li",(long)_page],provinceid,cityid,areaid];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
        [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"/product/searchproductbrower.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/product/searchproductbrower.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSArray* array = dict[@"rows"];
            if (!IsEmptyValue(array)) {
                for (NSDictionary* dic in array) {
                    BowseHistoryModel* model = [[BowseHistoryModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [_tbView reloadData];
            }
            
        }
        
    [_hud hide:YES afterDelay:.5];
        } fail:^(NSError *error) {
        
    }];
    
}


- (void)delproductbrowerRequest
{
/*
 /product/delproductbrower.do
 mobile:true
 data{
 ids:1，2，3（字符串）
 }
 */
    NSMutableString* idstr = [[NSMutableString alloc]init];
    //列出NSIndexSet的值
    for (int i = 0 ; i < _selectArray.count ;i ++)  {
        BowseHistoryModel* model = _selectArray[i];
        [idstr appendString:[NSString stringWithFormat:@"%@,",model.Id]];
    }
    NSString* idsstr = idstr;
    NSRange range = {0,idsstr.length - 1};
    if (idsstr.length!=0) {
       idsstr = [idsstr substringWithRange:range];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/product/delproductbrower.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\"}",idsstr];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
        [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"str%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/product/delproductbrower.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            //从_dataSource数组中删除下标集合_indexSetToDel指定的所有下标的元素
            [_dataArray removeObjectsAtIndexes:_indexSetToDel];
            
        }else if ([str rangeOfString:@"false"].location != NSNotFound){
//            [self showAlert:@"删除历史失败"];
        }
        [_indexSetToDel removeAllIndexes];//清空集合
        [_tbView reloadData];
        
        } fail:^(NSError *error) {
        [_indexSetToDel removeAllIndexes];//清空集合
        [_tbView reloadData];
    }];

}





@end
