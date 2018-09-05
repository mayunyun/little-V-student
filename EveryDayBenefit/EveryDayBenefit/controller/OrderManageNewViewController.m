//
//  OrderManageNewViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/19.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderManageNewViewController.h"
#define cellHight 110
#import "MBProgressHUD.h"

@interface OrderManageNewViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIButton *_selectButton;
    UIScrollView* _groundScrollView;
    UITableView* _tbView;//全部评价
    UITableView* _willtbView;
    UITableView* _ingtbView;
    UITableView* _edtbView;
    UITableView* _protableView;
    NSString* _selectFlag;
    NSInteger _page;
}
@property (nonatomic,strong)NSMutableArray* btnArray;
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)NSMutableArray* willDataArray;
@property (nonatomic,strong)NSMutableArray* ingDataArray;
@property (nonatomic,strong)NSMutableArray* edDataArray;
@property (nonatomic,strong)NSMutableDictionary* offscreenCells;


@end

@implementation OrderManageNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarTitleButtonItemTarget:self action:@selector(backClick:) text:@"我的订单"];
    _btnArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _willDataArray = [[NSMutableArray alloc]init];
    _edDataArray = [[NSMutableArray alloc]init];
    _ingDataArray = [[NSMutableArray alloc]init];
    _offscreenCells = [[NSMutableDictionary alloc]init];
    _page = 1;
    _selectFlag = @"";
    self.title = @"商品评价";
    [self creatUI];
    
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatUI
{
    self.view.backgroundColor = BackGorundColor;
    UIView* btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    NSArray* titleLabelArr = @[@"全部",@"待配送",@"配送中",@"已完成"];
    CGFloat width = (mScreenWidth - 50)/titleLabelArr.count;
    CGFloat gapWidth = 10;
    for (int i = 0; i < titleLabelArr.count; i ++) {
        UIButton* titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = [UIColor whiteColor];
        titleBtn.tag = 100+i;
        titleBtn.frame = CGRectMake(gapWidth+width*i+gapWidth*i, 0, width, btnView.height);
        [btnView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleBtn.width, 25)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.tag = 200+i;
        titleLabel.text = titleLabelArr[i];
        [titleBtn addSubview:titleLabel];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, titleBtn.bottom - 1, titleBtn.width, 2)];
        line.tag = 400+i;
        [titleBtn addSubview:line];
        [_btnArray addObject:titleBtn];
        if (titleBtn.tag == 100) {
            _selectButton = titleBtn;
            _selectButton.selected = YES;
            titleLabel.textColor = [UIColor redColor];
            line.backgroundColor = [UIColor redColor];
        }
        
    }
    
    _groundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnView.bottom+10, mScreenWidth,mScreenHeight - 64 - 50)];
    _groundScrollView.delegate = self;
    _groundScrollView.bounces = NO;
    _groundScrollView.pagingEnabled = YES;
    _groundScrollView.alwaysBounceVertical = NO;
    _groundScrollView.contentSize = CGSizeMake(mScreenWidth*4, mScreenHeight - 64 - 50);
    [self.view addSubview:_groundScrollView];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth,_groundScrollView.height)];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.rowHeight = 150;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_tbView];
    
    _willtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, _groundScrollView.height)];
    _willtbView.delegate = self;
    _willtbView.dataSource = self;
    _willtbView.rowHeight = 150;
    _willtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_willtbView];
    
    _edtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth*3, 0, mScreenWidth, _groundScrollView.height)];
    _edtbView.delegate = self;
    _edtbView.dataSource = self;
    _edtbView.rowHeight = 150;
    _edtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_edtbView];
    
    _ingtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth*2, 0, mScreenWidth, _groundScrollView.height)];
    _ingtbView.delegate = self;
    _ingtbView.dataSource = self;
    _ingtbView.rowHeight = 150;
    _ingtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_ingtbView];
    _tbView.estimatedRowHeight = 50.0f;
    _tbView.rowHeight = UITableViewAutomaticDimension;
    _willtbView.estimatedRowHeight = 50.0f;
    _willtbView.rowHeight = UITableViewAutomaticDimension;
    _ingtbView.estimatedRowHeight = 50.0;
    _ingtbView.rowHeight = UITableViewAutomaticDimension;
    _edtbView.estimatedRowHeight = 50.0;
    _edtbView.rowHeight = UITableViewAutomaticDimension;
}

- (void)titleBtnClick:(UIButton*)sender
{
    
    if (sender != _selectButton)
    {
        _selectButton.selected = NO;
        _selectButton = sender;
        
    }
    _selectButton.selected = YES;
    [_groundScrollView setContentOffset:CGPointMake((sender.tag-100) * mScreenWidth, 0) animated:YES];
    for (int i = 0; i < 4; i++) {
        UILabel* titleLabel = (UILabel*)[self.view viewWithTag:200+i];
        UILabel* detailLabel = (UILabel*)[self.view viewWithTag:300+i];
        UIView* line = (UIView*)[self.view viewWithTag:400+i];
        titleLabel.textColor = GrayTitleColor;
        detailLabel.textColor = GrayTitleColor;
        line.backgroundColor = [UIColor clearColor];
    }
    
    UILabel* titleLabel = (UILabel*)[sender viewWithTag:200+sender.tag - 100];
    UILabel* detailLabel = (UILabel*)[sender viewWithTag:300+sender.tag - 100];
    UIView* line = (UIView*)[sender viewWithTag:400+sender.tag - 100];
    titleLabel.textColor = [UIColor redColor];
    detailLabel.textColor = [UIColor redColor];
    line.backgroundColor = [UIColor redColor];
    switch (sender.tag) {
        case 100:
        {
            _selectFlag = @"";
            [self updateEvaluateRequest];
        }
            break;
        case 101:
        {
            _selectFlag = @"3";
            [self updateEvaluateRequest];
        }
            break;
        case 102:
        {
            _selectFlag = @"2";
            [self updateEvaluateRequest];
        }
            break;
        case 103:
        {
            _selectFlag = @"1";
            [self updateEvaluateRequest];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //随着整页滑动的相关栏目的变色及移动  对应起来好看！
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else {
        for (int i = 0; i < 4; i++) {
            UILabel* titleLabel = (UILabel*)[self.view viewWithTag:200+i];
            UILabel* detailLabel = (UILabel*)[self.view viewWithTag:300+i];
            UIView* line = (UIView*)[self.view viewWithTag:400+i];
            titleLabel.textColor = GrayTitleColor;
            detailLabel.textColor = GrayTitleColor;
            line.backgroundColor = [UIColor clearColor];
        }
        NSLog(@"scroView%f",scrollView.contentOffset.x);
        int i = scrollView.contentOffset.x/mScreenWidth;
        
        for (int j = 0; j < _btnArray.count; j++) {
            if (j == i) {
                if (_btnArray[i] != _selectButton) {
                    _selectButton.selected = NO;
                    _selectButton = _btnArray[i];
                }
                _selectButton.selected = YES;
                UILabel* titleLabel = (UILabel*)[_selectButton viewWithTag:200+_selectButton.tag - 100];
                UILabel* detailLabel = (UILabel*)[_selectButton viewWithTag:300+_selectButton.tag - 100];
                UIView* line = (UIView*)[_selectButton viewWithTag:400+_selectButton.tag - 100];
                titleLabel.textColor = [UIColor redColor];
                detailLabel.textColor = [UIColor redColor];
                line.backgroundColor = [UIColor redColor];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tbView) {
        if (IsEmptyValue(_dataArray)) {
            return 0;
        }else{
            return _dataArray.count;
        }
    }else if (tableView == _willtbView){
        if (IsEmptyValue(_willDataArray)) {
            return 0;
        }else{
            return _willDataArray.count;
        }
        
    }else if (tableView == _ingtbView){
        if (IsEmptyValue(_ingDataArray)) {
            return 0;
        }else{
            return _ingDataArray.count;
        }
    }else{
        if (IsEmptyValue(_edDataArray)) {
            return 0;
        }else{
            return _edDataArray.count;
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        if (IsEmptyValue(_dataArray)) {
            return 0;
        }else{
            return _dataArray.count*cellHight;
        }
    }else if (tableView == _willtbView){
        if (IsEmptyValue(_willDataArray)) {
            return 0;
        }else{
            return _willDataArray.count*cellHight;
        }
        
    }else if (tableView == _ingtbView){
        if (IsEmptyValue(_ingDataArray)) {
            return 0;
        }else{
            return _ingDataArray.count*cellHight;
        }
    }else{
        if (IsEmptyValue(_edDataArray)) {
            return 0;
        }else{
            return _edDataArray.count*cellHight;
        }
        
    }
    
}

- (CGFloat)detailLabelHeight:(NSString*)text width:(CGFloat)width fontsize:(NSInteger)index
{
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:index]};
    CGSize size1 =  [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    return size1.height+20;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    if (tableView == _tbView) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _willtbView){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _ingtbView){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _edtbView){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

//首行缩进
- (void)resetContent:(UILabel*)label text:(NSString*)text{
    //    NSString *_test  =  @"首行缩进根据字体大小自动调整 间隔可自定根据需求随意改变。。。。。。。" ;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;  //对齐
    paraStyle01.headIndent = 0.0f;//行首缩进
    //参数：（字体大小17号字乘以2，34f即首行空出两个字符）
    CGFloat emptylen = label.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;//首行缩进
    paraStyle01.tailIndent = 0.0f;//行尾缩进
    paraStyle01.lineSpacing = 2.0f;//行间距
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    
    label.attributedText = attrText;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tbView) {
        
    }else if (tableView == _willtbView){
        
    }else if (tableView == _ingtbView){
        
    }else if (tableView ==_edtbView){
        
    }
}

- (void)updateEvaluateRequest
{

}


@end
