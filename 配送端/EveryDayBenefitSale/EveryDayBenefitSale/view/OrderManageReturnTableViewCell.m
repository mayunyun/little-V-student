//
//  OrderManageReturnTableViewCell.m
//  EveryDayBenefitSale
//
//  Created by 邱 德政 on 16/10/24.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderManageReturnTableViewCell.h"

@implementation OrderManageReturnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)initUI
{
    [self.reviewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.reviewBtn.layer.masksToBounds = YES;
    self.reviewBtn.layer.cornerRadius = 5.0;
    self.reasonBtn.layer.masksToBounds = YES;
    self.reasonBtn.layer.cornerRadius = 2.0;
    self.reasonBtn.layer.borderWidth = 1;
    self.reasonBtn.layer.borderColor = NavBarItemColor.CGColor;
}

- (IBAction)reviewBtnClick:(id)sender {
    if (_transVaule) {
        _transVaule(sender);
    }
}
- (IBAction)sendBtnClick:(id)sender {
    
    if (_transVauleSendBtn) {
        _transVauleSendBtn(sender);
    }
}
- (IBAction)reasonClick:(id)sender {
    if (_reasonBtnClick) {
        _reasonBtnClick(sender);
    }
}
@end
