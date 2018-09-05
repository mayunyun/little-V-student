//
//  OrderDetailTableView.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailTableView.h"
#import "OrderDetailProTableViewCell.h"
#import "OrderDetailProTbViewModel.h"

@implementation OrderDetailTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        _tableView.bounces = YES;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height/_dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"OrderDetailProTableViewCellID";
    OrderDetailProTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailProTableViewCell" owner:self options:nil]firstObject];
    }
    
    if (_dataArray.count!=0) {
        OrderDetailProTbViewModel* model = _dataArray[indexPath.row];
        //        model.folder = [self convertNull:model.folder];
        //        model.picname = [self convertNull:model.picname];
        //        model.proname = [self convertNull:model.proname];
        //        model.price = [self convertNull:model.price];
        //        model.count = [self convertNull:model.count];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",Image_Path,model.folder,model.picname]] placeholderImage:[UIImage imageNamed:@"default_img_cell"]];
        cell.titleLabel.text = [NSString stringWithFormat:@"名称:%@",model.proname];
        if (!IsEmptyValue1(model.price)) {
            model.price = [NSString stringWithFormat:@"%@",model.price];
            if ([model.isgolds integerValue] == 1) {
                cell.priceLabel.text = [NSString stringWithFormat:@"金币%@",model.price];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
            }
        }
        
        cell.countLabel.text = [NSString stringWithFormat:@"数量:%@",model.count];
        cell.sendTimeLabel.text = [NSString stringWithFormat:@"%@",model.sendtime];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的是%ld个产品",(long)indexPath.row);
}



@end
