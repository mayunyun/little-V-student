//
//  MineCollectionViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/18.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "MineCollectionViewCell.h"

@implementation MineCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.megLabel.numberOfLines = 0;
    self.megLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

@end
