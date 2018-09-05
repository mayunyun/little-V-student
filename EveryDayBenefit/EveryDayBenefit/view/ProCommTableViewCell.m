//
//  ProCommTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/17.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ProCommTableViewCell.h"

@implementation ProCommTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    NSDictionary* atrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize size1 =  [self.detailLabel.text boundingRectWithSize:CGSizeMake(self.detailLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrDict context:nil].size;
    NSLog(@"size.width-----=%f, size.height-----=%f", size1.width, size1.height);
    self.detailLabelHight.constant = size1.height+20;
//    if (_transValue) {
//        _transValue(size1.height);
//    }
    
}

- (void)updateFonts
{
    self.detailLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

@end
