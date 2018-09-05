//
//  ProCommentsViewController.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/16.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ProCommentsViewController.h"
#import "ProCommTableViewCell.h"
#import "StarsView.h"
#import "LoginNewViewController.h"
#import "SearchEvaluateModel.h"

@interface ProCommentsViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIButton *_selectButton;
    UIScrollView* _groundScrollView;
    UITableView* _tbView;//全部评价
    UITableView* _goodtbView;
    UITableView* _amongtbView;
    UITableView* _badtbView;
    NSString* _selectFlag;
    NSInteger _page;
    
}
@property (nonatomic,strong)NSMutableArray* btnArray;
@property (nonatomic,strong)NSMutableArray* dataArray;
@property (nonatomic,strong)NSMutableArray* goodDataArray;
@property (nonatomic,strong)NSMutableArray* amongDataArray;
@property (nonatomic,strong)NSMutableArray* badDataArray;
@property (nonatomic,strong)ProCommTableViewCell* cell;
@property (nonatomic,strong)NSMutableDictionary* offscreenCells;

@end

@implementation ProCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBarButtonItemTarget:self action:@selector(backClick:)];
    _btnArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _goodDataArray = [[NSMutableArray alloc]init];
    _badDataArray = [[NSMutableArray alloc]init];
    _amongDataArray = [[NSMutableArray alloc]init];
    _offscreenCells = [[NSMutableDictionary alloc]init];
    _page = 1;
    _selectFlag = @"";
    self.title = @"商品评价";
    [self creatUI];
//    [self dataRequdest];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateEvaluateRequest];
}

- (void)creatUI
{
    self.view.backgroundColor = BackGorundColor;
    UIView* btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, 50)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];

    NSArray* titleLabelArr = @[@"全部评价",@"好评",@"中评",@"差评"];
    NSArray* detailLabelArr = @[self.total,self.good,self.middle,self.bad];
//    NSArray* detailLabelArr = @[@"100",@"10",@"10",@"10"];
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
        UILabel* detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, titleBtn.width, 20)];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [UIFont systemFontOfSize:10];
        detailLabel.tag = 300+i;
        detailLabel.text = detailLabelArr[i];
        [titleBtn addSubview:detailLabel];
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, titleBtn.bottom - 1, titleBtn.width, 2)];
        line.tag = 400+i;
        [titleBtn addSubview:line];
        [_btnArray addObject:titleBtn];
        if (titleBtn.tag == 100) {
            _selectButton = titleBtn;
            _selectButton.selected = YES;
            titleLabel.textColor = [UIColor redColor];
            detailLabel.textColor = [UIColor redColor];
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
    
    _goodtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, _groundScrollView.height)];
    _goodtbView.delegate = self;
    _goodtbView.dataSource = self;
    _goodtbView.rowHeight = 150;
    _goodtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_goodtbView];
    
    _badtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth*3, 0, mScreenWidth, _groundScrollView.height)];
    _badtbView.delegate = self;
    _badtbView.dataSource = self;
    _badtbView.rowHeight = 150;
    _badtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_badtbView];
    
    _amongtbView = [[UITableView alloc]initWithFrame:CGRectMake(mScreenWidth*2, 0, mScreenWidth, _groundScrollView.height)];
    _amongtbView.delegate = self;
    _amongtbView.dataSource = self;
    _amongtbView.rowHeight = 150;
    _amongtbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_groundScrollView addSubview:_amongtbView];
    _tbView.estimatedRowHeight = 50.0f;
    _tbView.rowHeight = UITableViewAutomaticDimension;
    _goodtbView.estimatedRowHeight = 50.0f;
    _goodtbView.rowHeight = UITableViewAutomaticDimension;
    _amongtbView.estimatedRowHeight = 50.0;
    _amongtbView.rowHeight = UITableViewAutomaticDimension;
    _badtbView.estimatedRowHeight = 50.0;
    _badtbView.rowHeight = UITableViewAutomaticDimension;
}

- (void)backClick:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    }else if (tableView == _goodtbView){
        if (IsEmptyValue(_goodDataArray)) {
            return 0;
        }else{
            return _goodDataArray.count;
        }
    
    }else if (tableView == _amongtbView){
        if (IsEmptyValue(_amongDataArray)) {
            return 0;
        }else{
            return _amongDataArray.count;
        }
    }else{
        if (IsEmptyValue(_badDataArray)) {
            return 0;
        }else{
            return _badDataArray.count;
        }
    
    }
}
////如果要支持iOS7这个方法必须实现
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    
//    
//    // This project has only one cell identifier, but if you are have more than one, this is the time
//    // to figure out which reuse identifier should be used for the cell at this index path.
//    NSString *reuseIdentifier = @"ProCommTableViewCellID";
//    
//    // Use the dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
//    // it in the dictionary if one hasn't already been added for the reuse identifier.
//    // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will result
//    // in a memory leak as the cell is created but never returned from the tableView:cellForRowAtIndexPath: method!
//    ProCommTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
//    if (!cell) {
//        cell = [[ProCommTableViewCell alloc] init];
//        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
//    }
//    // Configure the cell for this indexPath
//    [cell updateFonts];
//    if (tableView == _tbView) {
//        cell.detailLabel.text = [_dataArray objectAtIndex:indexPath.row];
//    }else if (tableView == _goodtbView){
//        cell.detailLabel.text = [_goodDataArray objectAtIndex:indexPath.row];
//    }else if (tableView == _amongtbView){
//        cell.detailLabel.text = [_amongDataArray objectAtIndex:indexPath.row];
//    }else if (tableView == _badtbView){
//        cell.detailLabel.text = [_badDataArray objectAtIndex:indexPath.row];
//    }
//    
//    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    
//    // The cell's width must be set to the same size it will end up at once it is in the table view.
//    // This is important so that we'll get the correct height for different table view widths, since our cell's
//    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
//    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
//    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
//    // NOTE: if you are displaying a section index (e.g. alphabet along the right side of the table view), or
//    // if you are using a grouped table view style where cells have insets to the edges of the table view,
//    // you'll need to adjust the cell.bounds.size.width to be smaller than the full width of the table view we just
//    // set it to above. See http://stackoverflow.com/questions/3647242 for discussion on the section index width.
//    
//    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
//    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
//    // in the UITableViewCell subclass
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
//    
//    // Get the actual height required for the cell
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    // Add an extra point to the height to account for the cell separator, which is added between the bottom
//    // of the cell's contentView and the bottom of the table view cell.
//    height += 1;
//    
//    return height;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat fontsize = 13;
    CGFloat widthcell = tableView.width - 20;
    NSLog(@"widthcell----%f",widthcell);
    CGFloat cellnomal = 110;
    if (tableView == _tbView) {
        if (IsEmptyValue(_dataArray)) {
            return 0;
        }else{
            SearchEvaluateModel* model = _dataArray[indexPath.row];
            NSLog(@"heightCell%f",(cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize]));
            return cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize];

        }
    }else if (tableView == _goodtbView){
        if (IsEmptyValue(_goodDataArray)) {
            return 0;
        }else{
            SearchEvaluateModel* model = _goodDataArray[indexPath.row];
            NSLog(@"heightCell%f",(cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize]));
            return cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize];
        }
        
    }else if (tableView == _amongtbView){
        if (IsEmptyValue(_amongDataArray)) {
            return 0;
        }else{
            SearchEvaluateModel* model = _amongDataArray[indexPath.row];
            NSLog(@"heightCell%f",(cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize]));
            return cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize];
        }
    }else{
        if (IsEmptyValue(_badDataArray)) {
            return 0;
        }else{
            SearchEvaluateModel* model = _badDataArray[indexPath.row];
            NSLog(@"heightCell%f",(cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize]));
            return cellnomal+[self detailLabelHeight:model.comments width:widthcell fontsize:fontsize];
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
    static NSString* cellID = @"ProCommTableViewCellID";
    ProCommTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
       cell = [[[NSBundle mainBundle]loadNibNamed:@"ProCommTableViewCell" owner:self options:nil]firstObject];
    }
    cell.detailLabel.numberOfLines = 0;
    cell.detailLabel.font = [UIFont systemFontOfSize:13];
    if (tableView == _tbView) {
        if (!IsEmptyValue(_dataArray)) {
            SearchEvaluateModel* model = _dataArray[indexPath.row];
            NSString* imagestr = [NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.picsrc,model.picname];
            NSLog(@"---------%@",imagestr);
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.creator];
            
            for (UIView *subview in [cell.starView subviews])
            {
                [subview removeFromSuperview];
            }
            StarsView* stars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.score integerValue] highlight:[UIColor yellowColor]];
            stars.frame = CGRectMake(10, 10, 75,  10);
            [cell.starView addSubview:stars];
            
            StarsView* sendstars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.sendscore integerValue] highlight:[UIColor blueColor]];
            sendstars.frame = CGRectMake(mScreenWidth - 85, 10, 75, 10);
            [cell.starView addSubview:sendstars];
            model.comments = [self convertNull:model.comments];
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",model.comments];
            NSArray* dataArray = [self separateDateStr:[NSString stringWithFormat:@"%@",model.createtime]];
            cell.dataLabel.text = [NSString stringWithFormat:@"%@-%@-%@",dataArray[0],dataArray[1],dataArray[2]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (tableView == _goodtbView){
        if (!IsEmptyValue(_goodDataArray)) {
            
            SearchEvaluateModel* model = _goodDataArray[indexPath.row];
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.picsrc,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.creator];
            for (UIView *subview in [cell.starView subviews])
            {
                [subview removeFromSuperview];
            }
            StarsView* stars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.score integerValue] highlight:[UIColor yellowColor]];
            stars.frame = CGRectMake(10, 10, 75, 10);
            [cell.starView addSubview:stars];
            StarsView* sendstars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.sendscore integerValue] highlight:[UIColor blueColor]];
            sendstars.frame = CGRectMake(mScreenWidth - 85, 10, 75, 10);
            [cell.starView addSubview:sendstars];
            
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",model.comments];
            NSArray* dataArray = [self separateDateStr:[NSString stringWithFormat:@"%@",model.createtime]];
            cell.dataLabel.text = [NSString stringWithFormat:@"%@-%@-%@",dataArray[0],dataArray[1],dataArray[2]];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    }else if (tableView == _amongtbView){
        if (!IsEmptyValue(_amongDataArray)) {
            SearchEvaluateModel* model = _amongDataArray[indexPath.row];
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.picsrc,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.creator];
            for (UIView *subview in [cell.starView subviews])
            {
                [subview removeFromSuperview];
            }
            StarsView* stars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.score integerValue] highlight:[UIColor yellowColor]];
            stars.frame = CGRectMake(10, 10, 75, 10);
            [cell.starView addSubview:stars];
            StarsView* sendstars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.sendscore integerValue] highlight:[UIColor blueColor]];
            sendstars.frame = CGRectMake(mScreenWidth - 85, 10, 75, 10);
            [cell.starView addSubview:sendstars];
            
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",model.comments];
            NSArray* dataArray = [self separateDateStr:[NSString stringWithFormat:@"%@",model.createtime]];
            cell.dataLabel.text = [NSString stringWithFormat:@"%@-%@-%@",dataArray[0],dataArray[1],dataArray[2]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    }else{
        if (!IsEmptyValue(_badDataArray)) {
            SearchEvaluateModel* model = _badDataArray[indexPath.row];
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.picsrc,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.creator];
            for (UIView *subview in [cell.starView subviews])
            {
                [subview removeFromSuperview];
            }
            StarsView* stars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.score integerValue] highlight:[UIColor yellowColor]];
            stars.frame = CGRectMake(10, 10, 75, 10);
            [cell.starView addSubview:stars];
            StarsView* sendstars = [[StarsView alloc]initWithStarSize:CGSizeMake(10, 10) space:5 numberOfStar:[model.sendscore integerValue] highlight:[UIColor blueColor]];
            sendstars.frame = CGRectMake(mScreenWidth - 85, 10, 75, 10);
            [cell.starView addSubview:sendstars];
            
            cell.detailLabel.text = [NSString stringWithFormat:@"%@",model.comments];
            NSArray* dataArray = [self separateDateStr:[NSString stringWithFormat:@"%@",model.createtime]];
            cell.dataLabel.text = [NSString stringWithFormat:@"%@-%@-%@",dataArray[0],dataArray[1],dataArray[2]];

        }
//        [self resetContent:cell.detailLabel text:cell.detailLabel.text];
        [cell setNeedsLayout];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    }
    

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
        
    }else if (tableView == _goodtbView){
        
    }else if (tableView == _amongtbView){
        
    }else{
        
    }
}

- (void)dataRequdest
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* data = [dateFormatter stringFromDate:currentDate];
    NSString* detail = @"每天惠热卖产品页面，购物车页面的搭建，调试搜索部分搭建的页面， 商品列表，详情，全部评价页面。信合移动支付页面成功后的跳转修改，关闭订单页面判断的修改和软件更新。";
    NSDictionary* dict = [[NSDictionary alloc]init];
    dict = @{@"headerimage":@"2016021853.jpg",@"title":@"ming",@"stars":@"5",@"data":data,@"detail":detail};
    [_dataArray addObject:dict];
    [_dataArray addObject:dict];
    [_goodDataArray addObject:dict];
    [_amongDataArray addObject:dict];
    [_badDataArray addObject:dict];
    [_tbView reloadData];
    [_goodtbView reloadData];
    [_badtbView reloadData];
    [_amongtbView reloadData];
    
}

- (void)updateEvaluateRequest
{
    /*
     /evaluate/phoneSearchEvaluate.do
     mobile:true
     data{
     page
     rows
     productid:商品id
     scores:空查全部3好评2中评1差评
     }
     */
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",ROOT_Path,@"/evaluate/phoneSearchEvaluate.do"];
    NSString* datastr = [NSString stringWithFormat:@"{\"productid\":\"%@\",\"scores\":\"%@\",\"page\":\"%@\",\"rows\":\"20\"}",self.proid,_selectFlag,[NSString stringWithFormat:@"%li",(long)_page]];
    NSDictionary* parmas = @{@"mobile":@"true",@"data":datastr};
    [HTNetWorking postWithUrl:urlstr refreshCache:YES params:parmas success:^(id result) {
        NSString* str = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"searchEvaluate.do%@",str);
        if ([str rangeOfString:@"sessionoutofdate"].location != NSNotFound) {
            NSLog(@"/evaluate/phoneSearchEvaluate.do重新登录");
            LoginNewViewController* loginVC = [[LoginNewViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:NO];
        }else{
            NSArray* array = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            if (!IsEmptyValue(array)) {
                
                switch ([_selectFlag integerValue]) {
                    case 0:
                    {
                        [_dataArray removeAllObjects];
                        for (int i = 0; i < array.count; i++) {
                            SearchEvaluateModel* model = [[SearchEvaluateModel alloc]init];
                            [model setValuesForKeysWithDictionary:array[i]];
                            [_dataArray addObject:model];
                        }
                        [_tbView reloadData];
                    }
                        break;
                    case 1:{
                        [_badDataArray removeAllObjects];
                        for (int i = 0; i < array.count; i++) {
                            SearchEvaluateModel* model = [[SearchEvaluateModel alloc]init];
                            [model setValuesForKeysWithDictionary:array[i]];
                            [_badDataArray addObject:model];
                        }
                        [_badtbView reloadData];
                    }
                        break;
                    case 2:{
                        [_amongDataArray removeAllObjects];
                        for (int i = 0; i < array.count; i++) {
                            SearchEvaluateModel* model = [[SearchEvaluateModel alloc]init];
                            [model setValuesForKeysWithDictionary:array[i]];
                            [_amongDataArray addObject:model];
                        }
                        [_amongtbView reloadData];
                    }
                        break;
                    case 3:{
                        [_goodDataArray removeAllObjects];
                        for (int i = 0; i < array.count; i++) {
                            SearchEvaluateModel* model = [[SearchEvaluateModel alloc]init];
                            [model setValuesForKeysWithDictionary:array[i]];
                            [_goodDataArray addObject:model];
                        }
                        [_goodtbView reloadData];

                    }
                        break;
                        
                    default:
                        break;
                }
                
               
            }
        }
    } fail:^(NSError *error) {
        
    }];

}






@end
