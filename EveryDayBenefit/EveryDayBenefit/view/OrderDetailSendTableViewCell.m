//
//  OrderDetailSendTableViewCell.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/8/29.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailSendTableViewCell.h"

@implementation OrderDetailSendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.doteimgView.layer.masksToBounds = YES;
    self.doteimgView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
