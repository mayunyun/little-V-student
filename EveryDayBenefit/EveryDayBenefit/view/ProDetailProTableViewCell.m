//
//  ProDetailProTableViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/9/5.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ProDetailProTableViewCell.h"

@interface ProDetailProTableViewCell ()
{
    BOOL _isClick;
}
@end
@implementation ProDetailProTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _isClick = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)collImgViewBtnClick:(id)sender {
    
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick);
    }
    
}




@end
