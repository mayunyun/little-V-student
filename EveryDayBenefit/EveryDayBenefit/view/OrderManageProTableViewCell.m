//
//  OrderManageProTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/19.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderManageProTableViewCell.h"
#define cellHight 80
#import "OrderManageProProTableViewCell.h"
#import "OrderManageProlistModel.h"
@interface OrderManageProTableViewCell ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _tbView;
}

@end


@implementation OrderManageProTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _delBtn.layer.borderWidth = 1.0f;
    _delBtn.layer.masksToBounds = YES;
    _delBtn.layer.cornerRadius = 2.0;
    _delBtn.layer.borderColor = GrayTitleColor.CGColor;
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mScreenWidth, _prolistArr.count*80) style:UITableViewStylePlain];
    _tbView.userInteractionEnabled = NO;
    _tbView.bounces = NO;
    _tbView.delegate = self;
    _tbView.rowHeight = 80;
    _tbView.dataSource = self;
    [self.bgView addSubview:_tbView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"---------%lu",(unsigned long)_prolistArr.count);
    [self.bgView setFrame:CGRectMake(self.bgView.left, self.bgView.top, self.bgView.width, cellHight*_prolistArr.count)];
    self.bgViewHeight.constant = cellHight*_prolistArr.count;
    [_tbView setFrame:CGRectMake(0, 0, mScreenWidth, _prolistArr.count*80)];
    if (_transVaule) {
        _transVaule(_prolistArr);
    }
    [_tbView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!IsEmptyValue1(_prolistArr)) {
        NSLog(@"---------------%lu",(unsigned long)_prolistArr.count);
        return _prolistArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderManageProProTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderManageProProTableViewCellID"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OrderManageProProTableViewCell" owner:self options:nil].firstObject;
    }
    OrderManageProlistModel* model = [[OrderManageProlistModel alloc]init];
    [model setValuesForKeysWithDictionary:_prolistArr[indexPath.row]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",ROOT_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.proname];
    NSString* datastr = [self separateDateStr:self.dateString];
    cell.dataLabel.text = [NSString stringWithFormat:@"%@",datastr];
    cell.countLabel.text = [NSString stringWithFormat:@"%@",model.count];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%.2f元",[model.money floatValue]];
    [cell setNeedsLayout];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

- (IBAction)delBtnClick:(id)sender {
    

}

//NSString* string =@"2016-08-31“转化成数组中
- (NSString*)separateDateStr:(NSString*)str
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/ 1000.0];
    
    NSString *datastring = [formatter stringFromDate:date2];
    return datastring;
}



@end
