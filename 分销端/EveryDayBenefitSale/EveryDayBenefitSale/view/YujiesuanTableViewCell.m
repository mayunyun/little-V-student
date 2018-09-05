//
//  YujiesuanTableViewCell.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/11/16.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "YujiesuanTableViewCell.h"

@implementation YujiesuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.danjuhaoLabel.numberOfLines = 0;
    self.danjuhaoLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
