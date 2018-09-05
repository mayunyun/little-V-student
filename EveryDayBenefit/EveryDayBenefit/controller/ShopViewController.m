//
//  ShopViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ShopViewController.h"
#import "BuyCarCell.h"
#import "LoginNewViewController.h"


@interface ShopViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView* _deleteView;
    UILabel* _totalLabel;
    UIImageView* _deSelectImg;
    NSMutableArray* _totalArray;
    NSMutableArray* _selectArray;
    NSMutableIndexSet* _selectIndexArray;
    BOOL _isSelectAll;
}
@property(nonatomic,strong)UIScrollView* mainScrollView;
@property(nonatomic,strong)UITableView* buyCayTableView;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalArray = [[NSMutableArray alloc]initWithArray:self.dataArray];
    _selectArray = [[NSMutableArray alloc]init];
    _selectIndexArray = [[NSMutableIndexSet alloc]init];
    self.title = @"购物车";
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    [self rightBarTitleButtonTarget:self action:@selector(rightBtnClick:) text:@"完成"];
    [self createUI];
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = LineColor;
    
    [self.view addSubview:_mainScrollView];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _mainScrollView.mj_header.automaticallyChangeAlpha = YES;
    _buyCayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - 64 - 49)];
    _buyCayTableView.delegate = self;
    _buyCayTableView.dataSource = self;
    _buyCayTableView.rowHeight = 135;
    [_mainScrollView addSubview:_buyCayTableView];
    [self setExtraCellLineHidden:_buyCayTableView];
    //-------------编辑删除----------------
    _deleteView=[[UIView alloc]initWithFrame:CGRectMake(0, mScreenHeight - 64 - 49, mScreenWidth, 49)];
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
    
    UILabel *totalTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 50, 49)];
    totalTitle.text = @"合计: ¥";
    totalTitle.textColor = [UIColor blackColor];
    totalTitle.font = [UIFont systemFontOfSize:14];
    [_deleteView addSubview:totalTitle];
    //合计的金额
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(deAllSelect.right + 50, 0, mScreenWidth - 200, 49)];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.textColor = [UIColor blackColor];
    [_deleteView addSubview:_totalLabel];


    UIButton * deletebtn = [[UIButton alloc]initWithFrame:CGRectMake(mScreenWidth - 80, 0, 80, 49)];
    deletebtn.selected = NO;
    deletebtn.backgroundColor = [UIColor redColor];
    [deletebtn setTitle:@"删除" forState:UIControlStateNormal];
    [deletebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deleteView addSubview:deletebtn];
    [deletebtn addTarget:self action:@selector(debtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)deAllSelect:(UIButton*)sender
{
    
    if (_isSelectAll == YES) {
        //取消全部选中
        for (int i = 0 ;i < _totalArray.count ;i++) {
            BuyCarModel *model = _totalArray[i];
            model.select = @"0";
            _isSelectAll = NO;
            _totalLabel.text = @"0.00";
            [_selectArray removeAllObjects];
            [_selectIndexArray removeIndex:i];
        }
        _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
        [_buyCayTableView reloadData];
    }else{
        //全部选中
        double sum = 0.00;
        for (int i = 0 ;i < _totalArray.count ;i++) {
            BuyCarModel *model = _totalArray[i];
            model.select = @"1";
            sum = sum + [model.totalprice doubleValue];
            [_selectArray addObject:model];
            [_selectIndexArray addIndex:i];
        }
        _isSelectAll = YES;
        _totalLabel.text = [NSString stringWithFormat:@"%.2f",sum];
        _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
        [_buyCayTableView reloadData];
    }

}

- (void)debtn:(UIButton*)sender
{
    [self delCartRequest:sender];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!IsEmptyValue(_totalArray)) {
        return _totalArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId1 = @"sousuo";
    BuyCarCell * cell = (BuyCarCell *)[tableView dequeueReusableCellWithIdentifier:cellId1];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BuyCarCell" owner:self options:nil]firstObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_totalArray.count != 0) {
        BuyCarModel *model = _totalArray[indexPath.row];
        cell.model = _totalArray[indexPath.row];
        UIImageView *reduceImg = [[UIImageView alloc]initWithFrame:CGRectMake(cell.imgView.right + 30, cell.priceLabel.bottom + 10 + 3, 10, 10)];
        reduceImg.image = [UIImage imageNamed:@"car_reduce.png"];
        reduceImg.contentMode = UIViewContentModeScaleAspectFit;
        //reduceImg.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:reduceImg];
        //减少数量的按钮
        UIButton*btnjian = [[UIButton alloc]initWithFrame:CGRectMake(reduceImg.left - 30, 0, 40, 135)];
        btnjian.tag = indexPath.row;
        [btnjian setBackgroundColor:[UIColor clearColor]];
//        [btnjian addTarget:self action:@selector(reduceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnjian];
        //数量
        UITextField *countField = [[UITextField alloc]initWithFrame:CGRectMake(reduceImg.right, 10, 40, 125)];
        countField.userInteractionEnabled = NO;
        countField.font = [UIFont systemFontOfSize:14];
        countField.delegate = self;
        countField.tag = indexPath.row;
        countField.keyboardType = UIKeyboardTypeNumberPad;
        countField.textAlignment = NSTextAlignmentCenter;
        countField.backgroundColor= [UIColor clearColor];
        countField.text = [NSString stringWithFormat:@"%@",model.count];
        [cell.contentView addSubview:countField];
        //增加数量IMg
        UIImageView *addImg = [[UIImageView alloc]initWithFrame:CGRectMake(countField.right, cell.priceLabel.bottom + 10 + 3, 10, 10)];
        addImg.image = [UIImage imageNamed:@"car_add.png"];
        addImg.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:addImg];
        //增加数量的按钮
        UIButton * btnjia = [[UIButton alloc]initWithFrame:CGRectMake(addImg.left, 0, mScreenWidth - countField.right - 50, 135)];
        btnjia.tag = indexPath.row;
        [btnjia setBackgroundColor:[UIColor clearColor]] ;
//        [btnjia addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnjia];
        //选中按钮
        UIButton *select = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 135)];
        select.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:select];
        select.tag = indexPath.row;
        [select addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark - 选择产品的方法
- (void)selectAction:(UIButton *)btn{
    NSLog(@"选中的%zi",btn.tag);
    BuyCarModel *model = _totalArray[btn.tag];
    
    NSInteger select = [model.select integerValue];
    if (select == 1) {
        model.select = @"0";
        [_selectArray removeObject:model];
        [_selectIndexArray removeIndex:btn.tag];
    }else{
        model.select = @"1";
        [_selectArray addObject:model];
        [_selectIndexArray addIndex:btn.tag];
    }
    [_buyCayTableView reloadData];
    if (_selectArray.count == _totalArray.count) {
        _deSelectImg.image = [UIImage imageNamed:@"xuanzhong.png"];
    }else{
        _deSelectImg.image = [UIImage imageNamed:@"weixuanzhong.png"];
    }
    
}

- (void)delCartRequest:(UIButton*)sender
{
    /*
     /cart/delCart.do
     mobile:true
     data{
     ids:删除的商品
     }
     */
    sender.enabled = NO;
    NSMutableString* str = [[NSMutableString alloc]init];
    for (int i = 0; i < _selectArray.count; i++) {
        BuyCarModel *model = _selectArray[i];
        [str appendString:[NSString stringWithFormat:@"%@,",model.Id]];
    }
    [_selectArray removeAllObjects];
    NSString* idstr = str;
    NSRange range = {0,idstr.length - 1};
    if (idstr.length!=0) {
        idstr = [idstr substringWithRange:range];
    }
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/cart/delCart.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"ids\":\"%@\"}",idstr];
    NSDictionary* params = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:params success:^(id result) {
        sender.enabled = YES;
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"删除商品信息返回%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"delCart.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else if ([str rangeOfString:@"true"].location != NSNotFound){
            [self showAlert:@"删除购物车成功"];
            [_totalArray removeObjectsAtIndexes:_selectIndexArray];
            [_selectIndexArray removeAllIndexes];
            [_buyCayTableView reloadData];
            
        }else{
            [self showAlert:@"删除购物车失败"];
        }
    } fail:^(NSError *error) {
        sender.enabled = YES;
        NSLog(@"删除商品信息返回%@",error.localizedDescription);
    }];
    
}



@end
