//
//  CommonCollectionViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/8/11.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "CommonCollectionViewCell.h"

@interface CommonCollectionViewCell ()
{
    BOOL _isClick;
}
@end

@implementation CommonCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _isClick = NO;
//    _titleLabel.numberOfLines = 0;
//    _titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)selectClick:(id)sender {
    _isClick = !_isClick;
    if (_transVaule) {
        _transVaule(_isClick);
    }
//    if (_delegate && [_delegate respondsToSelector:@selector(selectproItemClick:)]) {
//        [_delegate selectproItemClick:sender];
//    }
}


@end
