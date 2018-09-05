//
//  ExiteOrderCollectionViewCell.m
//  EveryDayBenefit
//
//  Created by 邱 德政 on 16/11/10.
//  Copyright © 2016年 济南联祥技术有限公司. All rights reserved.
//

#import "ExiteOrderCollectionViewCell.h"

@implementation ExiteOrderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initUI];
}

- (void)initUI
{
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.saleLabel.numberOfLines = 0;
    self.saleLabel.adjustsFontSizeToFitWidth = YES;
    self.priceLabel.numberOfLines = 0;
    self.priceLabel.adjustsFontSizeToFitWidth = YES;

}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        //选中时
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }else{
        //非选中
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Configure the view for the selected state
}

//- (void)setHighlighted:(BOOL)highlighted{
//    [super setHighlighted:highlighted];
//    self.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.contentView.backgroundColor = [UIColor lightGrayColor];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.contentView.backgroundColor = [UIColor whiteColor];
//        } completion:^(BOOL finished) {
//            self.userInteractionEnabled = YES;
//        }];
//    }];
//}

@end
