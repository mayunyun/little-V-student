//
//  OrderDetailPayTypeTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailPayTypeTableViewCell.h"

@implementation OrderDetailPayTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
}


- (void)initUI
{
    self.paytypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

}

- (IBAction)paytypeBtnClick:(id)sender {
    if (_transVaule) {
        _transVaule(sender);
    }
}


@end