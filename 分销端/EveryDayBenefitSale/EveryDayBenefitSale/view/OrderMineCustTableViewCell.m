//
//  OrderMineCustTableViewCell.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 17/2/6.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderMineCustTableViewCell.h"

@implementation OrderMineCustTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moneyLabel.adjustsFontSizeToFitWidth = YES;
    self.ordernoLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
