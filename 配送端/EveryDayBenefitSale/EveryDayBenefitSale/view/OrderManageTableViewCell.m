//
//  OrderManageTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/23.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderManageTableViewCell.h"

@interface OrderManageTableViewCell ()

@end

@implementation OrderManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)initUI
{
    [self.reviewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.reviewBtn.layer.masksToBounds = YES;
    self.reviewBtn.layer.cornerRadius = 5.0;
}

- (IBAction)reviewBtnClick:(id)sender {
    if (_transVaule) {
        _transVaule(sender);
    }
}
@end
