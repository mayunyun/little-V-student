//
//  MineNewCollectTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 17/1/16.
//  Copyright © 2017年 济南联祥技术有限公司. All rights reserved.
//

#import "MineNewCollectTableViewCell.h"

@implementation MineNewCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addBuyCarClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addBuyCarClick:)]) {
        [_delegate addBuyCarClick:sender];
    }
}


@end
