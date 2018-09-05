//
//  AddressManageTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "AddressManageTableViewCell.h"

@implementation AddressManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _proLabel.adjustsFontSizeToFitWidth = YES;
    _proLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
