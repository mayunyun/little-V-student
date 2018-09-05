//
//  OrderDetailOrdernoTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/10/13.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailOrdernoTableViewCell.h"

@implementation OrderDetailOrdernoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ordernoLabel.adjustsFontSizeToFitWidth = YES;
    self.ordernoLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
