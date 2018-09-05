//
//  OrderCommListTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/25.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "OrderCommListTableViewCell.h"

@implementation OrderCommListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CALayer *layer = [self.cancelBtn layer];
    layer.borderColor = [UIColor lightGrayColor].CGColor;
    layer.borderWidth = .5f;
    layer.cornerRadius = 5.0;
    layer.masksToBounds = YES;
    CALayer *layer1 = [self.commantsBtn layer];
//    layer1.borderColor = [UIColor lightGrayColor].CGColor;
//    layer1.borderWidth = .5f;
    layer1.cornerRadius = 5.0;
    layer1.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (IBAction)cancelClick:(id)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(cancelClick:)]) {
        [_delegate cancelClick:sender];
    }
    
}

- (IBAction)commantClick:(id)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(commantClick:)]) {
        [_delegate commantClick:sender];
    }
}
@end
