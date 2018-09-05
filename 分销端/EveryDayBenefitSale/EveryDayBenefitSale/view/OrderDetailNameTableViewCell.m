//
//  OrderDetailNameTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/19.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderDetailNameTableViewCell.h"

@implementation OrderDetailNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}



- (IBAction)selectBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(selectAddBtnClick:)]) {
        [_delegate selectAddBtnClick:sender];
    }
    
}
@end
