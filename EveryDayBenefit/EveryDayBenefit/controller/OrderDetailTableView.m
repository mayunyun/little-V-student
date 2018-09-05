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
        if ([model.isgolds integerValue] == 1) {
            if (!IsEmptyValue1(model.price)) {
                cell.priceLabel.text = [NSString stringWithFormat:@"金币%@",model.price];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"金币0"];
            }
            
        }else{
            if (!IsEmptyValue1(model.price)) {
                model.price = [NSString stringWithFormat:@"%@",model.price];
                cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
            }else{
                cell.priceLabel.text = [NSString stringWithFormat:@"￥0"];
            }
        }
        if (!IsEmptyValue1(model.count)) {
            cell.countLabel.text = [NSString stringWithFormat:@"数量:%@",model.count];
        }else{
            cell.countLabel.text = [NSString stringWithFormat:@"数量:0"];
        }
        if (!IsEmptyValue1(model.type)) {
            cell.typeLab.text = [NSString stringWithFormat:@"规格:%@",model.type];
        }else{
            cell.typeLab.text = [NSString stringWithFormat:@""];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击的是%ld个产品",(long)indexPath.row);
}

//-(NSString*)convertNull:(id)object{
//    
//    // 转换空串
//    
//    if ([object isEqual:[NSNull null]]) {
//        return @"";
//    }
//    else if ([object isKindOfClass:[NSNull class]])
//    {
//        return @"";
//    }
//    else if (object==nil){
//        return @"";
//    }
//    return object;
//    
//}

@end
